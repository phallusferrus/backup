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

#CLIPMENU
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
	UTOKE="?"
	echo "$UTOKE" > /home/qwe/dwmscripts/dwmupdate.txt
	CUPDATE=$(checkupdates 2> /dev/null | wc -l)
	if [ $CUPDATE == 0 ]
	then
		UTOKE=""
	else
		UTOKE=""
	fi
	echo "$UTOKE" > /home/qwe/dwmscripts/dwmupdate.txt

	#WEATHER
	#The oldmethod is here preserved, now I just take the icon directly from wttr.in... I MAY try to get the moonphase thing working again when the sun icon starts to annoy me but till then this will just werk.
	#Be infomed I currently USE the old method...it just werks (and if it doesn't it's usually caused becaue the text conditions are spelled wrong or something like that. Fixeable I think in most cases...
   WNOW="$(curl  wttr.in/98625?m | awk 'NR==4')"
	WGUDD="${WNOW//[!0-9]/}"
	echo $WGUDD


	WGUDD="${WNOW//[!0-9]/}"
	WGUD="$(echo $WGUDD - 32 | bc -l)"
	echo "scale=0;$WGUD / 1.8" | bc -l > /home/qwe/dwmscripts/dwmweather.txt
	SSETT="$(curl -s wttr.in/98625?format=%s)"
	SSET="${SSETT//[!0-9]/}"
	SRIZZ="$(curl -s wttr.in/98625?format=%D)"
	SRIZ="${SRIZZ//[!0-9]/}"
	TNOW="$(date | awk '{print $4}')"
	NOW="${TNOW//[!0-9]/}"
	WWICON="$(curl -s wttr.in/98625?format=%C)"
	CLEAR="Clear"
	SUNNY="Sunny"
	if [ $NOW -gt $SRIZ ] && [ $NOW -lt $SSET ]
	then
		WICONNN="$(curl -s wttr.in/98625?format=%C)"
		WICONN="$(echo $WICONNN | nocomma)"
		WICON="$(cat /home/qwe/dwmscripts/allicons.txt | grep "$WICONN" | awk 'NR==1{print $NF}')"
	elif [ $WWICON == $CLEAR ] || [ $WWICON == $SUNNY ]
	then
		MPHAZ="$(curl -s wttr.in/98625?format=%M)"
		if [ $MPHAZ -lt 2 ]
		then
			WICON="🌕"
		elif [ $MPHAZ -lt 13 ]
		then
			WICON="🌘"
		elif [ $MPHAZ == 14 ]
		then
			WICON="🌚"
		elif [ $MPHAZ -lt 16 ]
		then
			WICON="🌑"
		elif [ $MPHAZ -lt 19 ]
   		then
			WICON="🌒"
		elif [ $MPHAZ -lt 24 ]
		then	
			WICON="🌓"
		elif [ $MPHAZ < 27 ]
		then
			WICON="🌔"
		else
			WICON="🌕"
		fi
	else
		WICONNN="$(curl -s wttr.in/98625?format=%C)"
		WICONN="$(echo $WICONNN | nocomma)"
		WICON="$(cat /home/qwe/dwmscripts/nighticons.txt | grep "$WICONN" | awk 'NR==1{print $NF}')"

		
	fi
	echo $WICON > /home/qwe/dwmscripts/dwmwicon.txt

	/home/qwe/dwmscripts/weatherupdate.sh


	#SLEEP
	sleep 900s
done &


#CONSTANT UPDATES
while true; do

	#HDD=$(< /home/qwe/dwmscripts/dwmhdd.txt)
	#RAMB=$(free -h| awk 'NR==2{print $3}')
	#RAM="${RAMB//i}"
	#UTOKEN=$(< /home/qwe/dwmscripts/dwmupdate.txt)

	#CPUTEMP="$(sensors|awk 'BEGIN{i=0;t=0;b=0}/id [0-9]/{b=$4};/Core/{++i;t+=$3}END{if(i>0){printf("%0.1f\n",t/i)}else{sub(/[^0-9.]/,"",b);print b}}')"
	##CTTOKEN="$(sensors | awk 'NR==3{print $4}')"
	##CPUTEMP="${CTTOKEN//[!0-9]/}"

	#BTOKEN="$(acpi | awk '{print $4}')"
	#BAT="${BTOKEN//[!0-9]/}"

	#WTOKEN=$(< /home/qwe/dwmscripts/dwmweather.txt)

	##AMUTE="$(amixer | awk 'NR==5{print $6}')"
	##if [ $AMUTE == "[off]" ]
	##then
	##	ATOKEN="M"
	##else
	##	ATOKE="$(amixer | awk 'NR==5{print $4}')"
	##	ATOKEN="${ATOKE//[!0-9]/}"
	##fi

	#ATOKEN=$(< /home/qwe/dwmscripts/dwmaudio.txt)

	#xsetroot -name "  $HDD  |  RAM:$RAM  |  CPU:$CPUTEMP  |  B:$BAT %  |  $UTOKEN  |  $WTOKEN C  |  $ATOKEN  |  $(date +%a\ %b%d\ %R)"
	/home/qwe/dwmscripts/dwmbarrefresh.sh
	sleep 2s
done &

#Udiskie boot daemon...
udiskie &
#
#Random Wallaper on Boot (I have it update on the hour now)
#feh --bg-scale --randomize ~/wallpapes/*
#
#Background load on Boot
~/.fehbg &
#Clipboard daemon
clipmenud &
#WM
exec dwm



