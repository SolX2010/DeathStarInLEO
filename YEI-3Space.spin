{{
''***********************************************************************************
''*  Title:                                                                         *
''*  YEI-3Space.spin                                                                *
''*  With this object you can collect interial measurement unit (IMU) & temp data.  * 
''*  Author: Blaze Sanders [blaze.sanders@solarsystemexpress.com]                   *
''*  Copyright (c) 2015 PongSat Parts LLC                                           *
''*  See end of file for terms of use.                                              *
''***********************************************************************************
''*  Brief Description:                                                             *
''*  Number of cogs/CPU's used: 1 out of 8                                          *
''*                                                                                 *   
''*  This code controls the 23 x 23 x 2.2 mm, 1.3 gram, and 1350 Hz YEI 3-Space IMU *
                                    *   
''*                                                                                 * 
''*  YEI 3-Space subsystem circuit diagram can be found at:                         *
''*  https://upverter.com/META.Blaze/5e7beb8b16d39c0e/DSIL-Mark-I/                  *
''*                                                                                 *
''*  SCK  ────── 8 Ohm speaker positive terminal                               *
''*  MISO ────── 8 Ohm speaker negative terminal                               *                                                    
''*  MOSI ────── Pin X  Serial input from host. 3.3 to 5 V TTL-level interface *                                                        *
''*  /SS  ────── Pin Y  Serial output to host. 5 V TTL-level interface         *
''*  TxD
''*  RxD                                                      *
''*  VCC  ────── +5V (VIN)                                                     *
''*  GND  ──────┐                                                               *
''*                                                                             *
''*             GND (VSS)                                                        *
''*                                                                                 *
''*  YEI 3-Space Max Power Draw: 5 V @ 60 mA  = 0.3 W                               *
''*                                                                                 *             
''*  YEI 3-Space datasheets can be found at:                                        *
''*  yeitechnology.com/sites/default/files/YEI_TSS_Users_Manual_3.0_r1_4Nov2014.pdf *
''*                                                                                 *  
''*  Based off the ??? by ??? of ????                 *
''*  www.         *
''*  Revisions:                                                                     *
''*  - Mark I (March 19, 2015): Initial release                                     * 
 ''**********************************************************************************                                                        
}}

CON 'Global Constants

CLOCK_STATE = 0
{{
The SPI interface is implemented as an SPI mode 0 slave device. This means that the SPI clock polarity is 0 (CPOL=0)
and the SPI clock phase is 0 (CPHA=0). Bytes are transferred one bit at a time with the MSB being transferred first.
The on-board SPI interface has been tested at speeds up to 6MHz. The diagram below illustrates a single complete SPI
byte transfer. Page 27 of http://www.yeitechnology.com/sites/default/files/YEI_TSS_Users_Manual_3.0_r1_4Nov2014.pdf
}}

'--YEI-3 Space hardware pins and constants--   
DATA    = 0                  
CLK     = 1                  
RESET   = 2
IMU_SERIAL_BAUD_RATE = 115200
YEI3_RXD = 0
YEI3_TXD = 1

'Useful constants
NO_DATA = 0

'Commands
TEMP_C = 43
TEMP_F = 44
CONFIDENCE_FACTOR = 45

FACTORY_SETTINGS = 224
RESET = 226
GET_SLEEP_MODE = 228
GET_HW_VERSION = 230
SET_UART_BAUD_RATE = 231
GET_UART_BAUD_RATE = 232
        

OBJ 'Additional files you would like imported / included   

'Used to output debugging statments to the Serial Terminal
'Custom PSP file updating http://obex.parallax.com/object/521 
DEBUG            : "GDB-SerialMirror"

'Used has the communicate protocal for the IMU 
SPI              : "SPI_Spin"
'SPI              : "SPI_Asm" FASTER ASSEMBLY 
SERIAL   : "FullDuplexSerial"                           ' Full Duplex Serial
  
'Used to control CPU clock timing functions
'Source URL - http://obex.parallax.com/object/173
TIMING          : "Clock"

PUB Initialize | OK

SPI.Start(15, CLOCK_STATE)  'Initialize SPI Engine with Clock Delay of 15us and Clock State of
SERIAL.Start(YEI3_RXD, YEI3_TXD, %0000, IMU_SERIAL_BAUD_RATE)

115200
{{
HIGH(Reset)                                       '' alert the DS1620
SPI.SHIFTOUT(DQ, CLK, SPI#LSBFIRST , 8, WrCfg)    '' Request Configuration Write
SPI.SHIFTOUT(DQ, CLK, SPI#LSBFIRST , 8, %10)      '' configure for ; CPU / Free-run mode
LOW(Reset)                                        '' release the DS1620
}}

PUB SendCommand(command, data) | checksum : BinaryReturn

SERIAL.TX(%1111_0111) '0xF7   Start of Packet
SERIAL.TX(

checksum := (command + data) // 256 'Modulus 256 gives checksum in the range 0 to 255.  
SERIAL.TX(checksum)
      
PUB ResetIMU

PUB ReadAllNormalSensorData    ''Normalized

PUB ReadNormalGyroscopeVector

PUB ReadNormalAccelerometerVector

PUB ReadNormalCompassVector


PUB ReadTemperatureC

SendCommand(43, NO_DATA)

PUB ReadTemperatureF

PUB ReadConfidenceFactor

PUB ReadAllRawSensorData

PUB ReadRawGyroscopeVector

PUB ReadRawAccelerometerVector

PUB ReadRawCompassVector

PUB ReadBatteryVoltage

PUB ReadBatteryPercentage

PUB ReadBatteryStatus

PUB ReadButtonState