# Para usar pós instalação linux

Script simples para instalar de programas após a instalação de alguma distribuição baseada em debian 

__Programas que o Script Instala:__
- Atualiza sistema
- Instala dotfiles
- Instala Git e configurações pessoais (mudar no install.sh email e username)
- Install OMB
- Instala Vim e plugins  
- ASDF e plugins nodejs, rust, ruby, lua;

## Installation __

Via wget:
```bash
bash -c "$(wget https://raw.githubusercontent.com/derleymad/my-setup/main/debian.sh -O -)"
```


Via git clone:
```bash
git clone https://github.com/derleymad/my-setup
cd my-setup
bash install.sh
```

## License
[Here]
(https://raw.githubusercontent.com/derleymad/my-setup/main/LICENSE)
