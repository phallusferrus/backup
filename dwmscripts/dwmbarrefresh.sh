#!/bin/bash

HDD=$(< /home/qwe/dwmscripts/dwmhdd.txt)
RAMB=$(free -h| awk 'NR==2{print $3}')
RAM="${RAMB//i}"
UTOKEN=$(< /home/qwe/dwmscripts/dwmupdate.txt)

CPUTEMP="$(sensors|awk 'BEGIN{i=0;t=0;b=0}/id [0-9]/{b=$4};/Core/{++i;t+=$3}END{if(i>0){printf("%0.1f\n",t/i)}else{sub(/[^0-9.]/,"",b);print b}}')"
#CTTOKEN="$(sensors | awk 'NR==3{print $3}')"
#CPUFAN="${CTTOKEN//[!0-9]/}"
ELERT=0
###IDK why but acpi occasionally outputs TWO lines and other times only one...
#BTOKEN="$(acpi | awk 'NR==2{print $4}')"
BTOKEN="$(acpi | awk '{print $4}')"
BAT="${BTOKEN//[!0-9]/}"
#Batterey Icon
#NOTE: The NR things like I said above IDK why acpi does taht shit man
#CHARGE="$(acpi | awk 'NR==2{print $3}')"
CHARGE="$(acpi | awk '{print $3}')"
CHARGING="Charging,"
FULL="Full,"
if [ $CHARGE == $CHARGING ]
then
	BICON=''
elif [ $CHARGE == $FULL ]
then
	BICON=''
elif [ $BAT -gt 90 ]
then
	BICON=""
elif [ $BAT -gt 70]
then
	BICON=""
elif [ $BAT -gt 40 ]
then
	BICON=""
elif [ $BAT -gt 15 ]
then
	BICON=""
else
	BICON=""
fi
ALLBAT=$BICON$BAT%



#LOW BATTEREY ALERT - NOTICE SPECIFIC FORMAT FOR "CHARGING,"
if [ $BAT -lt 15 ]
then
	if [[ $CHARGE != $CHARGING ]]
	then
		ELERT=1
	fi
fi


WTOKEN=$(< /home/qwe/dwmscripts/dwmdarksky.txt)

WICON=$(< /home/qwe/dwmscripts/dwmwicon.txt)
YCON=$(echo $WICON)


ALLWEATHER=$WICON$WTOKEN"C"

#AMUTE="$(amixer | awk 'NR==5{print $6}')"
#if [ $AMUTE == "[off]" ]
#then
#	ATOKEN="M"
#else
#	ATOKE="$(amixer | awk 'NR==5{print $4}')"
#	ATOKEN="${ATOKE//[!0-9]/}"
#fi

ATOKEN=$(< /home/qwe/dwmscripts/dwmaudio.txt)

if [ $ATOKEN == "M" ]
then
	ATOKEN=""
elif [ $ATOKEN -gt 50 ]
then
	AICON=""
	ATOKEN="$AICON$ATOKEN%"
elif [ $ATOKEN == 0 ]
then
	AICON=""
	ATOKEN="$AICON"
else
	AICON=""
	ATOKEN="$AICON$ATOKEN%"	
fi


#xsetroot -name "  $HDD | $RAM | $CPUTEMP | $BAT% | $UTOKEN | $WICON  $WTOKEN C | $ATOKEN | $(date +%a\ %b%d\ %R)"

if [ $ELERT == 1 ] 
then
	xsetroot -name "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!BATTEREY$BAT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
else
	xsetroot -name "  $HDD | $RAM | $CPUTEMP | $ALLBAT | $UTOKEN | $ALLWEATHER | $ATOKEN | $(date +%a\ %b%d\ %R)"
fi
