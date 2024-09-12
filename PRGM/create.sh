#!/bin/bash

# Script to create a new account

cd /home/deverell-manning/Public/HOUSE/
_SALT=HP

echo "Enter Username:"
read -p "> " username

echo "Enter Full Name:"
read -p "> " fullname

echo "Enter Password:"
read -p "> " password

echo "Enter Again to Verify:"
read -p "> " verify

if [[ $verify != $password ]]; then
	echo "Passwords did not match. Abort!"
	exit 1
fi

echo "Computing hash..."
hash=$(openssl passwd -salt "$_SALT" "$password")

echo "Hash is '$hash'"

echo "Creating User Directory"
mkdir "./SERVER/USERS/${username}"

echo "Writing secret file:"
echo "@User
\`hash=$hash\`
\`hint=password1234\`
@End" > "./SERVER/USERS/${username}/secrets"

echo "Writing user file:"
echo "@User
\`owner=${fullname}\`
\`username=${username}\`
\`lastlogin=\`
@End" > "./SERVER/USERS/${username}/user"

echo "Creating Character File:"
touch "./SERVER/USERS/${username}/characters"

echo "Creating Log Directory:"
mkdir "./SERVER/USERS/${username}/log"

