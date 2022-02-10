#!/bin/bash

group=$(groups | grep -o 'sudo');

function BackToMenu () {
    echo -e;
    read -p "Tudo pronto, deseja escolher outra opção ? [S/N]" voltar
    clear
}

DrawOpcNonFree () {
      echo   "
             |--------------------------------------------------|
             |               Escolha uma Opção                  |
             |--------------------------------------------------|
             | 1) - Adiconar contrib e non-free                 |
             | 2) - Adicionar non-free                          |
             |--------------------------------------------------|
             |             Pressioner (q) para sair             |
             |--------------------------------------------------|
             "
}

DrawMenu () {
         echo "
              |--------------------------------------------------|
              |                      Menu                        |
              |--------------------------------------------------|
              | 1) Atualizar o sistema                           |
              | 2) Adiconar non-free ou contrib/non-free         |
              | 3) Instalar Ufw                                  |
              | 4) Instalar Build-essential                      |
              | 5) Instalar Atom                                 |
              | 6) Instalar Telegram                             |
              | 7) Instalar Ruby Gems                            |
              | 8) Instalar Jekyll                               |
              | 9) Instalar NodeJs                               |
              | 10) Instalar Vim                                 |
              | 11) Instalar Tmux                                |
              | 12) Instalar Inkscape                            |
              | 13) Instalar Gimp                                |
              | 14) Instalar Audacity                            |
              | 15) Instalar Kdenlive                            |
              | 16) Instalar Vlc                                 |
              | 17) Instalar Chromium                            |
              | 18) Instalar Terminal do XFCE                    |
              | 19) Instalar Compose                             |
              | 20) Instalar LAMP                                |
              | 21) Instalar o git                               |
              | 22) Instalar o sudo                              |
              |--------------------------------------------------|
              |             Pressioner (q) para sair             |
              |--------------------------------------------------|
              "
}

