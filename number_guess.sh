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
    #get new user_id
    USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$NAME' " )
    #set new suer for 0 in best and played
    games_played=0
    best_game=0
  else
  #if user already exist
   #get name
   username=$($PSQL "SELECT username FROM users WHERE user_id=$USER_ID" )
   #get played games
   games_played=$($PSQL "SELECT games_played FROM users WHERE user_id=$USER_ID" )
   #get best game 
   best_game=$($PSQL "SELECT best_game FROM users WHERE user_id=$USER_ID")

  echo Welcome back, $username! You have played $games_played games, and your best game took $best_game guesses.

fi

#After game player update fun
DATA_UPDATE(){
NUMBER_OF_TRIES=$1

#comparison of previous best against current run
if [[ $best_game == 0 ]]
  then
    best_game=$NUMBER_OF_TRIES
  elif [[ $NUMBER_OF_TRIES -lt $best_game ]]
  then
  echo "NEW BEST"
  best_game=$NUMBER_OF_TRIES
fi

# adding +1 to played games
((games_played++))
#insert of new values
DATA_INSERT=$($PSQL "UPDATE users SET games_played=$games_played, best_game=$best_game WHERE user_id=$USER_ID")

}

GAME(){

RANDOM_NUMBER=$((1 + RANDOM % 1000))
GUESSED=false
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
      DATA_UPDATE $TRIES
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