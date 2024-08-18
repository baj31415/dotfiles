echo "Utkarsh's Dotfiles Installer"



#Update first

sudo apt update -y && sudo apt upgrade -y
 
#utilities
sudo apt remove vim -y
sudo apt install locate tmux bat neovim ranger curl -y

#apt
sudo apt install -y cheese code
sudo apt install -y gnome-tweaks


#change browser 
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge-dev.list'
sudo rm microsoft.gpg
sudo apt install -y microsoft-edge-stable

sudo apt remove firefox -y

#snap package manager
sudo apt install snapd -y
sudo snap install vlc 


#TERMINAL

mkdir -p ~/dev/repos
cd ~/dev/repos



#install zsh
sudo apt install zsh -y

#make zsh default
chsh -s $(which zsh)

# #ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"



#ZSH PLUGINS 

if ! command -v <the_command> &> /dev/null
then 
    #znap
    echo "[[ -r ~/dev/repos/znap/znap.zsh ]] ||
        git clone --depth 1 -- \
            https://github.com/marlonrichert/zsh-snap.git ~/dev/repos/znap
    source ~/dev/repos/znap/znap.zsh" >> ~/.zshrc

    #z search script
    echo "znap source agkozak/zsh-z" >> ~/.zshrc

    #autocomplete
    echo "znap source marlonrichert/zsh-autocomplete" >>~/.zshrc

    #autosuggestions
    echo "znap source zsh-users/zsh-autosuggestions" >>~/.zshrc

    #syntax highlight

    echo "znap source zsh-users/zsh-syntax-highlighting"  >>~/.zshrc

fi
#copy my zsh config
cp ~/dev/dotfiles/zshrc ~/.zshrc


#tmux
cp ~/dev/dotfiles/tmux.conf ~/.tmux.conf
tmux source-file ~/.tmux.conf

#VS Code Installs
source ~/dev/dotfiles/vscode.sh


