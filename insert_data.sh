#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
$PSQL "truncate teams,games" 
cat games.csv | while IFS="," read y r w o wg og
do
F=$($PSQL "select name from teams where name='$w'")
if [[ $w != 'winner' ]]
then
  if [[ -z $F ]]
  then
    INS_TEAM=$($PSQL "insert into teams(name) values('$w');")
    if [[ $INS_TEAM == 'INSERT 0 1' ]]
    then
      echo "Inserted into teams, $w"
    fi
  fi
fi
T2=$($PSQL "select name from teams where name='$o'")
if [[ $o != "opponent" ]] 
then
  if [[ -z $T2 ]]
  then
     INS_T2=$($PSQL "insert into teams(name) values('$o');")
     if [[ $INS_T2 == 'INSERT 0 1' ]]
     then
      echo 'Inserted into teams',$o
     fi
   fi
fi
W_ID=$($PSQL "select team_id from teams where name='$w'")
O_ID=$($PSQL "select team_id from teams where name='$o'")
if [[ -n $W_ID || -n $O_ID ]]
then
  INS_INTO_GAMES=$($PSQL "insert into games(year,round,winner_goals,opponent_goals,winner_id,opponent_id) values($y,'$r',$wg,$og,$W_ID,$O_ID)")
  if [[ $INS_INTO_GAMES == "INSERT 0 1" ]]
  then
    echo "Inserte into games, $w"
  fi
fi
done