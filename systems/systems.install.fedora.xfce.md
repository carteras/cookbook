# Installing Fedora Xfce

## Googling Fedora Xfce

["Googling Xfce"](./imgs/googling-image.png)

["found fedora xfce"](./imgs/goolge-results-image-1.png)

![download xfce](imgs/image-1.png)

!["Live ISO"](imgs/image-19.png)

!["Downloading"](imgs/image-20.png)

## Virtual manager

!["virtual manager"](imgs/image-21.png)

!["Virtual Machine Manager"](imgs/image-22.png)

!["create new virtual machine"](imgs/image-23.png)

!["Install local media"](imgs/image-24.png)

!["click browse"](imgs/image-25.png)

!["Click default filesystem"](imgs/image-27.png)

!["navigate to downloads"](imgs/image-29.png)

!["yes"](imgs/image-30.png)

!["keep this"](imgs/image-31.png)

![keep this too](imgs/image-32.png)

!["name your vm"](imgs/image-33.png)

Start Fedora Live


![alt text](imgs/image-34.png)

If it doesn't come up, install to disk 

![alt text](imgs/image-35.png)

Choose your language (Note: I can only read English). 

![alt text](imgs/image-36.png)

Click install destination

![alt text](imgs/image-37.png)

Immediately press done

![alt text](imgs/image-38.png)

Click User creation 

![alt text](imgs/image-39.png)

Enter in your details. Note, I can't fix your stuff if you forget your password

![alt text](imgs/image-40.png)

Begin installation

![alt text](imgs/image-41.png)

Wait a bit

!["wait a bit"](imgs/image-42.png)

When the Finish Installation button goes blue, press it. 

![alt text](imgs/image-43.png)

On my system, I had to reboot it. 

Log in

![alt text](imgs/image-44.png)

Let's update!

![alt text](imgs/image-45.png)


While that's happening, open up a new terminal and type the following commands: 

```bash
whoami
```

and 

```bash
groups
```

You should see something like 

```bash
whoami
adam
groups
adam wheel
```

Let's call your machine something else

```bash
sudo hostname awesomesauce
```


Let's install that second network card 

??? remind me to put this up