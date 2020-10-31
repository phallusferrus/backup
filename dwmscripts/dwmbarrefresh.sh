#!/bin/bash

HDD=$(< /home/qwe/dwmscripts/dwmhdd.txt)
RAMB=$(free -h| awk 'NR==2{print $3}')
RAM="${RAMB//i}"
UTOKEN=$(< /home/qwe/dwmscripts/dwmupdate.txt)

CPUTEMP="$(sensors|awk 'BEGIN{i=0;t=0;b=0}/id [0-9]/{b=$4};/Core/{++i;t+=$3}END{if(i>0){printf("%0.1f\n",t/i)}else{sub(/[^0-9.]/,"",b);print b}}')"
#CTTOKEN="$(sensors | awk 'NR==3{print $3}')"
#CPUFAN="${CTTOKEN//[!0-9]/}"

BTOKEN="$(acpi | awk '{print $4}')"
BAT="${BTOKEN//[!0-9]/}"

WTOKEN=$(< /home/qwe/dwmscripts/dwmweather.txt)

WICON=$(< /home/qwe/dwmscripts/dwmwicon.txt)
YCON=$(echo $WICON)

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
	ATOKEN="$AICON$ATOKEN"
elif [ $ATOKEN == 0 ]
then
	AICON=""
	ATOKEN="$AICON"
else
	AICON=""
	ATOKEN="$AICON$ATOKEN"	
fi


#xsetroot -name "  $HDD | $RAM | $CPUTEMP | $BAT% | $UTOKEN | $WICON  $WTOKEN C | $ATOKEN | $(date +%a\ %b%d\ %R)"
xsetroot -name "  $HDD | $RAM | $CPUTEMP | $BAT% | $UTOKEN | "$WICON" $WTOKEN C | $ATOKEN | $(date +%a\ %b%d\ %R)"
