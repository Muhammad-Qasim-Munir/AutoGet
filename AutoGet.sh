#!/bin/bash
trap 'read -p "Abort or Continue? (A/C)" choice; [ "$choice" == "A" ] && exit' INT

echo -e "\e[93mThis installation may take a while, it's a good time to grab a cup of coffee or tea, put on some music, or maybe even do a little dance.\e[0m"
echo -e "\e[93mStarting the script...\e[0m"
sleep 3


# Make sure script is running as root
if [[ $EUID -ne 0 ]]; then
   echo -e "\e[91mThis script must be run as root\e[0m" 
   exit 1
fi

# Create tools directory if it doesn't exist
if [ ! -d "/$user/tools" ]; then
  mkdir "/$user/tools"
fi

# Change to tools directory
cd "/$user/tools"

echo -e "\e[93m[+] Installing Required Languages\e[0m"

# Check for Python and install if not present
if command -v python3 &>/dev/null; then
    echo -e "\e[92mPython3 is already installed\e[0m"
else
    echo -e "\e[93m[+] Installing Python3\e[0m"
    apt-get install python3 -y
fi

# Check for Ruby and install if not present
if command -v ruby &>/dev/null; then
    echo -e "\e[92mRuby is already installed\e[0m"
else
    echo -e "\e[93m[+] Installing Ruby\e[0m"
    apt-get install ruby -y
fi

# Check for Go and install if not present
if command -v go &>/dev/null; then
    echo -e "\e[92mGo is already installed\e[0m"
else
    echo -e "\e[93m[+] Installing Go\e[0m"
    apt-get install golang -y
fi

echo -e "\e[93m[+] Downloading and Installing Tools\e[0m"

# Download and install knockpy
echo -e "\e[93m[+] Downloading knockpy\e[0m"
git clone https://github.com/guelfoweb/knock.git
cd knock
python3 setup.py install
cd ..

# Download and install dirsearch
echo -e "\e[93m[+] Downloading dirsearch\e[0m"
git clone https://github.com/maurosoria/dirsearch.git

# Download and install sublist3r
echo -e "\e[93m[+] Downloading sublist3r\e[0m"
git clone https://github.com/aboul3la/Sublist3r.git
cd Sublist3r
pip3 install -r requirements.txt
python3 setup.py install
cd ..

# Download and install Seclists
echo -e "\e[93m[+] Downloading Seclists\e[0m"
git clone https://github.com/danielmiessler/SecLists.git

# Download and install sqlmap
echo -e "\e[93m[+] Downloading sqlmap\e[0m"
git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git sqlmap-dev

# Download and install wpscan
echo -e "\e[93m[+] Downloading wpscan\e[0m"
git clone https://github.com/wpscanteam/wpscan.git
cd wpscan
gem install bundler && bundle install --without test development
cd ..

# Download and install nmap
echo -e "\e[93m[+] Downloading nmap\e[0m"
apt-get install nmap -y

# Download and install metasploit
echo -e "\e[93m[+] Downloading metasploit\e[0m"
curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall &&
chmod 755 msfinstall &&
./msfinstall

# Download and install nuclei
echo -e "\e[93m[+] Downloading nuclei\e[0m"
go get -u -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei

# Download and install httpx
echo -e "\e[93m[+] Downloading httpx\e[0m"
go get -u -v github.com/projectdiscovery/httpx/cmd/httpx


# Download and install hakcheckurl
echo -e "\e[93m[+] Downloading hakcheckurl\e[0m"
git clone https://github.com/hakluke/hakcheckurl.git

# Download and install hakrawler
echo -e "\e[93m[+] Downloading hakrawler\e[0m"
go get github.com/hakluke/hakrawler

# Download and install waybackurls
echo -e "\e[93m[+] Downloading waybackurls\e[0m"
go get github.com/tomnomnom/waybackurls

# Download and install mobsf
echo -e "\e[93m[+] Downloading mobsf\e[0m"
git clone https://github.com/MobSF/Mobile-Security-Framework-MobSF.git

# Download and install amass
echo -e "\e[93m[+] Downloading amass\e[0m"
snap install amass

# Download and install dnsscan
echo -e "\e[93m[+] Downloading dnsscan\e[0m"
go get github.com/subfinder/dnsscan

echo -e "\e[93m[+] Verifying Installation\e[0m"
failed_tools=()
# Verify installation of knockpy
if command -v knockpy &>/dev/null; then
    echo -e "\e[92mknockpy is successfully installed\e[0m"
else
    echo -e "\e[91mknockpy installation failed\e[0m"
    failed_tools+=("knockpy")
