#!/bin/bash
readarray -t lines < $1
username=${lines[0]}
password=${lines[1]}
echo "USERNAME:"
echo $username

# Replace your own authentication mechanism here
if [[ $username == "user" ]]; then
    if [[ $password == "userpassword" ]]; then
    echo "ok"
    exit 0
    fi
fi
if [[ $username == "user2" ]]; then
    if [[ $password == "user2password" ]]; then
    echo "ok"
    exit 0
    fi
fi
if [[ $username == "user3" ]]; then
    if [[ $password == "user3password" ]]; then
    echo "ok"
    exit 0
    fi
fi

echo "not ok"
exit 1