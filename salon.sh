#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~"
echo -e "\nWelcome to My Salon, how can I help you?"

QUERY_DATA=$($PSQL "SELECT service_id, name FROM services")
echo -e "\n$QUERY_DATA" | sed 's/|/) /'

MAIN_MENU(){
  echo -e "\nI could not find that services. What would like today"
  echo -e "\n$QUERY_DATA" | sed 's/|/) /'
}

IFS=')' read -r NAME PHONE SERVICE_ID TIME <<< "$QUERY_DATA"
read SERVICE_ID_SELECTED
if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]$ ]]; then
  MAIN_MENU
else
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  QUERY_PHONE_NUMBER=$($PSQL "SELECT phone FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  if [[ -z $QUERY_PHONE_NUMBER ]]; then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    INSERT_YOUR_NAME=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  fi
    SELECT_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    SELECT_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    echo -e "\nWhat time would you like your $SELECT_SERVICE, $SELECT_NAME?"
    SELECT_SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    SELECT_CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    read SERVICE_TIME
    INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(time, service_id, customer_id) VALUES('$SERVICE_TIME', $SELECT_SERVICE_ID, $SELECT_CUSTOMER_ID)")
    echo -e "\nI have put you down for a $SELECT_SERVICE at $SERVICE_TIME, $SELECT_NAME.\n"
fi

