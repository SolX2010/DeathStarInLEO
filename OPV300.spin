{{
''***********************************************************************************
''*  Title:                                                                         *
''*  OPV300.spin                                                                    *
''*  A fun control object for a 12 mA & 1.5mW OPV300 laser diodes                   *
''*  Author: Blaze Sanders                                                          *
''*  Copyright (c) 2011 Solar System Express (Sol-X) LLC                            *
''*  See end of file for terms of use.                                              *
''***********************************************************************************
''*  Brief Description:                                                             *
''*  Number of cogs/CPU's used: 1 out of 8                                          *
''*                                                                                 *   
''*  This code controls OPV300 laser diodes, by controlling the amount of current   *
''*  sourced to the laser diodes; from a varying number on 40 mA I/O pins with      *
''*  current limiting resistors, for a set duration of time.                         *
''***********************************************************************************
''*  Circuit Diagram can be found at solarsystemexpress.com/death-star-in-leo.html  *                                                                *
''***********************************************************************************
''*  Detailed Description:                                                          *
''*  Software IDE's, datasheets, getting start guides and demo code can be found at *
''*  www.solarsystemexpress.com/software.html                                       * 
''***********************************************************************************
''*  Theory of Operation:                                                           *
''*  See YourProject.spin and GDB Hello World.spin for demos using the Pong Sat API *
''***********************************************************************************                                                        

                                        Suggested Circuit (Sol-X)
                            
  ┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬ (anade) LASER DIODE (cathode) ─┬       
  │   │   │   │   │   │   │   │   │   │   │   │                                │
                                     (Twelve 1300 Ohm resistors)   │                                                                                             
  │   │   │   │   │   │   │   │   │   │   │   │                                │                                                                           
  ┻   ┻   ┻   ┻   ┻   ┻   ┻   ┻   ┻   ┻   ┻   ┻                                 
  P0  P1  P2  P3  P4  P5  P6  P7  P8  P9  P10 P11                             0v                                              

}}

          

CON 'Global Constants 

'---Useful constants--- 
HIGH = 1
LOW = 0

OUTPUT = 1
INPUT = 0

VAR

'Boolean variable holding the state of the self destruct button
byte selfDestruct 

'Boolean variable monitoring the location of Luke SkyWalker near the Death Star   
byte lukeSkyWalker 

OBJ

'Used to control CPU clock timing functions
'Source URL - http://obex.parallax.com/object/173
TIMING          : "Clock"

PUB Initialize | OK 'Initializes all the laser diodes

selfDestruct := false
lukeSkyWalker := false    

PUB Fire(percentPower, duration, numberOfPins) : moonDestoryed | numOfPowerLevels, i 'Turns on a 1.5 mW OPV300 laser diode

''     Action: Turns on a 1.5 mW OPV300 laser diode      
'' Parameters: PercentPower -  Percent of 12 mA current input into laser 
''             Duration - Time is seconds the laser should stay on
''             NumberOfPins - Number of (12 / NumberOfPins) mA I/O pins connected to laser diode (1 to 12)                             
''    Results: Moons get destoryed (hopefully)                      
''+Reads/Uses: None                                               
''    +Writes: None
'' Local Vars: None                                     
''      Calls: None
''        URL: http://www.solarsystemexpress.com/death-star-in-leo.html

numOfPowerLevels :=  (percentPower * numberOfPins) / 100

If (selfDestruct == true OR lukeSkyWalker == true )
  moonDestoryed := false

Else
  moonDestoryed := true

  'Power UP
  Repeat i from 1 to numOfPowerLevels
    DIRA[i] := OUTPUT
    OUTA[i] := HIGH

  TIMING.PauseSec(Duration)

  'Power DOWN
  Repeat i from 1 to numOfPowerLevels
    DIRA[i] := OUTPUT
    OUTA[i] := LOW


return moonDestoryed

PUB SetLukeSkyWalkersLocation(nearDeathStar) : lukeSkyWalkerNear

if (nearDeathStar == true)
  lukeSkyWalker := true
else
  lukeSkyWalker := false

return lukeSkyWalkerNear := lukeSkyWalker   

PUB SetSelfDestructButton
