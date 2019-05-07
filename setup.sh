#!/usr/bin/env bash

setup_ubuntu () {

echo "Seting up Ubuntu"
if ! type "debmake" > /dev/null; then
    sudo apt-get install -y debmake
fi

if ! type "pbuilder" > /dev/null; then
    sudo apt-get install -y pbuilder
fi

if ! type "dpkg-scanpackages" > /dev/null; then
    sudo apt-get install -y dpkg-dev
fi

if [ ! -f /var/cache/pbuilder/base.tgz ] ; then
    sudo pbuilder create
fi

if [ ! -d "/usr/lib/grub/i386-pc" ]; then
    sudo apt-get install -y grub-pc
fi

sudo mkdir -p /usr/local/mydebs/
sudo mkdir -p /var/cache/pbuilder/hook.d/

cp configs/pbuilderrc ~/.pbuilderrc
sudo cp configs/D70results /var/cache/pbuilder/hook.d/

if [ ! -d "autodeb" ] ; then
    git clone --depth=1 https://github.com/VictorRodriguez/autodeb.git
else
    echo "Updating autodeb"
    cd autodeb/ && git pull
    cd ..
fi

if [ ! -d "live_img" ]; then
    git clone --depth=1 https://github.com/marcelarosalesj/live_img.git
else
    echo "Updating live_img"
    cd live_img/ && git pull
    cd ..
fi

if [ ! -d "linuxbuilder" ] ; then
    git clone --depth=1 https://github.com/VictorRodriguez/linuxbuilder.git
else
    echo "Updating linuxbuilder"
    cd linuxbuilder/ && git pull
    cd ..
fi

}

setup_centos(){
    echo "Seting up centos"

    if ! type "mock" > /dev/null; then
    yum -y --setopt="tsflags=nodocs" update
    yum -y --setopt="tsflags=nodocs" install epel-release mock rpm-sign expect rpm-build
    yum clean all
    rm -rf /var/cache/yum/
    chmod g+w /etc/mock/*.cfg
    fi
    sudo usermod -aG mock $USER
}

if [ -f /etc/centos-release ]; then
    setup_centos
else
    setup_ubuntu
fi

# clone source code repos on specific branches
filename='repos'
while IFS=, read GIT_REPO BRANCH; do
	DIR=$(basename $GIT_REPO .git)
	if [ ! -z $DIR ];then
		if [ ! -d "$DIR" ] ; then
			git clone -b $BRANCH --depth=1 $GIT_REPO
		fi
	fi
done < $filename
echo "Set up complete"
