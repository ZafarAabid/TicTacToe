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

function checkValidPosition(){
			local isValidPosition=true;
			local getPosition=$1;
			if [[ $getPosition -ge 1 ]] && [[ $getPosition -le 9 ]]
			then
					for position in ${allPositions[@]};
					do
							if [ $getPosition -eq $position ]
							then
									isValidPosition=false;
							fi
					done

			else
					echo  "position out of range"
					choosePosition $2

			fi

		echo $isValidPosition
}
function choosePosition(){
	local positionSymbol=$1
	
	read -p "choose position" position
	allow="$(checkValidPosition $position $positionSymbol )"
	if [ $allow = true ]
	then
			ticTacToeBoard[$position]=$positionSymbol
			allPositions+=($position)
			echo ${allPositions[@]}
			displayBoard
	else
			echo "place is already occupied,reselect position"
			choosePosition $positionSymbol
	fi
}

function playGame(){
local noOneWins=true;
	while [ $noOneWins ]
	do

		if [ $isPlayerTurn -eq 1 ]
		then
				echo "player"
				choosePosition $PLAYER
				isPlayerTurn=0
		else
				 echo "COMPUTER"
				choosePosition $COMPUTER
				isPlayerTurn=1
		fi
	done
}

whoPlayFirst
resetTheBoard
displayBoard
playGame
echo ""
