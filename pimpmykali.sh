#!/bin/bash
# hum4ng0d version of kali

echo "pimpmykali v0.1"
echo "Start of a new adventure..."

user="kali"
sudo chown -R $user:$user /opt

rm -rf ~/Public ~/Videos ~/Pictures ~/Music ~/Documents ~/Templates
mkdir ~/www
mkdir /opt/pimpmykali

sections=$(awk '/----/{print NR}' list.txt)
sections+=($(wc -l < list.txt))

apt_packages=$(sed -n "${sections[0]},$((sections[1]-1))p" list.txt)
while read package; do
    echo "[i] Installing $package..."
    sudo apt-get -y install $package
    sudo apt update
    echo "[+] Successfully installed $package."
done <<< "$apt_packages"

go_packages=$(sed -n "${sections[1]},$((sections[2]-1))p" list.txt)
while read package; do
    echo "[i] Installing $package..."
    go install $package
    echo "[+] Successfully installed $package."
done <<< "$go_packages"

installer_urls=$(sed -n "${sections[2]},$((sections[3]-1))p" list.txt)
for installer in $installer_urls; do
    echo "[i] Downloading $installer..."
    wget -q -P /tmp $installer
    installer_name=$(echo $installer | awk -F/ '{print $NF}')
    echo "[i] Installing $installer_name..."
    sudo dpkg -i /tmp/$installer_name
    echo "[+] Successfully installed $installer_name."
    echo "[+] Removing $installer_name..."
    sudo rm /tmp/$installer_name
    echo "[+] Successfully removed $installer_name."
done

github_repos=$(sed -n "${sections[3]},$((sections[4]-1))p" list.txt)
for repo in $github_repos; do
    repo_name=$(echo $repo | awk -F/ '{print $NF}' | sed 's/.git//')
    echo "[i] Installing $repo_name..."
    git clone $repo /opt/$repo_name
    if [ -f /opt/$repo_name/requirements.txt ]; then
        echo "[i] Installing requirements for $repo_name..."
        pip install -r /opt/$repo_name/requirements.txt
        echo "[+] Successfully installed requirements for $repo_name."
    fi
    echo "[+] Successfully installed $repo_name."
done

python_modules=$(sed -n "${sections[4]},$((sections[5]-1))p" list.txt)
for module in $python_modules; do
    echo "[i] Installing $module..."
    pip install $module
    echo "[+] Successfully installed $module."
done

file_urls=$(sed -n "${sections[5]}p" list.txt)
for file_url in $file_urls; do
    echo "[+] Downloading $file_url..."

#Manual steps
#creating python2 virtual env
python3 -m virtualenv ~/py2
python3 -m virtualenv --python=/usr/bin/python2 ~/py2

#Cloning tplmap
source ~/py2/bin/activate
git clone https://github.com/epinna/tplmap.git /opt
echo "[+] Successfully cloned tplmap"
python -m pip install -r /opt/tplmap/requirements.txt
deactivate

#Setting workspaces
gsettings set org.gnome.desktop.wm.preferences num-workspaces 9

#Setting wallpaper
wget -p /opt/pimpmykali https://github.com/hum4nG0D/pimpmykali/raw/main/images/kali-new-16x9.png 
gsettings set org.gnome.desktop.background picture-uri file:///opt/pimpmykali/kali-new-16x9.png




