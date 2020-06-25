# pascal_coursework
This repo contains a program written within course-work project early in 2016. The subject was "Programming in Pascal". The project contains 2 libraries (for mouse and graphics [high resolution 256 colors]) and some usage.

## How to run
Install a Dosbox (if you are running windows. For linux I never tried) and TurboPascal 7.[0, 1]. It is convinient to have the TP installed right on the `C:\` or `D:\` (or whatever it is calld on your machine)
```
cd <turbopascal_install_dir>
mv <turbopascal_install_folder_name C:\TP
cd C:\
git clone https://github.com/arsdever/pascal_coursework PROJ
```

Add the following at the end of the `DOSBox Options` file (you can find the shortcut to this file in the start menu icons)
```
MOUNT C <device_letter>:\
C:
cd PROJ
```

Then start the `DOSBox` (either with or without console will work). Then execute `..\TP\BIN\TURBO.EXE`. From `File` menu select `Open` and open the file called `KURSAYIN.PAS` (don't pay attention to the namings :) by then my English was horrible).
Click `Run` and it should work.

## SUPPORT ME

Don't hesitate to leave me a start if you did like the project. If you do, I will understand that you are interested and will continue to improve and polish the project.
You are also free to open issues and suggest ideas.

### Note

The text in the program is in Armenian (my native language). If you wish, I can try to make an english font as well.
