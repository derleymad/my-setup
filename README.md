# Para usar pós instalação linux

Script simples para instalar de programas após a instalação de alguma distribuição baseada em debian 

__Programas que o Script Instala:__
- Atualiza sistema
- Instala dotfiles
- Instala Git e configurações pessoais
- Install OMB
- Instala Vim e plugins  
- ASDF e plugins nodejs, rust, ruby, lua

## Installation

Via wget for linux:
```bash
bash -c "$(wget https://raw.githubusercontent.com/derleymad/my-setup/main/install.sh -O -)"
```

Via powershell for windows:
```powershell
powershell -Command Invoke-WebRequest -Uri https://raw.githubusercontent.com/derleymad/my-setup/main/install-win.bat -OutFile install-win.bat; & ".\install-win.bat"
```


Via git clone:
```bash
git clone https://github.com/derleymad/my-setup
cd my-setup
install.sh
```


## License
https://raw.githubusercontent.com/derleymad/my-setup/main/LICENSE
