#!/bin/bash
# Setting up an Amazon Linux 2 Instance with the Ubuntu AMI
set -e -x

get_dotfiles () {

    echo "(1/4): GETTING DOTFILES..."
    #Install git
    sudo apt update

    sudo sudo apt install git
    local DIR=/home/ubuntu
    git clone https://github.com/DorianCBrwn/ec2-bash-vim-tmux $DIR/dotfiles
    ln -s $DIR/dotfiles/.tmux.conf $DIR/.tmux.conf
    ln -s $DIR/dotfiles/.vimrc $DIR/.vimrc
    chown -R ubuntu:ubuntu $DIR/dotfiles $DIR/.vimrc $DIR/.tmux.conf

}

setup_vim () {

    echo "(2/4) SETTING UP VIM..."
    local DIR=/home/ubuntu

}

setup_tmux () {

    echo "(3/4) SETTING UP TMUX..."
    # Install tmux dependencies
    sudo apt install tmux
    # Get a simple startup script
    mv /home/ubuntu/dotfiles/stm.sh /bin/stm
    chmod +x /bin/stm

    # Install htop
    sudo apt install htop
}

setup_bash () {

    echo "(4/4) SETTING UP Bash Environment..."
    local DIR=/home/ubuntu
    # Install nerd fonts
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/CascadiaCode.zip
    # install unzip
    sudo apt install unzip
    # Check if fonts directory exists install to local if not
    if [ ! -d "$DIR/.local/share/fonts" ]; then
        unzip CascadiaCode.zip -d ~/.fonts
        else
        unzip CascadiaCode.zip -d ~/.local/share/fonts
    fi
    sudo apt install -y fontconfig

    fc-cache -fv

    # # Install trueline prompt
    # wget https://raw.githubusercontent.com/petobens/trueline/master/trueline.sh -P ~/
    # # Get settings from trueline-settings file and append to bashrc
    # # cat $DIR/.trueline-settings >> ~/.bashrc
    # echo 'source ~/trueline.sh' >> ~/.bashrc
    # source ~/.bashrc

    # Install Oh My Bash
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" --prefix=/usr/local --unattended

    # Install for current user
    cp /usr/local/share/oh-my-bash/bashrc ~/.bashrc

    # Install for root
    sudo cp /usr/local/share/oh-my-bash/bashrc /root/.bashrc

    # Install terraform autocomplete
    terraform -install-autocomplete

    # Restart shell
    exec bash

}

setup_terraform () {
    # Ensure gnupg, software-properties-common, and curl packages  are installed
    sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
   # Add the HashiCorp GPG key.
    wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
    # Verify the key's fingerprint
    gpg --no-default-keyring \
    --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    --fingerprint
    # Add the official HashiCorp Linux repository.
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list
    # Update package information
    sudo apt update
    # Install Terraform
    sudo apt-get install terraform

}


get_dotfiles
setup_vim
setup_terraform
setup_tmux
setup_bash
