#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

GET_ELEMENT() {
    if [[ $1 ]]
    then
      if [[ ! $1 =~ ^[0-9]+$ ]]
      then
        ELEMENT_INFO=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements e JOIN properties p ON e.atomic_number = p.atomic_number JOIN types t ON p.type_id = t.type_id WHERE e.symbol = '$1' OR e.name = '$1'")
      else
        ELEMENT_INFO=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements e JOIN properties p ON e.atomic_number = p.atomic_number JOIN types t ON p.type_id = t.type_id WHERE e.atomic_number = $1")
      fi
        if [[ -z $ELEMENT_INFO ]]
        then
          echo "I could not find that element in the database."
        else
          FORMATTED_INFO=$(echo "$ELEMENT_INFO" | sed 's/|//g' | sed 's/\s\s*/ /g')
          read -r ATOMIC_NUMBER SYMBOL NAME TYPE MASS MELTING_POINT BOILING_POINT <<< "$FORMATTED_INFO"
          echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
        fi
    else
      echo Please provide an element as an argument.
    fi
}

GET_ELEMENT "$1"