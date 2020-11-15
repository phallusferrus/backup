#!/bin/bash

curl https://darksky.net/forecast/46.0098,-122.8454/si10/en > darksky.html

EX="$(cat darksky.html | grep 'summary swap')"

VAL="$(echo $EX | digitextractor)"

echo "$VAL" > /home/qwe/dwmscripts/dwmdarksky.txt

rm darksky.html

