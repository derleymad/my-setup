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

function InstallASDF () {
  if [ ! -d ~/.asdf ];
  then 
    echo -e ' \n \033[00;35m Instalando asdf\033[00;37m \n '

    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.1
    sed '/end/i source ~/.asdf/asdf.fish' ~/.config/fish/config.fish
    mkdir -p ~/.config/fish/completions; and ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions
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

  if [ -d `which git` ]; then
    git config --global user.name "derleymad"
    git config --global user.email filho.wanderley@hotmail.com
  fi

  if [ -d `which ssh` ]; then
    ssh-keygen -t ed25519 -C "filho.wanderley@hotmail.com"
    sudo apt install xclip -y
    cat ~/.ssh/id_ed25519.pub | xclip -selection clipboard
    echo -e '\n \033[00;35m Chave copiada para o clipboard \033[00;37m \n '
    /usr/bin/firefox --new-window  https://github.com/settings/ssh/new
  fi
  
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
      #Atualizando sistema
      UpdateUpgrade
      #Instalando git 
      InstallGit
      #Instalando ZSH e ativando Plugins

      #Instalando ASDF
      InstallASDF
      #Instalando Linguagens para ASDF
      InstallLanguagesToASDF
      #Instalando neovim 
      InstallNeoVim
      #Instalando LunarVim
      InstallLunarVim
      #Instalando Chaves SSH Para GitHub
      getGitHubPass

      BackToMenu;;

    2)
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
