#! /bin/bash
#
#
### First Up Is All The Functions That Will Be Used.
#
# This is the install control function.
function installController() {
    getSystemInfo
    wait
    getUserInfo
    wait
    giveUserPermissions
    wait
    getDependencies
    wait
    getDocker
    wait
    cloneFork
    wait
    initSetup
    wait
    buildDocker
    wait
    showFinishMessage
}
#
## Here we will gather what system info we can as to install the correct stuff.
function getSystemInfo() {
    #Name the current operating system.
    osName=$(uname)
    #What bit is the system?
    osBit=$(getconf LONG_BIT)
    echo "  "
    echo "We are running on a "$osName" system that is "$osBit"bits from what we can tell."
    sleep 10s
}
#
# Here We Get The Needed User Info To Complete The Install.
function getUserInfo() {
    echo " Does this device have an xArm processor?"
    read -p '(y/n): ' arm
    if [ "$arm" = "y" ]
    then
        armP="y"
        echo " We will use the xArm docker build file then."
	sleep 5s
    else
        armP="n"
        echo "We will use the usual docker build file then."
    fi
    echo " What is your github user name?"
    read -p '(UserName): ' username
    echo " Welcome "$username" "
    sleep 2s
    echo " What is the URL of your Superalgos Fork?"
    read -p '(ForkURL): ' fork
    sleep 2s
    echo " What github token would you like to use?"
    read -p '(Token): ' token
    sleep 2s
    echo " The Install Script Is About To Begin."
    sleep 3s
    clear
}
#
# Here We Give The User The Needed Permissions.
function giveUserPermissions() {
    user='whoami'
    echo "$user"
    echo " Please Input Your User Password To Allow For sudo Commands"
    givesudo='sudo usermod -aG sudo "$user" '
    eval $givesudo
    wait
    echo " This user has been added to the sudo group"
    sleep 5s
    giveDocker='sudo usermod -aG docker "$user" '
    eval $giveDocker
    wait
    echo " This user has been added to the docker group"
    sleep 5s
}
#
# Here We Install The Main Dependencies.
function getDependencies() {
    echo "## First lets update........................................"
    update='sudo apt update'
    eval $update
    wait
    echo "## Getting curl............................................."
    curl='sudo apt install -y curl'
    eval $curl
    wait
    echo "## Getting Node From NodeSource............................."
    nodeSource='curl -sL https://deb.nodesource.com/setup_17.x | sudo -E bash -'
    eval $nodeSource
    wait
    eval $update
    wait
    node='sudo apt install -y nodejs'
    eval $node
    wait
    sleep 20s
}
#
## If the user wants docker, the user gets docker.
function getDocker() {
if [ "$docker" = "y" ]
then
    echo "## Getting ready to get docker from docker.com............."
    locationD='curl -fsSL https://get.docker.com -o get-docker.sh'
    eval $locationD
    wait
    echo "## Getting docker.........................................."
    getDocker='sudo sh get-docker.sh'
    eval $getDocker
    wait
fi
}
#
# Here We Will Clone Superalgos To The Home Directory.
function cloneFork() {
    echo "## Preparing to clone your fork............................"
    echo "# First we move to the home directory......................"
    movehome='cd ~'
    eval $movehome
    wait
    echo "## Cloning Fork............................................"
    clone='git clone "$fork"'
    eval $clone
    wait
    echo "## Fork Cloned"
    sleep 5s
}
#
## Here We Setup Superalgos By Utilizing The Existing Install Scripts.
function initSetup() {
    echo "## Preparing to setup Superalgos..........................."
    homeS='cd ~/Superalgos'
    eval $homeS
    wait
    echo "## Switching to Develop Branch............................."
    devBranch='git checkout develop'
    eval $devBranch
    wait
    echo "Running node setup script.................................."
    setup='node setup'
    eval $setup
    wait
    echo "## Running node setupPlugins script........................"
    plugins='node setupPlugins "$username" "$token"'
    eval $plugins
    wait
    echo "## Running updateGithubRepos"
    github='node updateGithubRepos'
    eval $github
    wait
    sleep 5s
}
#
## Here we run the docker build command
function buildDocker() {
    btcFactory='cd Bitcoin-Factory'
    eval $btcFactory
    wait
    if [ $armP = "y" ]
    then
        armDocker='cd ArmDockerBuild'
        eval $armDocker
        wait
        buildDockerImageArm='docker build -t bitcoin-factory-machine-learning .'
        eval $buildDockerImageArm
        wait
        moveBack='cd ..'
        eval $moveBack
        wait
    else
        dockerBuild='cd DockerBuild'
        eval $dockerBuild
        wait
        buildDockerImage='docker build -t bitcoin-factory-machine-learning .'
        eval $buildDockerImage
        wait
        cd ..
        wait
    fi
}
#
## Show a Finish Message
function showFinishMessage() {
    echo "############################################################"
    echo "# This Script has Finished Executing!                      #"
    echo "# Everything should be all setup for you!                  #"
    echo "# To run Superalgos just use the node platform command!    #"
    echo "############################################################"
    sleep 15s
} 
#
# Lets Clear the Terminal So Everything Starts Neat And Tidy.
clear
#
# Welcome Message
echo "----------------------------------------"
echo "|  Welcome To The Superalgos Install   |"
echo "----------------------------------------"
echo " "
echo " "
sleep 2s
echo "This Script is Intened To Be Used To Install Superalgos on Ubuntu and *Should* Work On Any Debain Based Distro"
echo "This is A Convience Installation Method"
echo "After A Few Questions This Script Will:"
echo " "
echo " .........Clone Your Superalgos Fork To This Machine"
echo " .........Setup Superalgos Plugins"
echo " .........Optional Docker Install Option For Bitcoin-Factory"
echo " "
echo " "
echo " "
sleep 12s
clear
# Here We Will Find Out What All The User Would Like Us To Do.
echo " Would You Like Us To Install Superalgos?"
echo " ***Note: Superalgos will be installed inside the home directory.***"
read -p '(y/n): ' choice
if [ "$choice" = "y" ]
then
    install="y"
    echo " OK"
    sleep 1s
    echo " Would you like us to install docker?"
    read -p '(y/n): ' choice
    if [ "$choice" = "y" ]
    then 
        docker="y"
        echo " OK, We will also install docker!"
    else
	docker="n"
	echo " OK, We will not install docker then!"
    fi
    sleep 2s

    echo " We Will Need To Ask You A Few More Questions To Continue"
    sleep 3s
    installController
else
    install="n"
    echo " OK"
    sleep 2s
    clear
    echo " This script is only intended to install Superalgos."
    echo " We are not sure what you would like us to do."
    sleep 1s
    echo " Please manually install Superalgos for custom install options."
    echo "  "
    echo "  "
fi


