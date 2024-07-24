## Design a "PCB" (WWCB)

The Engineering Design part of this course is largely done in KiCad and focuses on Electronic engineering. 

The primary output of Electronic Engineers is Printed Circuit Boards (PCB)

![](assets/2024-03-11-12-15-37.png)

PCBs are great in industry or even for hobbyists. However, for Schools with very weird constraints, they are problematic as they require time for printing to happen and if there is a mistake students need to re-design and send it back out for printing.

Our alternative is to construct "Wire Wrapped" Circuit Boards. 

![](assets/2024-03-11-12-16-42.png)

![](assets/2024-03-11-12-16-52.png)

![](assets/2024-03-11-12-16-58.png)

## Circuit Board Design

Go back to the loading screen (it's behind the schematic editor)

![](assets/2024-03-11-12-18-00.png)

On the right we have a layer view. 

![](assets/2024-03-11-12-18-29.png)

Just to the left of the layer view we have a tool selection tool. 

![](assets/2024-03-11-12-18-50.png)

### Let's start

Select edge cuts

![](assets/2024-03-11-12-19-29.png)

Select a drawing tool (Rectangle is best for this)

Plop a rectangle that is at least 5cm x 3cm.


![](assets/2024-03-11-12-20-18.png)


Didn't quite get the distance right? 

Click on the ruler and you can measure out how large the sides are. 

![](assets/2024-03-11-12-22-30.png)

![](assets/2024-03-11-12-22-47.png)

Let's add a footprint for our circuit. 

Click `Add A footprint`

![](assets/2024-03-11-12-24-36.png)


Click somewhere on the desktop. Let's search for Pin Headers. I know that ours need to be 2.4mm so let's start by typing that up. 

![](assets/2024-03-11-12-26-17.png)


Do the same with a resistor. I know mine is: 

* THT - through hole 
* L6.3mm - overall length is 6.3mm
* P7.62mm - distance between the two pins is 7.62mm
* D2.5mm - diameter

![](assets/2024-03-11-12-28-42.png)


Let's grab an LED. We are using 5mm LEDs 2 pins. 

![](assets/2024-03-11-12-30-16.png)

Let's grab a momentary button. 

But which one? I measured one up and it's 6mm. But there are a lot of 6mm momentary buttons. 

![](assets/2024-03-11-12-34-01.png)

Let's click the first one. Oh look documentation! 


![](assets/2024-03-11-12-34-10.png)

Tactile switch ... looks good. 

![](assets/2024-03-11-12-34-22.png)


I'm going to scroll down the page. The ones we could be using could be either 4.3mm or 5mm. I'm going to pretend that we are using the 4.3mm


![](assets/2024-03-11-12-34-55.png)



![](assets/2024-03-11-12-36-38.png)


Oh, I changed my mind. A battery was a poor decision for what we are doing later. Let's change to screw pins. Go back to the schematic and change it. 


![](assets/2024-03-11-12-43-44.png)


### Specifying which schematic piece our footprint belongs to. 

Select a component (I choose the screw header) and then press `e`

![](assets/2024-03-11-12-43-08.png)



In the reference designator type the reference on the schematic. 

![](assets/2024-03-11-12-43-24.png)


Do that for all of your components. 

![](assets/2024-03-11-12-44-01.png)


When you are doing, go back to your schematic view. 

![](assets/2024-03-11-12-44-20.png)

Go to `tools` and then `update PCB from Schematic`

![](assets/2024-03-11-12-44-31.png)


Stuff happens ... I'll fix this at some stage. 

If everything works, you'll get a link between each component so you can follow the lines for the wire. 

When you want to draw, select F.Cu

![](assets/2024-03-11-12-54-01.png)

Trace your connections


![](assets/2024-03-11-12-58-05.png)

Let's title our board. Go to Front Silkscreen

![](assets/2024-03-11-13-00-32.png)

Click on your desktop and type some dank memes. 

![](assets/2024-03-11-13-00-44.png)


Press alt+3 :)

![](assets/2024-03-11-13-08-35.png)

Hey, we got an error, go back to PCB mode and click 

![](assets/2024-03-11-13-09-12.png)

![](assets/2024-03-11-13-09-28.png)
