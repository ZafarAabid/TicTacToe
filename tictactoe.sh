#!/bin/bash

echo "----welcome----"

#declaring constants
declare NO_OF_ROW_COLUMNS=3;
declare BOARD_SIZE=$(($NO_OF_ROW_COLUMNS * $NO_OF_ROW_COLUMNS))
declare PLAYER
declare COMPUTER
declare startGameFlag=0;

#declaring varibles
declare isPlayerTurn=1;
declare noOneWins=true;
#declaring directories
declare -a ticTacToeBoard
declare -a allPositions


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
 		  ticTacToeBoard[$places]="$places";
 	done
}

function whoPlayFirst(){
 	local toss=$((RANDOM%2))
   if [ $toss == 1 ]
   then
		echo "PLAYER play first"
		isPlayerTurn=1;
   else
		echo "COMPUTER play first"
		isPlayerTurn=0
   fi
}

function displayBoard()
{
echo ""
	echo "    .---.---.---."
   echo "    | "${ticTacToeBoard[1]}" | "${ticTacToeBoard[2]}" | "${ticTacToeBoard[3]}" |"
   echo "    |---|---|---|"
   echo "    | "${ticTacToeBoard[4]}" | "${ticTacToeBoard[5]}" | "${ticTacToeBoard[6]}" |"
   echo "    |---|---|---|"
   echo "    | "${ticTacToeBoard[7]}" | "${ticTacToeBoard[8]}" | "${ticTacToeBoard[9]}" |"
   echo "    '---'---'---'"
echo ""
}

function isPlayerWin(){
	local winingStreak="";
	local columncounter=0;
	for (( columnToCheck=1; columnToCheck <= $NO_OF_ROW_COLUMNS; columnToCheck++ ))
	do
		columncounter=$columnToCheck
		winingStreak+=${ticTacToeBoard[$columncounter]}
		for (( fieldToCheck=1; fieldToCheck < $NO_OF_ROW_COLUMNS; fieldToCheck++ ))
		do
			columncounter=$(( $columncounter+$NO_OF_ROW_COLUMNS ))
			winingStreak+=${ticTacToeBoard[$columncounter]}
		done
		if [[ $winingStreak == "XXX" ]] || [[ $winingStreak == "OOO" ]]
		then
			break;
		else
			winingStreak=""
                 fi
	done
	
	echo $winingStreak
}

function checkValidPosition(){
	local isValidPosition=true;
	for position in ${allPositions[@]};
	do
		if [ $1 -eq $position ]
		then
			isValidPosition=false;
		fi
	done
	echo $isValidPosition
}
function choosePosition(){

	allow="$(checkValidPosition $position $positionSymbol )"
	if [ $allow = true ]
	then
			ticTacToeBoard[$1]=$2
			allPositions+=($1)
			echo ${allPositions[@]}
			displayBoard
	else
			echo "place is already occupied,reselect position"
			playGame
	fi
}

function playGame(){
	while [ $noOneWins ]
	do
		local isValidPosition=true;
		read -p "choose position" position
		if [[ $position -ge 1 ]] && [[ $position -le 9 ]]
		then
			echo "player"
			choosePosition $position $PLAYER
			playerWon="$(isPlayerWin)"
			if [[ $playerWon == "XXX" ]] || [[ $playerWon == "OOO" ]]
			then
				noOneWins=false;
				echo "PLAYER HAS WON"
				break;
			fi
		else
			echo "position out of range, re-enter"
			playGame	
		fi
	done
}

whoPlayFirst
resetTheBoard
displayBoard
playGame
echo ""
