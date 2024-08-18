sudo apt purge -y vim neovim vim-tiny 

sudo apt install -y neovim ripgrep 

git clone https://github.com/ryanoasis/nerd-fonts.git


rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim

git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim 


