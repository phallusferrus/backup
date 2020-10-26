#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then







    xrdb -merge $sysresources

fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then







    xrdb -merge "$userresources"

fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

#SET DISPLAY THIS WAS IN MENTAL OUTLAWS EXPLANATION FOR XRANDR
systemctl --user import-environment DISPLAY

##Can't do CPU-Temp on VM (sensors) and can't figure out CPU % but the examples remain on DT gitlab and OldTechBloke gitlab so you can check em out and this is as much relevant info as I could gather
##UNOW=$(top -bn1 | awk NR==1'{print $10}')
##NOW="${UNOW//,}"
##CPU="$(echo "100 * ($NOW / 3)" | bc -l)"


#Status Bar
#		   Disk Space| RAM US E| CPU% | temp|update|weath| Date

#          HDD:2.3G | RAM:32  | CPU:75 | 100 | ! | 5C | Sun Oct 25 02:38



#INTERMITTENT UPDATES
while true; do
	#DRIVE SPACE
	echo "$(df -h | awk 'NR==4{print $4}')" > /home/qwe/dwmscripts/dwmhdd.txt
	#UPDATE
	CUPDATE=$(checkupdates 2> /dev/null | wc -l)
	UTOKE="?"
	if [ $CUPDATE == 0 ]
	then
		UTOKE="#"
	else
		UTOKE="!"
	fi
	echo "$UTOKE" > /home/qwe/dwmscripts/dwmupdate.txt

	#WEATHER
   	echo ? > /home/qwe/dwmscripts/dwmweather.txt
	WNOW="$(curl -s wttr.in/Longview,WA?format=%t)"
	WGUD="${WNOW//[!0-9]/}"
	echo "scale=0;($WGUD - 32) / 1.8" | bc -l > /home/qwe/dwmscripts/dwmweather.txt

	#SLEEP
	sleep 900
done &


#CONSTANT UPDATES
while true; do
	HDD=$(< /home/qwe/dwmscripts/dwmhdd.txt)
	RAMB=$(free -h| awk 'NR==2{print $3}')
	RAM="${RAMB//i}"
	UTOKEN=$(< /home/qwe/dwmscripts/dwmupdate.txt)
	WTOKEN=$(< /home/qwe/dwmscripts/dwmweather.txt)
	xsetroot -name "  DRIVE:$HDD  |  RAM:$RAM  |  $UTOKEN  |  $WTOKEN C  |  $(date +%a\ %b%d\ %R)"
	sleep 2s
done &




clipmenud &
xrandr -s 1280x800 &
~/.fehbg &
exec dwm



