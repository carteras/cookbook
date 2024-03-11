# Design a basic schematic

## Simple Schematics

Open KiCad. It's either pinned to your dash or you need to press `alt` and start typing `kicad`

![](assets/2024-03-11-11-55-51.png)

Make a new project: 

![](assets/2024-03-11-11-56-25.png)

Press `file` then `new project` then give it a name

![](assets/2024-03-11-11-56-42.png)

Go back to load menu and press `schematic editor`

![](assets/2024-03-11-11-57-22.png)

Welcome to the schematic editor

![](assets/2024-03-11-11-57-42.png)

The top row has a list of menu items.

![](assets/2024-03-11-11-57-53.png)


Directly below that is a shortcut to common tools. 

![](assets/2024-03-11-11-58-03.png)


The left of the desktop are page settings. 

![](assets/2024-03-11-11-58-11.png)

On the right of the desktop are schematic tools. 

![](assets/2024-03-11-11-58-22.png)

To the far left we have a layered look at what is on our schematics. 

![](assets/2024-03-11-11-58-31.png)

The desktop is where we do most of our work. 

![](assets/2024-03-11-11-58-41.png)

To start click `Add A symbol`

![](assets/2024-03-11-11-58-53.png)

You'll have to make your own library. After that, search for `SW_SPST` - Single Pole Single Throw Switch. It doesn't matter that we are going to use momentary buttons because we can define that in our footprint. 

![](assets/2024-03-11-12-00-27.png)

Drop it on the board somehwere. 

![](assets/2024-03-11-12-00-13.png)

Do the same for `LED` `R`esistors and `Battery`

![](assets/2024-03-11-12-01-34.png)


To wire the different connectors, hover over an end point and press `w` 

![](assets/2024-03-11-12-02-37.png)

![](assets/2024-03-11-12-03-14.png)

## Desinators

Consider the following labels: 

* BT1 (or BT?)
* SW1 (or SW?)
* R1 (or R?)
* D1 (or D?)

These represent unique values that specify specific components on the board

KiCAD 7 (normally) annotates the schematic automatically. If yours has lots of ? next to BT you'll need to annotate

![](assets/2024-03-11-12-05-10.png)

![](assets/2024-03-11-12-05-22.png)

![](assets/2024-03-11-12-07-13.png)

Let's define our power supply. 

Click on the power symbol

![](assets/2024-03-11-12-08-11.png)


Click somewhere on the desktop 

![](assets/2024-03-11-12-08-25.png)

Search for +5v

![](assets/2024-03-11-12-08-39.png)

Drop it on the desktop on the `+` side of the power. 

![](assets/2024-03-11-12-09-18.png)

Let's do the same for ground. 

![](assets/2024-03-11-12-09-49.png)


