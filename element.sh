#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"
AN=0

DIGIT_MENU() {
OTHER() {
symbol=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$AN;")
type=$($PSQL "SELECT type FROM types t JOIN properties p ON p.type_id=t.type_id  WHERE atomic_number=$AN;")
mass=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$AN;")
mp=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$AN;")
bp=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$AN;") 

echo "The element with atomic number $AN is $name ($symbol). It's a $type, with a mass of $mass amu. $name has a melting point of $mp celsius and a boiling point of $bp celsius."
}

name=$($PSQL "SELECT name FROM elements WHERE atomic_number=$AN;")
if [ ! $name ]
then echo "I could not find that element in the database."
else OTHER
fi
} 

if [ ! $1 ]
  then echo "Please provide an element as an argument."
  else if [[ "$1" =~ [A-Za-z] ]] # if it's a string
    then if [ ${#1} -ge 4 ] 
      then # if string is long 
        AN=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1';")
        if [ ! $AN ]
          then echo "I could not find that element in the database."
          else DIGIT_MENU
        fi 
      else # if string is short 
        AN=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1';")
        if [[ ! $AN ]]
          then echo "I could not find that element in the database."  
          else DIGIT_MENU
        fi
      fi
    else # if it's not a string (a number)
      if [ ! $1 == 0 ]
        then 
        AN=$1
        DIGIT_MENU
      fi
    fi
fi
