

# Unusual

[![license](https://img.shields.io/github/license/mashape/apistatus.svg)](https://github.com/thunderbo1t/Unusual/blob/master/LICENSE)

***

This uses conky monitoring system to display cpu and system related other information in Ubuntu.
This is an developement build for 4 core systems. 

Blue variant

![Screenshot of the conky](https://github.com/thunderbo1t/Unusual/blob/master/.conky/Images/Screenshot/Screenshot(blue).png)


Black variant

![Screenshot of the conky](https://github.com/thunderbo1t/Unusual/blob/master/.conky/Images/Screenshot/Screenshot(black).png)

Green variant

![Screenshot of the conky](https://github.com/thunderbo1t/Unusual/blob/master/.conky/Images/Screenshot/Screenshot(green).png)
# Installation
   ```bash
    sudo apt-get install conky conky-all
  	cd && git clone https://github.com/thunderbo1t/Unusual.git
  	cd Unusual
  	chmod +x .start-conky 
  	cp -R .conky .conkyrc .start-conky ~
  	cd && rm -fR Unusual
  ```
  * Now open Startup Applications > click Add  > New Dialog box will open click on Browse > Now (Press Ctrl+H) see following screenshot.

	![Start up-application](http://i.imgur.com/lFoYjWC.png)

# Updating

```bash
  cd && git clone https://github.com/thunderbo1t/Unusual.git
  cd Unusual
  chmod +x .start-conky 
  cp -R .conky .conkyrc .start-conky ~
  cd && rm -fR Unusual
```


# Customizing

  * `gedit ~/.conky/Script/script.lua `
  * uncomment the lines after 18 to suit your needs
  * save and close it
  * `gedit ~/.conkyrc`
  * edit the line 30 from ${image ~/.conky/Images/bitmap.png -p 0,0} to ${image ~/.conky/Images/bitmap(white).png -p 0,0} for white and to ${image ~/.conky/Images/bitmap(green).png -p 0,0} for green and save it

# Reference 

The design was referenced from thie [blog](http://thepeachyblog.blogspot.in/2010/07/here-is-new-conkylua-setup-from-me.html)