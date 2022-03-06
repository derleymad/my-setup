#!/bin/bash

#Sudo grupo
group=$(groups | grep -o 'sudo');

#Diretório dos plugins
DirPlugins='~/.vim/pack/wm-plugins/start'

#Colors
Red='\033[0;31m'    # Red
URed='\033[4;31m'   # Red underline
Green='\033[0;32m'  # Green
UGreen='\033[4;32m' # Green underline
Off='\033[0m'       # Text Reset

#Informação pessoal para o git
email='filho.wanderley@hotmail.com'
username='derleymad'

#Funções
DrawMenu2 () {
  clear
  echo -e '\033[01;40m MENU \033[00;37m'
  echo -e '\033[01;33m 1) Instalar customização pessoal \033[00;37m'
  echo -e '\033[01;33m 2) Instalar individualmente cada dependência  \033[00;37m'
  echo -e '\033[01;33m 3) Desisntalar tudo \033[00;37m'
  echo -e '\033[05;40m Pressione q para sair \033[00;37m'
}

function BackToMenu () {
  echo -e;
  read -p "Tudo pronto, deseja escolher outra opção ? [S/N]" voltar
  clear
}

function AutoRemove () {
  sudo apt autoremove -y
}

function Loading () {
  PID=$!
  i=1
  sp="/-\|"
  echo -n ' '
  while [ -d /proc/$PID ]
  do
    printf "\b${sp:i++%${#sp}:1}"
    sleep 0.1
  done
  echo "Pronto [X]"
} 

function UpdateUpgrade () {
  echo -e "${Green}\nAtualizando sistema${Off}"
  sudo apt-get update -y 1>/dev/null & Loading  
  echo -e "${Green}\nFazendo upgrade no sistema${Off}"
  sudo apt-get upgrade -y 1>/dev/null & Loading 
}

#Função auxiliar para InstallGit
function getGitHubPass () {
  if [ $1 = false ]; then 
    echo "${Red}\nDesistalanddo GitHubPass${Off}"
    rm -rf ~/.ssh/id_ed25519*
  else
    echo -e "${Green}\nInstalando e configurando SSH para o GitHub${Off}"

    if [ -f `which git` ]; then
      git config --global user.name "${username}"
      git config --global user.email ${email} 
    fi

    if [ -f `which ssh` ]; then
      if [ -f ~/.ssh/id_ed25519 ]; then
        echo -e "${Green}\nChave já existe, porfavor reutilize ela em ~/.ssh${Off}"
      else
        ssh-keygen -t ed25519 -C "filho.wanderley@hotmail.com"
      fi 
    fi
  fi
}

function InstallGit () {
  if [ $1 = false ]; then 
    getGitHubPass "false"
    sudo apt-get purge --auto-remove git -y
  else 
    echo -e "${Green}\nInstalando git${Off}"
    sudo apt install git -y;
    getGitHubPass "true"
  fi
}

function InstallFish () {
  if [ $1 = false ]; then
    echo -e "${Red}\n Desinstalando o fish"
    sudo apt-get purge --auto-remove fish -y
  else
    sudo apt install fish -y
    echo -e "${Green}\nDeixando o fish como shell principal${Off}" 
    sudo chsh -s `which fish`
  fi
}

function InstallZSH () {
  if [ $1 = false ]; then
    echo -e "${Red}\n Desinstalando o zsh${Off}"
    sudo apt-get purge --auto-remove zsh -y
  else
    sudo apt install zsh -y;
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    sed -i 's/robbyrussell/half-life/' ~/.zshrc
    sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc
  fi
}

function InstallOMB () {
  if [ $1 = false ]; then #Desisntalar
    echo -e "${Red}\nDesistalanddo OMB${Off}"
    bash -c "$(curl -fsSl https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/uninstall.sh)"
  else #Instalar
    if [ ! -d ~/.oh-my-bash ]; then
      echo -e "${Green}\nInstalando Oh My Bash${Off}"
      bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
      sed -i 's/OSH_THEME="font"/OSH_THEME="half-life"/' ~/.bashrc
    else
      echo -e "${Green}\nJá está instalado, atualizando...${Off}"
    fi
  fi
}

#Função auxiliar para InstallASDF
function InstallLanguagesToASDF () {
  if [ $1 = false ]; then
    echo -e "${Red}\nDesinstalando linguagens${Off}" 
  else
    echo -e "${Green}\nInstalando NodeJS via ASDF${Off}"
    sudo apt-get install dirmngr gpg curl gawk -y
    ~/.asdf/bin/asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git   
    ~/.asdf/bin/asdf install nodejs latest
    ~/.asdf/bin/asdf global nodejs latest
    #Instalando Rust via ASDF
    echo -e "${Green}\nInstalando Rust via ASDF${Off}"
    ~/.asdf/bin/asdf plugin-add rust https://github.com/code-lever/asdf-rust.git
    ~/.asdf/bin/asdf install rust latest
    ~/.asdf/bin/asdf global rust latest
    #Atualizando plugins
    echo -e "${Green}\nAtualizando Plugins do ASDF${Off}"
    ~/.asdf/bin/asdf plugin update --all
  fi
}

