echo "Type in your username: "
read user_name

echo "Type in your email address (the one used for your GitHub account): "
read email

git config --global user.email "$email"
git config --global user.name "$user_name"

echo "Awesome, all set."