fi

# Verify installation of dirsearch
if [ -d "dirsearch" ]; then
    echo -e "\e[92mdirsearch is successfully installed\e[0m"
else
    echo -e "\e[91mdirsearch installation failed\e[0m"
    failed_tools+=("dirsearch")
fi

# Verify installation of sublist3r
if command -v sublist3r &>/dev/null; then
    echo -e "\e[92msublist3r is successfully installed\e[0m"
else
    echo -e "\e[91msublist3r installation failed\e[0m"
    failed_tools+=("sublist3r")
fi

# Verify installation of Seclists
if [ -d "SecLists" ]; then
    echo -e "\e[92mSeclists is successfully installed\e[0m"
else
    echo -e "\e[91mSeclists installation failed\e[0m"
    failed_tools+=("Seclists")
fi

# Verify installation of sqlmap
if command -v sqlmap &>/dev/null; then
    echo -e "\e[92msqlmap is successfully installed\e[0m"
else
    echo -e "\e[91msqlmap installation failed\e[0m"
    failed_tools+=("sqlmap")
fi

# Verify installation of wpscan
if command -v wpscan &>/dev/null; then
    echo -e "\e[92mwpscan is successfully installed\e[0m"
else
    echo -e "\e[91mwpscan installation failed\e[0m"
    failed_tools+=("wpscan")
fi

# Verify installation of nmap
if command -v nmap &>/dev/null; then
    echo -e "\e[92mnmap is successfully installed\e[0m"
else
    echo -e "\e[91mnmap installation failed\e[0m"
    failed_tools+=("nmap")
fi

# Verify installation of Metasploit
if command -v msfconsole &>/dev/null; then
    echo -e "\e[92mMetasploit is successfully installed\e[0m"
else
    echo -e "\e[91mMetasploit installation failed\e[0m"
    failed_tools+=("Metasploit")
fi

# Verify installation of nuclei
if command -v nuclei &>/dev/null; then
    echo -e "\e[92mnuclei is successfully installed\e[0m"
else
    echo -e "\e[91mnuclei installation failed\e[0m"
    failed_tools+=("nuclei")
fi

# Verify installation of httpx
if command -v httpx &>/dev/null; then
    echo -e "\e[92mhttpx is successfully installed\e[0m"
else
    echo -e "\e[91mhttpx installation failed\e[0m"
    failed_tools+=("httpx")
fi

# Verify installation of hakcheckurl
if command -v hakcheckurl &>/dev/null; then
    echo -e "\e[92mhakcheckurl is successfully installed\e[0m"
else
    echo -e "\e[91mhakcheckurl installation failed\e[0m"
    failed_tools+=("hakcheckurl")
fi

# Verify installation of hakrawler
if command -v hakrawler &>/dev/null; then
    echo -e "\e[92mhakrawler is successfully installed\e[0m"
else
    echo -e "\e[91mhakrawler installation failed\e[0m"
    failed_tools+=("hakrawler")
fi

# Verify installation of waybackurl
if command -v waybackurls &>/dev/null; then
    echo -e "\e[92mwaybackurls is successfully installed\e[0m"
else
    echo -e "\e[91mwaybackurls installation failed\e[0m"
    failed_tools+=("waybackurls")
fi

# Verify installation of golang
if command -v go &>/dev/null; then
    echo -e "\e[92mgolang is successfully installed\e[0m"
else
    echo -e "\e[91mgolang installation failed\e[0m"
    failed_tools+=("golang")
fi

# Verify installation of MobSF
if command -v python3 &>/dev/null; then
    echo -e "\e[92mMobSF is successfully installed\e[0m"
else
    echo -e "\e[91mMobSF installation failed\e[0m"
    failed_tools+=("MobSF")
fi

# Verify installation of amass
if command -v amass &>/dev/null; then
    echo -e "\e[92mamass is successfully installed\e[0m"
else
    echo -e "\e[91mamass installation failed\e[0m"
    failed_tools+=("amass")
fi

# Verify installation of dnsscan
if command -v dnsscan &>/dev/null; then
    echo -e "\e[92mdnsscan is successfully installed\e[0m"
else
    echo -e "\e[91mdnsscan installation failed\e[0m"
    failed_tools+=("dnsscan")
fi

# Check if any tools installation failed
if [ ${#failed_tools[@]} -ne 0 ]; then
    echo -e "\e[91mTry installing these tools manually:\e[0m"
    for tool in "${failed_tools[@]}"; do
        echo $tool
    done
else
    echo -e "\e[92mAll tools are successfully installed\e[0m"
fi
