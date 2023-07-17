echo "rpm based post install script"
echo "author: artem@nazarow.ru, 2023"
echo "This postinstall shell script will work in rpm based distributions such as: "

echo "ROSA"
echo "Red Hat Enterprise Linux"
echo "Fedora"
echo "CentOS"
echo "Oracle Enterprise Linux"
echo "Scientific"
echo "CERN"
echo "SUSE"
echo "OpenSUSE"
echo "Mageia"



# ----------  UPGRADE  -----------

echo "TRY TO UPGRADE ? [Y/N]?"
echo "Confirm [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
    sudo dnf update  -y
    sudo dnf upgrade  -y  --refresh
    sudo dnf install  -y  dnf-plugin-system-upgrade
    sudo dnf system-upgrade  -y
    sudo dnf system-upgrade  -y  reboot
else
        echo "skipped keys update"
fi

# ---------- MIRRORS CHANGE -----------

echo "set fastest mirrors ? [Y/N]?"
echo "Confirm [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
	# Update the mirror list
    echo "fastestmirror=true" | sudo tee -a /etc/dnf/dnf.conf
    echo "deltarpm=true" | sudo tee -a /etc/dnf/dnf.conf
    sudo dnf -y update
else
        echo "skipped mirrors setup"
fi


# ---------- MAKE TOOLS  -----------

echo "INSTALL MAKE TOOLS (RECOMMENDED)? [Y/N]?"
echo "Confirm [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
	sudo dnf install -y autoconf automake gcc git llvm clang lld
else
        echo "skipped make tools install"
fi


# ---------- SYSTEM TOOLS  -----------

echo "INSTALL SYSTEM TOOLS? [Y/N]?"
echo "Confirm [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
    sudo dnf install -y gvfs ccache grub-customizer mc
else
        echo "skipped SYSTEM TOOLS install"
fi


# -------------NETWORK -------------

echo "INSTALL NETWORKING TOOLS (RECOMMENDED)? [Y/N]?"
echo "Confirm [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
		sudo dnf install wpa_supplicant  -y
        	sudo dnf install dhcp-client.x86_64 -y
		sudo systemctl mask NetworkManager-wait-online.service
else
        echo "skipped networking install"
fi

# ---------- proc frequency ----------
cd ~
echo "INSTALL PROC FREQ TOOLS (RECOMMENDED)? [Y/N]?"
echo "Confirm [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
       sudo dnf install -y alien.noarch
       wget https://github.com/vagnum08/cpupower-gui/releases/download/v1.0.0/cpupower-gui_1.0.0-1_all.deb
       sudo alien --to-rpm --scripts  cpupower-gui_1.0.0-1_all.deb
       sudo dnf install -y cpupower-gui-1.0.0-2.noarch.rpm
else
        echo "skipped PROC FREQ install"
fi
cd -


# ---------- proc frequency ----------
cd ~
echo "INSTALL AUTO FREQ TOOLS ? [Y/N]?"
echo "Confirm [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
        # Install dependencies
        sudo dnf install -y git python3 python3-pip
        # Clone the auto-cpufreq repository
        git clone https://github.com/AdnanHodzic/auto-cpufreq.git
        # Change to the auto-cpufreq directory
        cd auto-cpufreq
        # Install auto-cpufreq
        sudo python3 setup.py install
        # Start the auto-cpufreq service
        sudo systemctl start auto-cpufreq
        # Enable auto-cpufreq to start on boot
        sudo systemctl enable auto-cpufreq
		 cd -
else
        echo "skipped AUTO FREQ install"
fi
cd -

# ------------ INSTALL ZEN KERNEL ------


cd ~
echo "INSTALL ZEN KERNEL ? [Y/N]?"
echo "Confirm [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then

	sudo dnf groupinstall  -y  "Development Tools"

    # Clone the Zen Kernel repository
    git clone --depth 1 https://github.com/zen-kernel/zen-kernel.git

    # Copy the configuration file from your active kernel to the Zen Kernel directory
    cp /boot/config-$(uname -r) ~/zen-kernel/.config

    # Configure your kernel
    cd ~/zen-kernel
    make menuconfig

    # Build your kernel
    make

    # Install your kernel
    sudo make install

	echo "Zen kernel installation completed. Please reboot your system to use the new kernel."

	cd -


else
        echo "skipped ZEN KERNEL install"
fi


# ------------ INSTALL XAN MOD KERNEL FOR AMD ------