function InstallASDF () {
  if [ $1 = false ]; then 
    echo -e "${Red}\nDesinstalando ASDF${Off}"
  else
    if [ ! -d ~/.asdf ];
    then 
      echo -e "${Green}\nInstalando ASDF${Off}"
      git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.1
      echo ". $HOME/.asdf/asdf.sh" >> ~/.bashrc
      echo ". $HOME/.asdf/completions/asdf.bash" >> ~/.bashrc
      # clear
    else 
      echo -e "${Green}\nASDF já foi instalado${Off}"
    fi
    InstallLanguagesToASDF 
  fi 
}

function InstallNeoVim () {
  if [ $1 = false ]; then
    echo "${Red}\nDesinstalando NeoVim${Off}"
    sudo add-apt-repository --remove ppa:neovim-ppa/stable -y
    sudo apt-get purge --auto-remove neovim -y;
  else
    echo -e "${Green}\nInstalando NeoVim${Off}"
    sudo add-apt-repository ppa:neovim-ppa/stable -y
    sudo apt-update
    sudo apt install neovim -y
    sudo apt upgrade -y
  fi
}

function InstallLunarVim () {
  if [ -d ~/.asdf/plugins/nodejs -a -d ~/.asdf/plugins/rust ];
  then
    echo -e "${Green}\nInstalando LunarVim${Off}"
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

#Função auxiliar para instalar plugins no vim
function VimPlug () {
  rm -rf ~/.vim/pack/wm-plugins/start 
  mkdir -p ~/.vim/pack/wm-plugins/start && cd ~/.vim/pack/wm-plugins/start  
  git clone https://github.com/rafi/awesome-vim-colorschemes.git && \
    git clone https://github.com/mattn/emmet-vim && \
    git clone https://github.com/Yggdroot/indentLine && \
    git clone https://github.com/preservim/nerdtree && \
    git clone https://github.com/vim-airline/vim-airline && \
    git clone https://github.com/vim-airline/vim-airline-themes && \
    git clone https://github.com/tpope/vim-fugitive && \
    git clone https://github.com/shime/vim-livedown && \
    git clone https://github.com/christoomey/vim-tmux-navigator && \
    git clone --branch release https://github.com/neoclide/coc.nvim.git --depth=1 
      vim -c 'CocInstall -sync coc-sh coc-python coc-lua coc-tsserver coc-json coc-html coc-css|q|q'
    }

  function teste () {
    if [ -d ${DirPlugins} ]; then
      rm -rf ${DirPlugins}
    fi
    mkdir -p ${DirPlugins}  && cd ${DirPlugins} 

    while read line; do
      git clone $line
      #lembrar de mudar a pasta sera que tem q ser online por wget:
    done < plugins.txt
  } 


#Função auxiliar para InstallVim
function VimAux () {
  if [ $1 = false ]; then
    echo "${Red}\nDesinstalando os dotfiles do vim${Off}"
    rm -rf ~/.vim*
  else
    rm -rf /tmp/my-setup
    cd /tmp/
    git clone https://github.com/derleymad/my-setup 
    cd my-setup/

    if [ -f ~/.vimrc ]; then
      echo -e "${Green}\nFazendo backup e instalando novos arquivos${Off}"
      mv -f ~/.vimrc ~/.vimrc.old
      cp -r dotfiles/. ~
    else
      cp -r dotfiles/. ~
    fi
  fi
}

function InstallVim() {
  if [ $1 = false ]; then
    echo -e "${Red}\nDesinstalando o vim :(${Off}"
    sudo rm -rf /tmp/* 
    sudo apt-get purge --auto-remove vim
    sudo rm -rf ~/.config/coc
    sudo rm -rf ~/.coc
  else
    echo -e "${Green}\nInstalando Vim e os plugins${Off}"
    sudo apt install vim -y
    VimPlug #Instala plugins para o Vim
    if [ -d /tmp/my-setup ]; then
      rm -rf /tmp/my-setup
      VimAux "true"
    else
      VimAux "True"
    fi 
  fi
}

function TmuxAux () {
  if [ $1 = false ]; then
    echo "${Red}\nDesistalando dotfiles do tmux${Off}"
    sudo rm -rf /tmp/*
    sudo rm -rf ~/.tmux*
  else
    rm -rf /tmp/my-setup
    cd /tmp/
    git clone https://github.com/derleymad/my-setup 
    cd my-setup/
    if [ -f ~/.tmux.conf ]; then 
      echo -e "${Red}\nFazendo backup e instalando arquivos novos${Off}"
      mv -f ~/.tmux.conf ~/.tmux.conf.old
      cp -r dotfiles/. ~ 
    else
      cp -r dotfiles/. ~ 
    fi
  fi
} 

function InstallTmux () {
  if [ $1 = false ]; then
    echo "${Red}\nDesistalanddo Tmux${Off}" 
    sudo apt-get purge --auto-remove tmux -y
    TmuxAux "false"
  else
    sudo apt install tmux -y;
    TmuxAux "true"
  fi
}

#Main
while [ "$voltar" != "n" ]; do

  DrawMenu2 

  if [ $group != 'sudo' ]; then
    echo -e "{URed}\n Pacote sudo não encontrado${Off}"
  fi

  read opcao

  case $opcao in
    1)

#Instalação Pessoal
UpdateUpgrade
InstallOMB "true"
InstallGit "true"
InstallASDF "true" 
InstallTmux "true"
InstallVim "true"
BackToMenu;;

2)
  UpdateUpgrade
  BackToMenu;;

3)
  InstallOMB "false"
  BackToMenu;;


q|Q) 
  exit;;

*)
  clear;
  BackToMenu;;

esac
done  
