#!/bin/bash
# hum4ng0d version of kali
# 
# Pre-requisite:
# Add the user to sudoer group and set nopassword for sudo.
# usermod -aG sudo username
# echo '%sudo ALL=(ALL:ALL) NOPASSWD:ALL' | sudo EDITOR=tee visudo -f /etc/sudoers.d/dist-build-sudo-passwordless >/dev/null
#

# Define color codes
blue='\033[0;34m'
green='\033[0;32m'
reset='\033[0m'

echo -e "${blue}pimpmykali v0.1${reset}\n"
echo -e "${blue}Start of a new adventure...\n${reset}"

user="kali"
if ! sudo chown -R $user:$user /opt; then
  echo "[-] Error: Failed to chown /opt dir." >&2
  exit 1
fi

echo "${green}[+] Successfully set chown of /opt to $user.${reset}"

###############################################################################################

rm -rf ~/Public ~/Videos ~/Pictures ~/Music ~/Documents ~/Templates
echo "${green}[+] Successfully deleted useless folders.${reset}"
mkdir ~/www && mkdir /opt/pimpmykali
curl -o /opt/pimpmykali/kali-new-16x9.png https://github.com/hum4nG0D/pimpmykali/raw/main/images/kali-new-16x9.png
echo "${green}[+] Successfully downloaded wallpaper to /opt/pimpmykali.${reset}"


# List of packages to install #################################################################
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

echo "[i] Updating Apt package list..."
if ! sudo apt update; then
  echo "[-] Error: Failed to update Apt package list." >&2
  exit 1
fi

echo -e "[+] Apt package list updated successfully.\n"

for package in "${packages[@]}"
do
  sudo apt install -y "$package"
  echo "${green}[+] Successfully installed $package.${reset}"
done

sudo apt update
echo -e "${green}[+] Installation of apt packages completed.\n${reset}"


# List of repositories to clone ###############################################################
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
    https://github.com/epinna/tplmap.git
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


# List of files to download ###################################################################
urls=(
    https://github.com/assetnote/kiterunner/releases/download/v1.0.2/kiterunner_1.0.2_linux_amd64.tar.gz
    https://wordlists-cdn.assetnote.io/data/kiterunner/routes-large.kite.tar.gz
    https://wordlists-cdn.assetnote.io/data/kiterunner/routes-small.kite.tar.gz
    https://github.com/gchq/CyberChef/releases/download/v10.4.0/CyberChef_v10.4.0.zip
    https://github.com/projectdiscovery/interactsh/releases/download/v1.1.2/interactsh-server_1.1.2_linux_amd64.zip
    https://github.com/carlospolop/PEASS-ng/releases/download/20230409/linpeas.sh
    https://github.com/carlospolop/PEASS-ng/releases/download/20230409/linpeas_linux_amd64
    https://github.com/carlospolop/PEASS-ng/releases/download/20230409/winPEAS.bat
    https://github.com/carlospolop/PEASS-ng/releases/download/20230409/winPEASany.exe
    https://github.com/carlospolop/PEASS-ng/releases/download/20230409/winPEASx64.exe
    https://github.com/carlospolop/PEASS-ng/releases/download/20230409/winPEASx86.exe
    https://raw.githubusercontent.com/carlospolop/PEASS-ng/master/metasploit/peass.rb
)

# Loop through URLs
for url in "${urls[@]}"
do
  # Extract filename from URL
  filename="${url##*/}"
  
  # Download file with curl
  echo "[i] Downloading $filename..."
  if ! curl -o "$filename" "$url"; then
    echo "[-] Error: Failed to download $filename." >&2
  fi
done


#Manual steps #################################################################################
#creating python2 virtual env
python3 -m virtualenv ~/py2
echo "${green}[+] Successfully created py2 virtualenv.${reset}"
python3 -m virtualenv --python=/usr/bin/python2 ~/py2
echo "${green}[+] Successfully set python2 for py2.${reset}"
