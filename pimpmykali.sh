#!/bin/bash
# hum4ng0d version of kali

# Define color codes
blue='\033[0;34m'
green='\033[0;32m'
reset='\033[0m'

echo "${blue}pimpmykali v0.1${reset}"
echo "${blue}Start of a new adventure...${reset}"

user="kali"
sudo chown -R $user:$user /opt
echo "${green}[+] Successfully set chown of /opt to $user.${reset}"

rm -rf ~/Public ~/Videos ~/Pictures ~/Music ~/Documents ~/Templates
echo "${green}[+] Successfully deleted useless folders.${reset}"
mkdir ~/www && mkdir /opt/pimpmykali
curl -o /opt/pimpmykali/kali-new-16x9.png https://github.com/hum4nG0D/pimpmykali/raw/main/images/kali-new-16x9.png
echo "${green}[+] Successfully downloaded wallpaper to /opt/pimpmykali.${reset}"

# List of packages to install
packages=(
    gedit
    golang-go
    seclists
    curl
    dnsrecon
    enum4linux
    feroxbuster
    gobuster
    impacket-scripts
    nbtscan
    nikto
    nmap
    onesixtyone
    oscanner
    redis-tools
    smbclient
    smbmap
    snmpwalk
    sslscan
    svwar
    tnscmd10g
    whatweb
    wkhtmltopdf
    htop
    xrdp
)

sudo apt update

for package in "${packages[@]}"
do
  sudo apt install -y "$package"
  echo "${green}[+] Successfully installed $package.${reset}"
done

sudo apt update

# List of repositories to clone
repositories=(
    https://github.com/t3l3machus/hoaxshell.git
    https://github.com/t3l3machus/Villain.git
    https://github.com/s0md3v/XSStrike.git
    https://github.com/hum4nG0D/simple-HTTPS-server.git
    https://github.com/hum4nG0D/lfi-fuzz.git
    https://github.com/killmongar1996/sqlTinj.git
    https://github.com/enjoiz/XXEinjector.git
    https://github.com/shelld3v/JSshell.git
    https://github.com/swisskyrepo/GraphQLmap.git
    https://github.com/21y4d/nmapAutomator.git
    https://github.com/cyberark/MITM_Intercept.git
    https://github.com/jrmdev/mitm_relay.git
    https://github.com/9emin1/charlotte.git
)

for repository in "${repositories[@]}"
do
  # Extract repository name from URL
  repo_name="${repository##*/}"
  repo_name="${repo_name%.*}"
  
  if [ -d "/opt/$repo_name" ]
  then
    echo "${blue}[i] $repo_name already exists in /opt directory. Skipping cloning step.${reset}"
  else
    cd /opt
    echo "${blue}[i] Cloning $repository...${reset}"
    git clone "$repository"
  fi
  
  if [ -f "/opt/$repo_name/requirements.txt" ]
  then
    echo "${blue}[i] Installing requirements for $repo_name...${reset}"
    python3 -m pip install -r "/opt/$repo_name/requirements.txt"
    echo "${green}[+] Successfully installed requirements for $repo_name.${reset}"
  fi
done

#Manual steps
#Cloning tplmap
git clone https://github.com/epinna/tplmap.git
echo "${green}[+] Successfully cloned tplmap.${reset}"

#creating python2 virtual env
python3 -m virtualenv ~/py2
echo "${green}[+] Successfully created py2 virtualenv.${reset}"
python3 -m virtualenv --python=/usr/bin/python2 ~/py2
echo "${green}[+] Successfully set python2 for py2.${reset}"
