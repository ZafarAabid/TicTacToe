#!/bin/bash

echo "----welcome----"

#declaring constants
declare NO_OF_ROW_COLUMNS=3;
#echo "Enter the row/column length "
#read -p "" NO_OF_ROW_COLUMNS
declare BOARD_SIZE=$(($NO_OF_ROW_COLUMNS * $NO_OF_ROW_COLUMNS))

#declaring varibles
declare player
declare computer
declare Xpattern;
declare Opattern;
declare startGameFlag=0;
declare isplayerTurn=1;
declare noOneWins=true;
#declaring directories
declare -a ticTacToeBoard
declare -a allPositions

for (( patterngenerator=1; patterngenerator <= $NO_OF_ROW_COLUMNS; patterngenerator++))
do
	Xpattern+='X';
	Opattern+='O'
done
function letterAssignment(){
	random=$((RANDOM%2))
	if [ $random == 1 ]
	then
		player="X"
		computer="O"
		echo "player had assigned "$player
	else
		player="O"
        	computer="X"
        	echo "player had assigned "$player
	fi
}
function resetTheBoard()
{
	letterAssignment
 	for (( places=1; places <=$BOARD_SIZE; places++ ))
 	do
 		  ticTacToeBoard[$places]='-';
 	done
}

function whoPlayFirst(){
 	local toss=$((RANDOM%2))
   if [ $toss == 1 ]
   then
		echo "player play first"
		isplayerTurn=1;
   else
		echo "computer play first"
		isplayerTurn=0
   fi
}

function displayBoard()
{
echo ""
	cellCount=1
	for (( tableCell=1; tableCell <= $NO_OF_ROW_COLUMNS; tableCell++ ))
	do
		if [ $tableCell -eq 1 ]
		then
			for (( tableRows=1; tableRows<=$NO_OF_ROW_COLUMNS; tableRows++ ))
			do
			echo  -n ".---"
			done
		echo "."
		fi
		if [[ $tableCell -gt 1 ]] || [[ $tableCell -lt $NO_OF_ROW_COLUMNS ]]
                then
                        for (( tableRows=1; tableRows<=$NO_OF_ROW_COLUMNS; tableRows++ ))
                        do
				if [ $cellCount -le 9 ]
				then
					echo -n "| ${ticTacToeBoard[$cellCount]} "
					cellCount=$(($cellCount+1))
				else
					echo  -n "| ${ticTacToeBoard[$cellCount]} "
					cellCount=$(($cellCount+1))
				fi
                        done
                echo   "|"
                fi
		if [ $tableCell -lt $NO_OF_ROW_COLUMNS ]
		then
			for (( i=1; i<=$NO_OF_ROW_COLUMNS; i++ ))
			do
	        		echo -n "|---"
                	done
			echo -n "|"
			echo " "
		fi
		if [ $tableCell -eq $NO_OF_ROW_COLUMNS ]
                then
                        for (( tableRows=1; tableRows<=$NO_OF_ROW_COLUMNS; tableRows++ ))
                        do
 	              	         echo  -n "'---"
                        done
               echo "'"
               fi
	done
	echo ""
}
function isplayerWin(){
	local outputStreak="";
	local cloumnStreak="";
	local columnCounter=0;
	local rowCounter=1
	local diagonalCounter=1
	local antiDiagonalCounter=$NO_OF_ROW_COLUMNS
	for (( columnToCheck=1; columnToCheck <= $NO_OF_ROW_COLUMNS; columnToCheck++ ))
	do
		columnCounter=$columnToCheck
		cloumnStreak+=${ticTacToeBoard[$columnCounter]}
		            rowStreak+=${ticTacToeBoard[$rowCounter]}
		diagonalStreak+=${ticTacToeBoard[$diagonalCounter]}
		antiDiagonalStreak+=${ticTacToeBoard[$antiDiagonalCounter]}
		for (( fieldToCheck=1; fieldToCheck < $NO_OF_ROW_COLUMNS; fieldToCheck++ ))
		do
			columnCounter=$(( $columnCounter+$NO_OF_ROW_COLUMNS ))
			cloumnStreak+=${ticTacToeBoard[$columnCounter]}
			rowCounter=$(( $rowCounter+1 ))
                        rowStreak+=${ticTacToeBoard[$rowCounter]}
			diagonalCounter=$(( $diagonalCounter+$NO_OF_ROW_COLUMNS+1 ))
                        diagonalStreak+=${ticTacToeBoard[$diagonalCounter]}
			antiDiagonalCounter=$(( $antiDiagonalCounter+$NO_OF_ROW_COLUMNS-1 ))
                        antiDiagonalStreak+=${ticTacToeBoard[$antiDiagonalCounter]}
		done
		if [[ $cloumnStreak == $Xpattern ]] || [[ $rowStreak == $Xpattern ]] || [[ $diagonalStreak == $Xpattern ]] || [[ $antiDiagonalStreak == $Xpattern ]]
		then
			outputStreak='X'
			break;
		elif [[ $cloumnStreak == $Opattern ]] || [[ $rowStreak == $Opattern ]] || [[ $diagonalStreak == $Opattern ]] || [[ $antiDiagonalStreak == $Opattern ]]
		then
			outputStreak='O'
                        break;
		else
			rowCounter=$(($rowCounter+1))
			rowStreak=""
			cloumnStreak=""
			diagonalStreak=""
			antiDiagonalStreak=""
			outputStreak="-"
               fi
	done
	echo $outputStreak
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
			if [ $player = $2 ]
			then
			echo "place is already occupied,reselect position"
			fi
			playGame
	fi
}
#function (){

#}

function playGame(){

	while [ $noOneWins ]
	do
		if [ $isplayerTurn = 1 ]
		then
			local isValidPosition=true;
			read -p "choose position" position
			if [[ $position -ge 1 ]] && [[ $position -le $BOARD_SIZE ]]
			then
				echo "player"
				choosePosition $position $player
				playerWon="$(isplayerWin)"
				if [ $playerWon == $player ]
				then
					echo "player HAS WON";
					noOneWins=false;
					break
					break
					break
                                        break

				fi
			else
					echo "position out of range, re-enter"
					playGame
			fi
			isplayerTurn=0
			
		else
			local isValidPosition=true;
                        position=$(( RANDOM % $BOARD_SIZE +1))
                        if [[ $position -ge 1 ]] && [[ $position -le $BOARD_SIZE ]]
                        then
                                echo "COMPUTER"
                                choosePosition $position $computer
                                playerWon="$(isplayerWin)"
                                if [ $playerWon == $computer ]
                                then
                                        noOneWins=false;
                                        echo "COMPUTER HAS WON"
                                        break
					break
                                        break
                                fi
                        else
                                playGame
                        fi
                        isplayerTurn=1
		fi
	done
}

whoPlayFirst
resetTheBoard
displayBoard
playGame
echo ""
