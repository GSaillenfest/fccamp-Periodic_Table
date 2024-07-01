#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then 
  echo Please provide an element as an argument.
else 
# test argument format
# get element atomic number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$($PSQL "select atomic_number from elements inner join properties using(atomic_number) inner join types using(type_id) where atomic_number=$1")
  else 
    ATOMIC_NUMBER=$($PSQL "select atomic_number from elements inner join properties using(atomic_number) inner join types using(type_id) where name='$1' or symbol='$1'")
  fi
# get element properties
  if [[ $ATOMIC_NUMBER ]]
  then  
    SELECTED_VALUES=$($PSQL "select * from elements inner join properties using(atomic_number) inner join types using(type_id) where atomic_number=$ATOMIC_NUMBER") 
    echo $SELECTED_VALUES | while read TYPE_ID BAR ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR MASS BAR MELT_POINT BAR BOIL_POINT BAR TYPE
    do
      echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT_POINT celsius and a boiling point of $BOIL_POINT celsius."
    done
  # if not found
  else 
    echo I could not find that element in the database.
  fi
fi