cd ~
echo "INSTALL XANMOD KERNEL ? [Y/N]?"
echo "Confirm [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then

    sudo dnf copr enable rmnscnce/kernel-xanmod  -y
    sudo dnf update  -y
    sudo dnf install  -y  kernel-xanmod
    # sudo reboot


else
        echo "skipped XANMOD install"
fi

# ------------ INSTALL TKG KERNEL FOR AMD ------


cd ~
echo "INSTALL LINUX TKG KERNEL ? [Y/N]?"
echo "Confirm [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then

    git clone https://github.com/Frogging-Family/linux-tkg.gi
    cd linux-tkg
    ./install.sh install
    cd -

else
        echo "skipped LINUX TKG install"
fi


# ------------ update grub ------


cd ~
echo "Update grub (Y if install kernel) [Y/N]?"
echo "Confirm [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then

	sudo grub2-mkconfig -o /boot/grub2/grub.cfg

else
        echo "skipped grub update"
fi


# ---------- VULKAN -----------

echo "INSTALL VULKAN? [Y/N]?"
echo "Confirm [Y,n]"
read input
    if [[ $input == "Y" || $input == "y" ]]; then

        sudo dnf makecache --refresh
        sudo dnf -y install mesa-libGLU
        sudo dnf -y install mesa-vulkan-drivers.x86_64 # Mesa Vulkan drivers
        sudo dnf -y install pipewire-plugin-vulkan.x86_64 # PipeWire media server vulkan support
        sudo dnf -y install vulkan-loader.x86_64 # Vulkan ICD desktop loader
        sudo dnf -y install vulkan-tools.x86_64 # Vulkan tools
        sudo dnf -y install vulkan-validation-layers.x86_64 # Vulkan validation layers
        sudo dnf -y install dxvk-native.x86_64 # Vulkan-based D3D11 and D3D9 implementation for Linux
        sudo dnf -y install libvkd3d.x86_64 # D3D12 to Vulkan translation library
        sudo dnf -y install mangohud.x86_64 # Vulkan overlay layer for monitoring FPS, temperatures,
        sudo dnf -y install vkBasalt.x86_64 # Vulkan post processing layer
        sudo dnf -y install vkmark.x86_64 # Vulkan benchmarking suite
        sudo dnf -y install wine-dxvk.x86_64 # Vulkan-based D3D11 and D3D10 implementation for Linux /


else
        echo "skipped vulkan installation"
fi

# --------------------------

# ---------- PORTPROTON -----------

echo "INSTALL AMD DRIVERS FOR GAMING AND PORTPROTON? [Y/N]?"
echo "Confirm [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
        echo "begin pre installation"
        sudo dnf copr enable  -y  boria138/portproton && sudo dnf install  -y  portproton

        wget -c "https://github.com/Castro-Fidel/PortWINE/raw/master/portwine_install_script/PortProton_1.0" && sh PortProton_1.0 -rus

        # if rosa linux

        sudo urpmi portproton  -y

else
        echo "skipped amd graphics and portproton installation"
fi

# --------------------------


# ---------- DBUS BROKER FOR VIDEO -----------
cd ~
echo "ENABLE DBUS BROKER ? [Y/N]?"
echo "Confirm [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then


    sudo dnf install  -y  dbus-broker
    sudo systemctl start dbus-broker.service
    sudo systemctl enable dbus-broker.service

else
        echo "skipped dbus broker install"
fi
cd -
# --------------------------



# ---------- CLEAR FONT CACHE -----------

