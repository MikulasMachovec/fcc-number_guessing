#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=num_guessing -t --no-align -c"

echo "Enter your username:"
read NAME
# find user_id
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$NAME' " )

#if not found
if [[ -z $USER_ID ]]
  then
  # first timer
    echo "Welcome, $NAME! It looks like this is your first time here."
    NEW_USER_INSERT=$($PSQL "INSERT INTO users(username, games_played, best_game) VALUES('$NAME',0,0 )" )
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

#After game player update fun




GAME(){
RANDOM_NUMBER=$((1 + RANDOM % 1000))
GUESSED=false
echo $RANDOM_NUMBER
TRIES=0
echo "Guess the secret number between 1 and 1000:"
while [[ $GUESSED == false  ]]
do 
  read GUESS
  if [[ $GUESS =~ ^[0-9+$] ]]
  then
    ((TRIES++))
    if [[ $GUESS == $RANDOM_NUMBER ]]
    then
      echo "You guessed it in $TRIES tries. The secret number was $RANDOM_NUMBER. Nice job!"
      
      GUESSED=true
    elif [[ $GUESS -lt $RANDOM_NUMBER  ]]
    then
      echo "It's higher than that, guess again:"
    else
      echo "It's lower than that, guess again:"
    fi
    
  else
  echo "That is not an integer, guess again:"
  fi

done
}

MAIN_GAME(){
  GAME
}

MAIN_GAME