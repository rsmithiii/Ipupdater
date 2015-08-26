#!/bin/bash

# This script will compare your WAN IP address with the resolved IP address of
# your DNS entry, and will attempt to synchronize them if they don't match.

MYDNSURL=""
UPDATEURL=""
MYWANIPFILE="/var/tmp/mywanip.tmp"
MYDNSURLIPFILE="/var/tmp/mydnsurlip.tmp"

curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//' > $MYWANIPFILE
host $MYDNSURL | sed -e 's/.*has address //' > $MYDNSURLIPFILE

if [ $(cat $MYWANIPFILE) != $(cat $MYDNSURLIPFILE) ]; then
  wget -q --read-timeout=0.0 --waitretry=5 --tries=400 --background $UPDATEURL
fi

if [ -e $MYWANIPFILE ]; then
  rm $MYWANIPFILE
fi

if [ -e $MYDNSURLIPFILE ]; then
  rm $MYDNSURLIPFILE
fi