echo "CLEAR FONT CACHE? [Y/N]?"
echo "Confirm [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
        echo "clear font cache"
        fc-cache -f ~/.fonts
        sudo rm -rf /var/cache/fontconfig/*
        sudo fc-cache -f -v

else
        echo "skipped clearing font cache"
fi

# --------------------------


# ---------- remove prev google  -----------

echo "REMOVE PREVIOUS GOOGLE CHROME INSTALLATION? [Y/N]?"
echo "Confirm [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
        echo "clear prev. google chrome installation"
       sudo rm -rf ~/.config/google-chrome
else
        echo "skipped clearing google chrome"
fi

# --------------------------




# ---------- SECURITY  -----------

echo "INSTALL SECURITY TOOLS (APPARMOR, FIREJAIL)? [Y/N]?"
echo "Confirm [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
	echo "begin install security"
	sudo dnf install -y apparmor
    sudo dnf install -y firejail

else
        echo "skipped security install"
fi

# --------------------------



# ---------- BLUETOOTH TOOLS  -----------

echo "INSTALL BLUETOOTH TOOLS? [Y/N]?"
echo "Confirm [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
        echo "begin install bluetooth"
       sudo dnf install -y bluez bluez-utils blueman
else
        echo "skipped bluetooth install"
fi

# --------------------------



# ---------- SOUND  -----------

echo "INSTALL SOUND TOOLS(PULSEAUDIO)? [Y/N]?"
echo "Confirm [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
        echo "begin install sound"
        sudo dnf install -y pulseaudio pulseaudio-bluetooth jack2 jack2-dbus pulseaudio-alsa pulseaudio-jack pavucontrol

        pulseaudio -k
		pulseaudio -D
		sudo chown $USER:$USER ~/.config/pulse
		pulseaudio -k
		pulseaudio -D
		sudo chown $USER:$USER ~/.config/pulse
else
        echo "skipped sound install"
fi

# --------------------------


# ---------- PIPEWIRE SOUND  -----------

echo "INSTALL PIPEWIRE SOUND ? [Y/N]?"
echo "Confirm [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
        echo "begin pipewire sound"
        sudo dnf install -y pipewire-audio-client-libraries libspa-0.2-bluetooth libspa-0.2-jack pipewire-alsa pipewire-jack pavucontrol

    # Disable pipewire-pulse.service and pipewire-pulse.socket
        sudo systemctl --global --now disable pipewire-pulse.service pipewire-pulse.socket

        # Copy configuration files
        sudo cp /usr/share/doc/pipewire/examples/alsa.conf.d/99-pipewire-default.conf /etc/alsa/conf.d/

	# Check if PipeWire is running
	pactl info

else
        echo "skipped pipewire sound install"
fi

# --------------------------

# ---------- ALSA SOUND  -----------

echo "INSTALL ALSA SOUND ? [Y/N]?"
echo "Confirm [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
        echo "begin ALSA sound"
	sudo dnf install -y alsa-tools alsa-base
else
        echo "skipped ALSA sound install"
fi

# --------------------------





# ---------- AUDIO PLAYER  -----------

echo "INSTALL AUDIO PLAYERS? [Y/N]?"
echo "Confirm [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
	echo "begin install audio players"
	sudo dnf update -y

    # Install Python 3.9:
    sudo dnf install python39 -y

    # Install pip:
    sudo dnf install python3-pip -y

    # Install httpx library
    pip install httpx

    # Install foobnix:
    sudo dnf install foobnix -y

    # Install clementine:
    sudo dnf install clementine -y

else
        echo "skipped audio players install"
fi

# --------------------------



# ---------- INTERNET TOOLS  -----------

echo "INSTALL INTERNET TOOLS? [Y/N]?"
echo "Confirm [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
        echo "begin install insternet tools"

        sudo dnf update  -y


        sudo dnf install  -y qbittorrent uget uget-integrator filezilla putty


else
        echo "skipped internet tools install"
fi

# --------------------------


# ---------- SCREENCAST TOOLS  -----------

echo "INSTALL SCREENCAST TOOLS? [Y/N]?"
echo "Confirm [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
        echo "begin install SCREENCAST tools"
        sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm


        sudo dnf install -y obs-studio
        sudo dnf install -y vokoscreenNG
else
        echo "skipped SCREENCAST tools install"
fi

# --------------------------




# ---------- DEVELOPER TOOLS  -----------

echo "INSTALL DEVELOPER TOOLS? [Y/N]?"
echo "Confirm [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
        echo "begin install developer tools"
        # Install default-jdk
        sudo dnf install -y java-1.8.0-openjdk-devel

        # Install netbeans
        sudo dnf install -y netbeans

        # Install wget
        sudo dnf install -y wget

        # Install oss
        sudo dnf install -y oss

        # Install code
        sudo dnf install -y code

        # Install notepadqq
        sudo dnf install -y notepadqq

        # Install kate
        sudo dnf install -y kate

        # Install lazarus ide
        sudo dnf install -y lazarus

        # Install qt5
        sudo dnf install -y qt5

        # Install qt creator
        sudo dnf install -y qt-creator

        # Install virtualbox
        sudo dnf install -y virtualbox

        # Install dkms
        sudo dnf install -y dkms



else
        echo "skipped developer tools install"
fi

# --------------------------

 # ---------- FLATPAK SYSTEM  -----------

echo "INSTALL FLATPAK? [Y/N]?"
echo "Confirm [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
            sudo dnf update  -y
            sudo dnf install -y flatpak

            flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
            flatpak update  -y
            flatpak remote-add --if-not-exists kdeapps --from https://distribute.kde.org/kdeapps.flatpakrepo
            flatpak update  -y
else
        echo "skipped flatpak install"
fi

# --------------------------




# ---------- FLATPAK SOFT  -----------

echo "INSTALL SOFT FROM FLATPAK? [Y/N]?"
echo "Confirm [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
        flatpak install  -y fsearch
		flatpak install --user org.apache.netbeans  -y
else
        echo "skipped flatpak soft install"
fi
# --------------------------


 ------------------------


# ---------- SNAP -----------

echo "INSTALL SNAPD ? [Y/N]?"
echo "Confirm [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then

        sudo dnf install  -y snapd
        sudo ln -s /var/lib/snapd/snap /snap
        sudo systemctl start snapd.socket
		sudo systemctl enable snapd.socket
		snap install  -y core
		snap install  -y snap-store


else
        echo "skipped snap install"
fi
# --------------------------


# ---------- VIDEO  -----------

echo "INSTALL VIDEO PLAYER ? [Y/N]?"
echo "Confirm [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then


    su -
    dnf install  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-stable.noarch.rpm

    dnf install  -y vlc

else
        echo "skipped video player install"
fi
# --------------------------



# ---------- PASSWORD TOOL  -----------

echo "INSTALL PASSWORD TOOL ? [Y/N]?"
echo "Confirm [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then



    sudo yum install  -y keepassx
    sudo snap install  -y keepassxc

else
        echo "skipped password tool install"
fi
# --------------------------









# ---------- WINE  -----------

echo "INSTALL WINE ? [Y/N]?"
echo "Confirm [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then


		echo "Installing wine"

		sudo dnf install  -y cabextract
        sudo dnf install  -y wine winetricks
        sudo dnf install -y wine-gecko wine-mono
        # sudo dnf reinstall mingw32-wine-gecko.noarch mingw64-wine-gecko.noarch wine-mono.noarch

		chown $USER:$USER -R /home/$USER/.wine

		export WINEARCH=win32
		export WINEDEBUG=-all
		 WINEPREFIX=/home/artem/.wine

		./wt-install-all.sh

else
        echo "skipped wine install"
fi
# --------------------------


# ---------- DE ---------


echo "INSTALL DE additional software ? [Y/N]?"
echo "Confirm [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then

		sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

        sudo dnf install  -y ffmpegthumbs

else
        echo "skipped DE addons install"
fi



# ---------- MESSENGERS -----------

echo "INSTALL MESSENGERS? [Y/N]?"
echo "Confirm [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
        echo "begin install MESSENGERS"
        # Install Telegram
        sudo dnf install telegram-desktop -y

        # Install Element Desktop
        sudo dnf install element-desktop -y

        # Install Discord
        sudo dnf install discord -y

else
        echo "skipped MESSENGERS install"
fi

# --------------------------


# OPTIMIZATIONS


# ---------- ANANICY  -----------
cd ~
echo "INSTALL ANANICY ? [Y/N]?"
echo "Confirm [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then


	echo "Installing ananicy"
	sudo dnf copr enable  -y devinus/ananicy
    sudo dnf install  -y ananicy
    sudo systemctl start ananicy
    sudo systemctl enable ananicy
	sudo systemctl enable --now ananicy

else
        echo "skipped ananicy install"
fi
cd -


# ----------- RNG ---------------



cd ~
echo "ENABLE RNG (CHOOSE N IF INSTALL ANANICY) ? [Y/N]?"
echo "Confirm [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then


		echo "Installing RNG"
		sudo dnf install  -y rng-tools
		sudo systemctl enable --now rngd



else
        echo "skipped RNG install"
fi
cd -


# ---------- HAVEGED  -----------
cd ~
echo "INSTALL HAVEGED ? [Y/N]?"
echo "Confirm [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then

	sudo dnf install  -y haveged
    sudo systemctl enable haveged
    sudo systemctl start haveged


else
        echo "skipped wine install"
fi
cd -
# --------------------------


# ---------- TRIM FOR SSD -----------
cd ~
echo "ENABLE TRIM FOR SSD ? [Y/N]?"
echo "Confirm [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then

	sudo dnf install  -y util-linux
    sudo systemctl enable fstrim.timer
    sudo systemctl list-timers

	sudo systemctl enable fstrim.timer
	sudo fstrim -v /
	sudo fstrim -va  /

else
        echo "skipped trim switching"
fi
cd -
# -----------------------
