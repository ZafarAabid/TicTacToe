#!/bin/bash -x

echo "----welcome----"

#declaring constants
declare NO_OF_ROW_COLUMNS=3;
declare BOARD_SIZE=$(($NO_OF_ROW_COLUMNS * $NO_OF_ROW_COLUMNS))
declare PLAYER
declare COMPUTER
declare startGameFlag=0;

#declaring varibles


#declaring directories
declare -a boardOfTicTacToe

function letterAssignment(){
	random=$((RANDOM%2))
	if [ $random == 1 ]
	then
			PLAYER="X"
			COMPUTER="O"
			echo "PLAYER had assigned "$PLAYER
	else
         PLAYER="O"
         COMPUTER="X"
         echo "PLAYER had assigned "$PLAYER
	fi
}
function resetTheBoard()
{
	letterAssignment
 	for (( places=1; places <=$BOARD_SIZE; places++ ))
 	do
 		  boardOfTicTacToe[$places]="-";
 	done
}

function whoPlayFirst(){
 	local toss=$((RANDOM%2))
   if [ $toss == 1 ]
   then
		echo "PLAYER play first"
   else
		echo "COMPUTER play first"
   fi
}

whoPlayFirst
resetTheBoard

echo ${boardOfTicTacToe[@]}
