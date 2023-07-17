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
        sudo dnf install -y bluez.x86_64 # Bluetooth utilities
        sudo dnf install -y kf5-bluez-qt.x86_64 # A Qt wrapper for Bluez
        sudo dnf install -y kf5-bluez-qt-devel.x86_64 # Development files for kf5-bluez-qt
        sudo dnf install -y python3-bluez.x86_64
        sudo dnf install -y bluez-cups.x86_64 # CUPS printer backend for Bluetooth printers
        sudo dnf install -y bluez-mesh.x86_64 # Bluetooth mesh
        sudo dnf install -y bluez-obexd.x86_64 # Object Exchange daemon for sharing content
        sudo dnf install -y bluez-tools.x86_64 # A set of tools to manage Bluetooth devices for Linux

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
        sudo dnf install -y pulseaudio-module-jack.x86_64 # JACK support for the PulseAudio sound server
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

        sudo dnf install -y jack-audio-connection-kit.x86_64 # The Jack Audio Connection Kit
        sudo dnf install -y jack-audio-connection-kit-dbus.x86_64 # Jack D-Bus launcher
        sudo dnf install -y jack-mixer.x86_64 # JACK Audio Mixer
        sudo dnf install -y jack_capture.x86_64 # Record sound files with JACK
        sudo dnf install -y pg123-plugins-jack.x86_64 # JACK output plug-in for mpg123
        sudo dnf install -y pipewire-jack-audio-connection-kit.x86_64 # PipeWire JACK implementation
        sudo dnf install -y pipewire-jack-audio-connection-kit-libs.x86_64 # PipeWire JACK implementation libraries
        sudo dnf install -y pipewire-plugin-jack.x86_64 # PipeWire media server JACK support
        sudo dnf install -y pki-resteasy-jackson2-provider.noarch # Module jackson2-provider for resteasy
        sudo dnf install -y projectM-jack.x86_64 # The projectM visualization plugin for jack



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
        sudo dnf install -y alsa-plugins-jack.x86_64 # Jack PCM output plugin for ALSA
        sudo dnf install -y alsa-firmware.noarch # Firmware for several ALSA-supported sound cards
        sudo dnf install -y alsa-lib.x86_64 # The Advanced Linux Sound Architecture (ALSA) library
        sudo dnf install -y alsa-lib-devel.x86_64 # Development files from the ALSA library
        sudo dnf install -y alsa-plugins-a52.x86_64 # A52 output plugin for ALSA using libavcodec
        sudo dnf install -y alsa-plugins-arcamav.x86_64 # Arcam AV amplifier plugin for ALSA
        sudo dnf install -y alsa-plugins-avtp.x86_64 # Audio Video Transport Protocol (AVTP) plugin for ALSA
        sudo dnf install -y alsa-plugins-jack.x86_64 # Jack PCM output plugin for ALSA
        sudo dnf install -y alsa-plugins-lavrate.x86_64 # Rate converter plugin for ALSA using libavcodec
        sudo dnf install -y alsa-plugins-maemo.x86_64 # Maemo plugin for ALSA
        sudo dnf install -y alsa-plugins-oss.x86_64 # Oss PCM output plugin for ALSA
        sudo dnf install -y alsa-plugins-pulseaudio.x86_64 # Alsa to PulseAudio backend
        sudo dnf install -y alsa-plugins-samplerate.x86_64 # External rate converter plugin for ALSA
        sudo dnf install -y alsa-plugins-upmix.x86_64 # Upmixer channel expander plugin for ALSA
        sudo dnf install -y alsa-plugins-usbstream.x86_64 # USB stream plugin for ALSA
        sudo dnf install -y alsa-plugins-vdownmix.x86_64 # Downmixer to stereo plugin for ALSA
        sudo dnf install -y alsa-tools.x86_64 # Specialist tools for ALSA
        sudo dnf install -y alsa-tools-firmware.x86_64 # ALSA tools for uploading firmware to some soundcards
        sudo dnf install -y alsa-topology.noarch # ALSA Topology configuration
        sudo dnf install -y alsa-topology-utils.x86_64 # Advanced Linux Sound Architecture (ALSA) - Topology
        sudo dnf install -y alsa-ucm.noarch # ALSA Use Case Manager configuration
        sudo dnf install -y alsa-ucm-utils.x86_64 # Advanced Linux Sound Architecture (ALSA) - Use Case Manager
        sudo dnf install -y alsa-utils.x86_64 # Advanced Linux Sound Architecture (ALSA) utilities
        sudo dnf install -y alsa-utils-alsabat.x86_64 # Advanced Linux Sound Architecture (ALSA) - Basic Audio Tester
        sudo dnf install -y alsamixergui.x86_64 # GUI mixer for ALSA sound devices
        sudo dnf install -y pipewire-alsa.x86_64 # PipeWire media server ALSA support
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


        sudo dnf install  -y qbittorrent uget filezilla putty


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
        flatpak install org.apache.netbeans
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
		snap install  core
		snap install  snap-store


else
        echo "skipped snap install"
fi
# --------------------------


# ---------- VIDEO  -----------

echo "INSTALL VIDEO PLAYER ? [Y/N]?"
echo "Confirm [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then



        sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
        sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
        sudo dnf install -y vlc
        sudo dnf install -y python-vlc # (optional)

else
        echo "skipped video player install"
fi
# --------------------------



# ---------- PASSWORD TOOL  -----------

echo "INSTALL PASSWORD TOOL ? [Y/N]?"
echo "Confirm [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then

    sudo snap install keepassxc

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
