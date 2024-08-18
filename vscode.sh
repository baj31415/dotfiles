#!/bin/zsh

echo "Starting to configure VS Code" 

#VS Code

sudo apt install code -y

#VSCode Extensions

#python
code --install-extension ms-python.python

#black formatter 
code --install-extension ms-python.black-formatter

#c++
code --install-extension ms-vscode.cpptools
code --install-extension ms-vscode.cpptools-extension-pack

#dracula
code --install-extension dracula-theme.theme-dracula

 
