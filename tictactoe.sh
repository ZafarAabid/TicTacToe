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
function chooseCorners(){
local myPosition
	myPosition=$((RANDOM%4))
	case $myPosition in
	0)
		myPosition=1			;;
	1)
        	myPosition=3                    ;;
	2)
        	myPosition=7                    ;;
	3)
        	myPosition=9                    ;;
	esac

echo $myPosition
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
function blockColumn(){

 columnBlockPosition=0
        if [ ${ticTacToeBoard[1]} = $player -a ${ticTacToeBoard[4]} = $player -a "${ticTacToeBoard[7]}" = "-" ]
        then
                columnBlockPosition=7;
	 elif [ ${ticTacToeBoard[1]} = $player -a ${ticTacToeBoard[7]} = $player -a "${ticTacToeBoard[4]}" = "-" ]
        then
                columnBlockPosition=4;
        elif [ ${ticTacToeBoard[4]} = $player -a ${ticTacToeBoard[7]} = $player  -a "${ticTacToeBoard[1]}" = "-" ]
	then
                columnBlockPosition=1;
        fi
        if [ ${ticTacToeBoard[2]} = $player -a ${ticTacToeBoard[5]} = $player  -a "${ticTacToeBoard[8]}" = '-' ]
        then 
                columnBlockPosition=8;
        elif [ ${ticTacToeBoard[2]} = $player -a ${ticTacToeBoard[8]} = $player  -a "${ticTacToeBoard[5]}" = '-' ]
        then 
                columnBlockPosition=5;
                break
        elif [ ${ticTacToeBoard[5]} = $player -a ${ticTacToeBoard[8]} = $player  -a "${ticTacToeBoard[2]}" = '-' ]
        then 
                columnBlockPosition=2;
        fi
	if [ ${ticTacToeBoard[3]} = $player -a ${ticTacToeBoard[6]} = $player  -a "${ticTacToeBoard[9]}" = '-' ]
        then 
                columnBlockPosition=9;
        elif [ ${ticTacToeBoard[3]} = $player -a ${ticTacToeBoard[9]} = $player  -a "${ticTacToeBoard[6]}" = '-' ]
        then 
                columnBlockPosition=6;
        elif [ ${ticTacToeBoard[6]} = $player -a ${ticTacToeBoard[9]} = $player  -a "${ticTacToeBoard[3]}" = '-' ]
        then 
                columnBlockPosition=3;
        fi
        echo $columnBlockPosition
}

function blockRow(){
 rowBlockPosition=0;
        if [ ${ticTacToeBoard[1]} = $player -a ${ticTacToeBoard[2]} = $player -a "${ticTacToeBoard[3]}" = "-" ]
        then
                rowBlockPosition=3;
         elif [ ${ticTacToeBoard[1]} = $player -a ${ticTacToeBoard[3]} = $player -a "${ticTacToeBoard[2]}" = "-" ]
        then
                rowBlockPosition=2;
        elif [ ${ticTacToeBoard[2]} = $player -a ${ticTacToeBoard[3]} = $player  -a "${ticTacToeBoard[1]}" = "-" ]
        then
                rowBlockPosition=1;
        fi
        if [ ${ticTacToeBoard[4]} = $player -a ${ticTacToeBoard[5]} = $player  -a "${ticTacToeBoard[6]}" = '-' ]
        then 
                rowBlockPosition=6;
        elif [ ${ticTacToeBoard[4]} = $player -a ${ticTacToeBoard[6]} = $player  -a "${ticTacToeBoard[5]}" = '-' ]
        then 
                rowBlockPosition=5;
                break
        elif [ ${ticTacToeBoard[5]} = $player -a ${ticTacToeBoard[6]} = $player  -a "${ticTacToeBoard[4]}" = '-' ]
        then 
                rowBlockPosition=4;
        fi
	if [ ${ticTacToeBoard[7]} = $player -a ${ticTacToeBoard[8]} = $player  -a "${ticTacToeBoard[9]}" = '-' ]
        then 
                rowBlockPosition=9;
        elif [ ${ticTacToeBoard[7]} = $player -a ${ticTacToeBoard[9]} = $player  -a "${ticTacToeBoard[8]}" = '-' ]
        then 
                rowBlockPosition=8;
        elif [ ${ticTacToeBoard[8]} = $player -a ${ticTacToeBoard[9]} = $player  -a "${ticTacToeBoard[7]}" = '-' ]
        then 
                rowBlockPosition=7;
        fi
        echo $rowBlockPosition
}
function blockdiagonal() {
	diagonalBlockPosition=0;
	if [ ${ticTacToeBoard[1]} = $player -a ${ticTacToeBoard[5]} = $player -a "${ticTacToeBoard[9]}" = "-" ]
	then
		diagonalBlockPosition=9;
	elif [ ${ticTacToeBoard[1]} = $player -a ${ticTacToeBoard[9]} = $player -a "${ticTacToeBoard[5]}" = "-" ]
        then
                diagonalBlockPosition=5;
	elif [ ${ticTacToeBoard[5]} = $player -a ${ticTacToeBoard[9]} = $player  -a "${ticTacToeBoard[1]}" = "-" ]
        then 
                diagonalBlockPosition=1;
	fi
	if [ ${ticTacToeBoard[3]} = $player -a ${ticTacToeBoard[5]} = $player  -a "${ticTacToeBoard[7]}" = "-" ]
        then 
                diagonalBlockPosition=7;
        elif [ ${ticTacToeBoard[3]} = $player -a ${ticTacToeBoard[7]} = $player  -a "${ticTacToeBoard[5]}" = "-" ]
        then 
                diagonalBlockPosition=5;
        elif [ ${ticTacToeBoard[5]} = $player -a ${ticTacToeBoard[7]} = $player  -a "${ticTacToeBoard[3]}" = "-" ]
        then 
                diagonalBlockPosition=3;
        fi
	echo $diagonalBlockPosition
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
                        elif [ ${#allPositions[@]} -ge $BOARD_SIZE -a $noOneWins = "true" ]
			then
                                echo "matchDraw"
                                isplayerTurn=2
                                break
                        fi
		else
			local isValidPosition=true;
			echo "computer's turn"
			sleep 1
			doPositionMet
			blockColumn
			blockRow
			blockdiagonal
                         if [ $diagonalBlockPosition != "0" ]
                         then
				echo "DIAGB" 
                                 position=$diagonalBlockPosition
			elif [ $columnBlockPosition != "0" ]
                         then
				echo "COLB" 
                                 position=$columnBlockPosition
			elif [ $rowBlockPosition != "0" ]
                         then
				echo "ROWB"
                                 position=$rowBlockPosition
			elif [[ ${ticTacToeBoard[1]} = '-' ]] || [[ ${ticTacToeBoard[3]} = '-' ]] || [[ ${ticTacToeBoard[7]} = '-' ]] || [[ ${ticTacToeBoard[9]} = '-' ]]
			then
				position="$(chooseCorners)"
				echo "CORNERS"
			elif [ ${ticTacToeBoard[5]} = '-' ]
			then
				position=5
                                echo "CENTER"
			else
				echo "RANDOM"
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
			if [ ${#allPositions[@]} -lt $BOARD_SIZE ]
			then
				isplayerTurn=1
			elif [ ${#allPositions[@]} -ge $BOARD_SIZE -a $noOneWins = "true" ]
			then
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
