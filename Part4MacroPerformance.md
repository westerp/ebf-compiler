# Macro expansion performance problem #
The 3 rules about optimization are **Don't**, **Don't yet** and **Profile first**. Macro expansion does 3 copying operations.
  * copy from buffer to input
  * copy from macro to buffer
  * offset move to correct buffer

The list is not in chroboligic order but the order from longest to shortest time to execute.
Actually the two first is almost identical in forms of effort since the first have slightly longer way to go and the second increments an extra value for backup.

But I'm not going to take my word for this. I benchmark it. By commenting out some code I may check what takes the longest time. I used the follwing test:

```
{a this is a macro (repeats 100 times or so)}
{b this is a macro (repeats 100 times or so)}
{c this is a macro (repeats 100 times or so)}
{d this is a macro (repeats 100 times or so)}
&a
```

### Results for the time usage during this compiling ###
![http://chart.apis.google.com/chart?chf=bg,lg,41,EFEFEF,0,BBBBBB,1&chxs=0,AA0033,11.5&chxt=x&chs=500x305&cht=p3&chco=FF0000|0000FF|FF9900&chd=s:CDA&chdl=copy+from+macro+to+buffer|copy+from+buffer+to+input|everything+else&chdlp=t&chp=3.4&chl=3.88s|4.87s|0.11s&chma=|0,10&chtt=Time+usage&type=.png](http://chart.apis.google.com/chart?chf=bg,lg,41,EFEFEF,0,BBBBBB,1&chxs=0,AA0033,11.5&chxt=x&chs=500x305&cht=p3&chco=FF0000|0000FF|FF9900&chd=s:CDA&chdl=copy+from+macro+to+buffer|copy+from+buffer+to+input|everything+else&chdlp=t&chp=3.4&chl=3.88s|4.87s|0.11s&chma=|0,10&chtt=Time+usage&type=.png)

### I did change &a to &d and got a speedier program. ###
![http://chart.apis.google.com/chart?chf=bg,lg,41,EFEFEF,0,BBBBBB,1&chxs=0,AA0033,11.5&chxt=x&chs=500x305&cht=p3&chco=FF0000|0000FF|FF9900&chd=s:BDA&chdl=copy+from+macro+to+buffer|copy+from+buffer+to+input|everything+else&chdlp=t&chp=3.4&chl=1.05s|4.54s|0.11s&chma=|0,10&chtt=Time+usage&type=.png](http://chart.apis.google.com/chart?chf=bg,lg,41,EFEFEF,0,BBBBBB,1&chxs=0,AA0033,11.5&chxt=x&chs=500x305&cht=p3&chco=FF0000|0000FF|FF9900&chd=s:BDA&chdl=copy+from+macro+to+buffer|copy+from+buffer+to+input|everything+else&chdlp=t&chp=3.4&chl=1.05s|4.54s|0.11s&chma=|0,10&chtt=Time+usage&type=.png)

This confirms my earlier thoughts that the latest macro created is the fastest expanded. The more macroes the more consuming is the buffer copying. b is one second faster than a and so on.

## What have I learned ##
Having macroes in front of buffer is expensive. It uses 1 exstra second per 1600 bytes macroes in memory. When it expands macroes the one closest to the buffer (last) moves faster than the first, again 1 second per extra 1600 bytes to move over. When that is said this is the only expensive operation we have. Compiling EBF uses 35 seconds where 30 is moving pointer to copy data over distances. It moves back and forth over 48000 bytes macro buffer. most of these are spaces and comments so we could have just checked for that first and been done with them there and there. (**jitbf** might need to be better at copying data over seeks but  how do jitbf know that a loop is symmetrical?)

Anyway. I thought we might want to read data in the buffer zone, preprosess it and if it's a literal we can just spit it out there. If not we initiate most from there. This will reduce the copying between buffer and input and we can mesure before what impact it might have by removing comments.Removing all the comments off the macroes == 11k of 17kB file we reduce the run time of compiling ebf by by to 2 seconds (from 35) even though these caracters is just printed/passed so I estimate I'll get compiling down to at least 15s. The performance tests above should have 0 time copying to input becuase they are no special charcters and will be handeled from the buffer.

## Update ##
Divide is the thing.. On average one char in the ebf.ebf source has 67 as ascii value and hench if it was in a macro the copying from input to variable would mean 67 round trips. By dividing the char in the buffer with 8 we move n/8 + n%8 turns instead. on average less than 20 every time. The pie is from the first attemt with &a. it reduces the speed of copying to input between 80-90% so it is a good thing.

![http://chart.apis.google.com/chart?chf=bg,lg,41,EFEFEF,0,BBBBBB,1&chxs=0,AA0033,11.5&chxt=x&chs=500x305&cht=p3&chco=FF0000|0000FF|FF9900&chd=s:CBA&chdl=copy+from+macro+to+buffer|copy+from+buffer+to+input|everything+else&chdlp=t&chp=3.4&chl=3.88s|1.0s|0.11s&chma=|0,10&chtt=Time+usage&type=.png](http://chart.apis.google.com/chart?chf=bg,lg,41,EFEFEF,0,BBBBBB,1&chxs=0,AA0033,11.5&chxt=x&chs=500x305&cht=p3&chco=FF0000|0000FF|FF9900&chd=s:CBA&chdl=copy+from+macro+to+buffer|copy+from+buffer+to+input|everything+else&chdlp=t&chp=3.4&chl=3.88s|1.0s|0.11s&chma=|0,10&chtt=Time+usage&type=.png)

## Update2 ##
Later in this project I actually do the switch in the buffer area and only move bytes to the variable area when it is an actual operation. Since code is very verbose this gives a even better performance gain. The bytes are still transferred divided though.

[Part5: Long variable names](Part5LongNames.md)