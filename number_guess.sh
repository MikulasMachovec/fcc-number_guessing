#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=<database_name> -t --no-align -c"

echo "Enter your username:"
read NAME
# find user_id
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$NAME' " )

#if not found
if [[ -z $USER_ID ]]
  then
  # first timer
    echo "Welcome, $NAME! It looks like this is your first time here."
  else
  #if user already exist
   #get name
   USERNAME=$($PSQL "SELECT username FROM users WHERE user_id=$USER_ID" )
   #get played games
   PLAYED=$($PSQL "SELECT games_played FROM users WHERE user_id=$USER_ID" )
   #get best game 
   BEST=$($PSQL "SELECT best_game FROM users WHERE user_id=$USER_ID")
  echo "Welcome back, $USERNAME! You have played $PLAYED games, and your best game took $BEST guesses."
fi