#!/bin/bash

group=$(groups | grep -o 'sudo');

#Desenhar menus

DrawMenu2 () {
  echo -e '\033[01;40m MENU \033[00;37m'
    echo -e '\033[01;33m 1) Instalar customização pessoal \033[00;37m'
    echo -e '\033[01;33m 2) Instalar individualmente cada dependência  \033[00;37m'
    echo -e '\033[01;33m 3) Atualizar dependências já instaladas \033[00;37m'
    echo -e '\033[05;40m Pressione q para sair \033[00;37m'
}

#Funções

function BackToMenu () {
  echo -e;
  read -p "Tudo pronto, deseja escolher outra opção ? [S/N]" voltar
    clear
}

function UpdateUpgrade () {
  sudo apt update -y && sudo apt upgrade -y;
}

function InstallGit () {
  sudo apt install git -y;
}

function InstallFish () {
  sudo apt install fish -y
    echo -e '\n \033[05;35m Deixando o fish como shell principal\033[00;37m \n'
    sudo chsh -s `which fish`
}

function InstallZSH () {
  sudo apt install zsh -y;
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    sed -i 's/robbyrussell/half-life/' ~/.zshrc
    sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc
}

function InstallOMB () {
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
    sed -i 's/OSH_THEME="font"/OSH_THEME="half-life"/' ~/.bashrc
}

function InstallASDF () {
  if [ ! -d ~/.asdf ];
  then 
    echo -e ' \n \033[00;35m Instalando asdf\033[00;37m \n '
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.1
    echo ". $HOME/.asdf/asdf.sh" >> ~/.bashrc
    echo ". $HOME/.asdf/completions/asdf.bash" >> ~/.bashrc
# clear
  else 
    echo -e '\n \033[00;31m ASDF ja está instalado! \033[00;37m \n'
      fi
}

function InstallLanguagesToASDF () {
  if [ -d ~/.asdf ];
  then
    echo -e '\n \033[00;35m Instalando nodejs\033[00;37m \n'
    sudo apt-get install dirmngr gpg curl gawk -y
    ~/.asdf/bin/asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git   
    ~/.asdf/bin/asdf install nodejs latest
    ~/.asdf/bin/asdf global nodejs latest

    echo -e '\n \033[00;35m Instalando rust\033[00;37m \n '
    ~/.asdf/bin/asdf plugin-add rust https://github.com/code-lever/asdf-rust.git
    ~/.asdf/bin/asdf install rust latest
    ~/.asdf/bin/asdf global rust latest

    echo -e '\n \033[00;35m Atualizando todos os plugins \033[00;37m \n '
    ~/.asdf/bin/asdf plugin update --all
  else
    echo -e '\n \033[05;31m ASDF não foi instalado corretamente, RODE NOVAMENTE O SCRIPT OU  INSTALE ASDF MANUALMENTE \033[00;37m \n '
      fi
}

function InstallNeoVim () {
  echo -e '\n \033[00;35m Instalando neovim  \033[00;37m \n '
    sudo add-apt-repository ppa:neovim-ppa/stable -y
    sudo apt-update
    sudo apt install neovim -y
    sudo apt upgrade -y
}

function InstallLunarVim () {
  if [ -d ~/.asdf/plugins/nodejs -a -d ~/.asdf/plugins/rust ];
  then
    echo "\n Intalando LunarVim \n"
    bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)
    mkdir -p ~/.local/share/fonts
    cd ~/.local/share/fonts && curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf
    sudo fc-cache -f -v
    echo -e '\n \033[00;35m Tudo instalado! Certifique-se de habilitar as fontes no seu terminal!  \033[00;37m \n '

    echo "____________________________________________________________________________________________________"
  else 
    echo "Não tem as dependências necessárias nodejs e rust"
      fi
}

function getGitHubPass () {
  echo -e '\n \033[00;35m Instalando SSH-Keys to GitHub \033[00;37m \n '

    if [ -f `which git` ]; then
      git config --global user.name "derleymad"
        git config --global user.email filho.wanderley@hotmail.com
          echo "Configurações do git adicionadas"
        fi

        if [ -f `which ssh` ]; then
          if [ -f ~/.ssh/id_ed25519 ]; then
            echo "Chaves ssh já criadas"
          else
            ssh-keygen -t ed25519 -C "filho.wanderley@hotmail.com"
              fi 
              fi
}

function InstallVim() {
  sudo apt install vim -y
    mkdir -p ~/.vim/pack/test/start && cd ~/.vim/pack/test/start
    git clone https://github.com/rafi/awesome-vim-colorschemes.git && \
    git clone https://github.com/mattn/emmet-vim && \
    git clone https://github.com/Yggdroot/indentLine && \
    git clone https://github.com/preservim/nerdtree && \
    git clone https://github.com/vim-airline/vim-airline && \
    git clone https://github.com/vim-airline/vim-airline-themes && \
    git clone https://github.com/tpope/vim-fugitive && \
    git clone https://github.com/shime/vim-livedown  
    cd /tmp/  
    git clone --branch "v1.2" git@github.com:derleymad/post-installation-debian.git
    cd post-installation-debian
    cp -r dotfiles/. ~ 
}

while [ "$voltar" != "n" ]
do
DrawMenu2 

if [ $group != 'sudo' ]
then
echo -e '\n\e[31;1m Pacote SUDO não encontrado. Escolha das opções para instalação\n \e[0m';
fi

read opcao

case $opcao in

1)

UpdateUpgrade
InstallGit
getGitHubPass 
InstallASDF
InstallLanguagesToASDF
InstallVim

BackToMenu;;

2)
InstallVim
BackToMenu;;
3)

BackToMenu;;
q|Q) 
exit;;
*)
clear;
BackToMenu;;

esac
done  
