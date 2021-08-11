#!/usr/bin/env bash

SERVICE=ssh

AUTH_ERR1="Unable to negotiate with"
AUTH_ERR2="Invalid user"
AUTH_ERR3="Connection reset by authenticating user"
#AUTH_ERR4="Accepted publickey"


# Parse year function
parse_year(){
if grep -q "Logs begin at" <<< "$1"
then
    # -o return only match rezult
    year=$(grep -oEw "([[:digit:]]{4})" <<< "$1")
    # Took first 4 simbols. Owervise if journalctl followed 
    # -n, grep fing two occurances
    year=${year:0:4}
#    continue
fi
}


# Searching for date, servise and description with sed(file field_sep.sed)
# Assighn 3 variables throue read
find_field(){
IFS="|"
read date service description<<< \
        $(echo "$1" | sed -E -f field_sep.sed)
if $(echo "$description" | grep -qE "$AUTH_ERR1|$AUTH_ERR2|$AUTH_ERR3")
then
    # Searching for ip-address
    ip=$(grep -oE "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" <<< $description)
    unset IFS
    return 0
fi
return 1
}
    
# Monitoring Logs for service notification
sudo journalctl -u $SERVICE -n 0 -f | while read line

do
    parse_year "$line"
    find_field "$line"    

    if [ "$?" -eq 0 ]
    then
        echo "$line"
        echo "$year $date|$description" >> hackers/"$ip".txt
    fi

done 
