#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Usage $0 <state>"
  echo "e.g., $0 sp"
  exit
fi

read -p "Confirm that you have profile_separator, data and order folders and press [Enter] key ..."

if [ ! -f data/ptt_$state.txt ]; then
  echo Data file not found!
  echo Expected: data/ptt_$state.txt
  exit
fi

if [ ! -f order/order_$state.txt ]; then
  echo File containing order of ASes not found! 
  echo Expected: order/order_$state.txt
  exit
fi

if [ ! -f profile_separator/profile_separator_$state.txt ]; then
  echo File containing profiles of ASes not found! 
  echo Expected: profile_separator/profile_separator_$state.txt
  exit
fi

BASEDIR=/disk/PTT/ixp-ptt-br/analysis/Adjacencies/peeringMatrixByProfile

state=$1

$BASEDIR/peeringMatrixByProfile.sh data/ptt_$state.txt order/order_$state.txt

tmp1=matrix_profile_tmp
$BASEDIR/profile_separator.sh profile_separator/profile_separator_$state.txt peeringMatrix_$state.txt > $tmp1 

$BASEDIR/removeZeros.sh $tmp1 > noZeros

$BASEDIR/connectivityScale.sh noZeros > matrix_$state.txt

$BASEDIR/generatePlt.sh matrix_$state.txt profile_separator/profile_separator_$state.txt

rm -f $tmp1 noZeros 2> /dev/null
