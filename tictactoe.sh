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
	showSymbols=1
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
			if [ $showSymbols = 2 ]
                        then
                                echo -n "    COMPUTER : "$computer
                                showSymbols=$(($showSymbols+1))
                        fi
			if [ $showSymbols = 1 ]
			then
				echo -n "    PLAYER : "$player
				showSymbols=$(($showSymbols+1))
			fi
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
function doPositionMet(){
	columnPositionCounter=0;
	checkColumnPosition=0;
	rowPositionCounter=0;
        checkRowPosition=0;

        for ((checklength=1; checklength <= $NO_OF_ROW_COLUMNS; checklength++))
        do 
        columns=1
        asdf=$checklength
                while [ $columns -le $NO_OF_ROW_COLUMNS ]
                do
                        if [ ${ticTacToeBoard[$asdf]} = $computer ]
                        then
                                rowPositionCounter=$(($rowPositionCounter+1))
                        fi

                        if [ ${ticTacToeBoard[$asdf]} != $computer -a ${ticTacToeBoard[$asdf]} != $player ]
                        then
                                checkRowPosition=$asdf
                        fi
                        columns=$(($columns+1))
                        asdf=$(($asdf+$NO_OF_ROW_COLUMNS))
                        if [[ $rowPositionCounter == $(($NO_OF_ROW_COLUMNS-1)) ]] && [[ ${ticTacToeBoard[$checkRowPosition]} == '-'  ]]
                        then
                                break
                        fi
                done
        done
	for (( columnToCheck=1; columnToCheck <= $BOARD_SIZE; columnToCheck++ ))
	do
		if ! [ $(($columnToCheck % $(($NO_OF_ROW_COLUMNS)) )) -eq 0 ]
		then
			columnPosition=$(($columnToCheck+$NO_OF_ROW_COLUMNS))
			if [[ ${ticTacToeBoard[$columnToCheck]} = $computer ]]
                     	then
				columnPositionCounter=$(($columnPositionCounter+1))
			elif [ ${ticTacToeBoard[$columnToCheck]} = '-'  -a ticTacToeBoard[$columnToCheck]} != $player ]
                        then
                                checkColumnPosition=$columnToCheck ;
			elif [[ $columnPositionCounter -eq $(( $NO_OF_ROW_COLUMNS-1 )) ]] && [[ ${ticTacToeBoard[$checkColumnPosition]} = '-' ]]
                       then
                                columnPositionCounter=$(($NO_OF_ROW_COLUMNS-1))
                                break
                        fi
		else
			if [ ${ticTacToeBoard[$columnToCheck]} = $computer ]
                        then
                                columnPositionCounter=$(($columnPositionCounter+1))
       			elif  [ ${ticTacToeBoard[$columnToCheck]} = '-' ]
                       then
	                        checkColumnPosition=$columnToCheck ;
		        elif [[ $columnPositionCounter -eq $(( $NO_OF_ROW_COLUMNS-1 )) ]] && [[ ${ticTacToeBoard[$checkColumnPosition]} = '-' ]]
                      	then
			columnPositionCounter=$(($NO_OF_ROW_COLUMNS-1))
                                break
                      fi
		fi
	done
}
function isplayerWin()
{
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
function playGame(){

	while [ $noOneWins ]
	do
		if [ $isplayerTurn = 1 ]
		then
			local isValidPosition=true;
			echo "player's turn "
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
				fi
			elif [ $position -eq 0 ]
			then
				echo " 0 position is not availabe"
                                playGame

			else
				echo "position out of range, re-enter"
				playGame
			fi
			if [ ${#allPositions[@]} -lt $BOARD_SIZE ]
                        then
                                isplayerTurn=0
                        else
                                echo "matchDraw"
                                isplayerTurn=2
                                break
                        fi
		else
			local isValidPosition=true;
			echo "computer's turn"
			doPositionMet
			echo $columnPositionCounter
			if [ $columnPositionCounter -eq $(($NO_OF_ROW_COLUMNS-1)) -a ${ticTacToeBoard[$checkColumnPosition]} = '-' ]
			then
				position=$checkColumnPosition
			elif [ $rowPositionCounter = $(($NO_OF_ROW_COLUMNS-1)) -a ${ticTacToeBoard[$checkRowPosition]} = '-' ]
			then
				position=$checkRowPosition
			else
#				read -p "enter computer spot " position
				position=$(( RANDOM % $BOARD_SIZE +1))
			fi
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
                                fi
                        else
                                playGame
                        fi
#                        isplayerTurn=1
			if [ ${#allPositions[@]} -lt $BOARD_SIZE ]
			then
				isplayerTurn=1
			else
				echo "matchDraw"
				isplayerTurn=2
				break
			fi
		fi
	done

}

whoPlayFirst
resetTheBoard
displayBoard
playGame
echo ""
