#!/bin/bash

#In the background, fetch the latest classes from online
python3 ./get-classes.py &

VERSION="1.0.0"
AUTHORS="Javier Ramirez, Gabriella Quintana"

echo CourseAvail CLI $VERSION
echo Copyright $AUTHORS
echo Let us help you find your classes.
echo "Search by entering a regular expression."
echo "You can also enter a search filter, such as \"dept\", \"number\", \"session\", \"title\", \"time\", \"location\", \"prof\", or \"seats\" to begin."

#Kill python processes if interrupt occurs or if called
exitfn () {
    pkill -f get-classes.py    
    exit 0
}
trap exitfn INT

#Format our output from CSV into columns for easy viewing
formatfn() {
  awk -F "\t" '{ printf "%-9s  %-5s  %-1s  %-#40s  %-21s  %-11s  %-30s %-5s\n", $1, $2, $3, $4, $5, $6, $7, $8}'
}


while [ 1 -eq 1 ]; do
  echo -n ">>> "
  read input

  #EXIT
  if [ $input = "exit" ]; then
    #kill python processes when exiting
    exitfn

  #COPYRIGHT
  elif [ $input = "copyright" ]; then
      echo "Copyright (c) 2019 $AUTHORS."
      echo "All Rights Reserved."

  #VERSION
  elif [ $input = "version" ] || [ $input = "--version" ]; then
      echo "$VERSION"

  #SEARCH by dept
  elif [ $input = "dept" ]; then
    echo "Which department (such as ACTG) would you like to choose?"
    read filter
    cat ./classes-export.csv | grep -Ei "^$filter" | formatfn
  
  #SEARCH by course number
  elif [ $input = "number" ]; then
    echo "Which class number (such as 90995) would you like to choose?"
    read filter
    cat ./classes-export.csv | grep -E "^[A-Z0-9 ]*\t$filter" | formatfn

  #SEARCH by session number
  elif [ $input = "session" ]; then
    echo "Which session (such as '1') would you like to choose?"
    read filter
    cat ./classes-export.csv | grep -E "^[A-Z0-9 ]*\t[0-9]*\t$filter" | formatfn

  #SEARCH by class title
  elif [ $input = "title" ]; then
    echo "Which class title would you like to choose? Enter a word, such as 'dance'"
    read filter
    cat ./classes-export.csv | grep -Ei "^[A-Z0-9 ]*\t[0-9]*\t[0-9]\t[a-zA-Z &:0-9]*$filter[a-zA-Z &:0-9]*\t" | formatfn

  #SEARCH by class time
  elif [ $input = "time" ]; then
    echo "Which time would you like to choose? Enter a day(s) of the week, such as MWF"
    read filter
    cat ./classes-export.csv | grep -Ei "^[A-Z0-9 ]*\t[0-9]*\t[0-9]\t[a-zA-Z &:0-9]*\t$filter" | formatfn
    
  #SEARCH by class location
  elif [ $input = "location" ]; then
    echo "Which location (such as LUCAS) would you like to choose?"
    read filter
    cat ./classes-export.csv | grep -Ei "[ 0-9a-zA-Z]*$filter[ 0-9a-zA-Z]*\t[-A-Za-z\, ]*\t[^\t]+$" | formatfn
    
  #SEARCH by professor
  elif [ $input = "prof" ]; then
    echo "Which instructor (last name only) would you like to choose?"
    read filter
    cat ./classes-export.csv | grep -Ei "\t$filter[-A-Za-z\, ]*\t[^\t]+$" | formatfn

  #SEARCH by number of seats in the class
  elif [ $input = "seats" ]; then
    echo "How many seats would you like to choose?"
    read filter
    cat ./classes-export.csv | grep -Ei "\t$filter$" | formatfn

  #SEARCH by REGEX
  else 
    cat ./classes-export.csv | grep -Ei "$input" | formatfn
  fi

done 