DrawLogo () {
  clear;
  echo -e "\e[36;1m
	▓█████▄ ▓█████  ▄▄▄▄    ██▓███   ▒█████    ██████
	▒██▀ ██▌▓█   ▀ ▓█████▄ ▓██░  ██▒▒██▒  ██▒▒██    ▒
	░██   █▌▒███   ▒██▒ ▄██▓██░ ██▓▒▒██░  ██▒░ ▓██▄
	░▓█▄   ▌▒▓█  ▄ ▒██░█▀  ▒██▄█▓▒ ▒▒██   ██░  ▒   ██▒
	░▒████▓ ░▒████▒░▓█  ▀█▓▒██▒ ░  ░░ ████▓▒░▒██████▒▒
	 ▒▒▓  ▒ ░░ ▒░ ░░▒▓███▀▒▒▓▒░ ░  ░░ ▒░▒░▒░ ▒ ▒▓▒ ▒ ░
	  ░ ▒  ▒  ░ ░  ░▒░▒   ░ ░▒ ░       ░ ▒ ▒░ ░ ░▒  ░ ░
	   ░ ░  ░    ░    ░    ░ ░░       ░ ░ ░ ▒  ░  ░  ░
	      ░       ░  ░ ░                   ░ ░        ░
	       ░                   ░
  \e[0m";
}

DrawLogo

while [ "$voltar" != "n" ]
  do
    DrawMenu
  if [ $group != 'sudo' ]
    then
        echo -e '\n\e[31;1m Pacote SUDO não encontrado. Escolha a opção 21 para instalação\n \e[0m';
  fi

  read -p "Escolha uma das opções: " opcao

    case $opcao in

      1) sudo apt update -y && sudo apt upgrade -y
          BackToMenu;;

      2) clear
            DrawOpcNonFree;
            read -p "Escolha uma das opções: " sourcelist

            case $sourcelist in
              1) sudo sed -i 's/main/main contrib non-free/g' /etc/apt/sources.list ;;
              2) sudo sed -i 's/main/main non-free/g' /etc/apt/sources.list ;;

              q|Q) exit ;;

              *) echo "Só tem dá opção 1 e 2"
              read -p "Escolha uma das opções: " sourcelist;;
            esac
          BackToMenu;;

      3) sudo apt install ufw && sudo ufw enable
          BackToMenu;;

      4) sudo apt install build-essential
          BackToMenu;;   

      5) cd /tmp &&
          wget -cO atom.deb https://atom.io/download/deb &&
          sudo dpkg -i atom.deb &&
          sudo apt -f install &&
          sudo dpkg -i atom.deb
          BackToMenu;;

      6) cd /tmp &&
          wget -O telegram.tar.xz https://telegram.org/dl/desktop/linux &&
          sudo tar -xJf telegram.tar.xz -C /opt/ &&
          cd /opt/Telegram/ &&
          ./Telegram
          BackToMenu;;

      7) cd /tmp &&
          wget https://rubygems.org/pages/download -O version.html &&
          Version=$(cat version.html | grep tgz | tr / " " | tr '"' " " | cut -d- -f2 | cut -d" " -f1) &&
          sudo apt install build-essential ruby-full &&
          wget -c https://rubygems.org/rubygems/rubygems-$Version &&
          tar -xf rubygems-$Version &&
          cd rubygems-* &&
          sudo ruby setup.rb  &&
          gem --version
          BackToMenu;;

      8) cd /tmp &&
          wget https://rubygems.org/pages/download -O version.html &&
          Version=$(cat version.html | grep tgz | tr / " " | tr '"' " " | cut -d- -f2 | cut -d" " -f1) &&
          sudo apt install build-essential ruby-full &&
          wget -c https://rubygems.org/rubygems/rubygems-$Version &&
          tar -xf rubygems-$Version &&
          cd rubygems-* &&
          sudo ruby setup.rb  &&
          sudo gem install jekyll bundler &&
          jekyll -v
          BackToMenu;;

      9) cd /tmp && 
          wget https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions &&
          Version=$(cat index.html | grep 'Alternatively' | tr -d [a-zA-Z] | awk '{print $3}' | cut -d: -f1 | head -n1) &&
          sudo apt install curl build-essential &&
          curl -sL https://deb.nodesource.com/setup_$Version.x | sudo -E bash - &&
          sudo apt install nodejs &&
          node -v
          BackToMenu;;

      10) sudo apt install vim 
            clear
            read -p "Vim instalado, deseja baixar a melhor configuração para ele? (É necessário git instalado) S/n?" install
            if [ $install != 'n' ]
                then 
                  sudo apt install git -y
                  sudo git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
                  sh ~/.vim_runtime/install_awesome_vimrc.sh
            fi
            BackToMenu;;

      11) sudo apt install tmux 
            BackToMenu;;

      12) sudo apt install inkscape 
            BackToMenu;;

      13) sudo apt install gimp 
            BackToMenu;;

      14) sudo apt install audacity 
            BackToMenu;;

      15) sudo apt install kdenlive 
            BackToMenu;;

      16) sudo apt install vlc 
            BackToMenu;;

      17) sudo apt install chromium 
            BackToMenu;;

      18) sudo apt install xfce4-terminal 
            BackToMenu;;

      19) EXPECTED_SIGNATURE=$(wget -q -O - https://composer.github.io/installer.sig)
          php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
          ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');")

          if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]
          then
              >&2 echo 'ERROR: Invalid installer signature'
              rm composer-setup.php
              exit 1
          fi

          php composer-setup.php --quiet
          RESULT=$?
          rm composer-setup.php
          sudo mv composer.phar /usr/local/bin/composer
          BackToMenu;;

      20) sudo apt update -y &&
          sudo apt upgrade -y &&
          sudo apt install apache2 -y &&
          sudo apt install mariadb-server -y &&
          sudo apt install php7.0 libapache2-mod-php7.0 php7.0-mysql -y &&
          sudo systemctl restart apache2
          BackToMenu;;

      21) sudo apt install git -y
          BackToMenu;;

      22) su &&
          apt install sudo -y &&
          adduser $USER sudo
          BackToMenu;;
      
      q|Q) exit ;;

      *) echo "Só tem dá opção 1 até 21"
        BackToMenu;;
    esac

done
