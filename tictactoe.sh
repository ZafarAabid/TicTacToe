#!/bin/bash -x

echo "----welcome----"

#declaring constants
declare NO_OF_ROW_COLUMNS=3;
declare BOARD_SIZE=$(($NO_OF_ROW_COLUMNS * $NO_OF_ROW_COLUMNS))

#declaring varibles


#declaring directories
declare -a boardOfTicTacToe

function resetTheBoard()
{
 for (( places=1; places <=$BOARD_SIZE; places++ ))
 do
   boardOfTicTacToe[$places]="-";
 done
}

resetTheBoard
echo ${boardOfTicTacToe[@]}
