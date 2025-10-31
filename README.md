# OracleVmDeploy


sudo apt update
sudo apt install xrdp xfce4 xfce4-goodies -y
echo xfce4-session > ~/.xsession
sudo systemctl enable xrdp
sudo systemctl restart xrdp