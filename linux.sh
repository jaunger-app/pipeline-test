#!/bin/bash


exec=$(pwd)/linux/build/librepods
icon=$(pwd)/linux/assets/librepods.png


create_desktop_entry(){
    echo "
    [Desktop Entry]
    Name=Librepods
    Comment=Startet Librepods Bash Script
    Exec=$exec
    Icon=$icon
    Terminal=false
    Type=Application
    Categories=Utility;" > ~/.local/share/applications/librepods.desktop

    if [ $? -eq 0 ]; then
        chmod +x ~/.local/share/applications/librepods.desktop
    else
        echo "Failed to create desktop entry."
    fi
}


# Detect Distro and Install Dependencies

if [ -f /etc/os-release ]; then
    . /etc/os-release

    case "$ID" in
        debian|ubuntu|linuxmint)
            sudo apt-get update && apt upgrade -y
            sudo apt-get install qt6-base-dev qt6-declarative-dev qt6-connectivity-dev qt6-multimedia-dev \
            qml6-module-qtquick-controls qml6-module-qtqml-workerscript qml6-module-qtquick-templates \
            qml6-module-qtquick-window qml6-module-qtquick-layouts libssl-dev libpulse-dev cmake
            ;;
        arch|manjaro|endeavouros)
            sudo pacman -S qt6-base qt6-connectivity qt6-multimedia-ffmpeg qt6-multimedia openssl libpulse cmake
            ;;
        fedora|rhel|centos)
            sudo dnf install qt6-qtbase-devel qt6-qtconnectivity-devel qt6-qtmultimedia-devel qt6-qtdeclarative-devel \
            openssl-devel pulseaudio-libs-devel cmake
            ;;
        *)
            exit 1
            ;;
    esac
else
    echo "/etc/os-release not found — cannot determine distro."
fi



# Create Build Folder and enter it
mkdir -p linux/build && cd linux/build

# Configure the project with CMake
cmake ..

# Build the Project 
make -j $(nproc)
