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

    # Restart shell
    exec bash

}

setup_kubernetes() {

        echo "(5/5) SETTING UP KUBERNETES..."
        # Install AWS CLI
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
        # install unzip
        sudo apt install unzip

        unzip /tmp/awscliv2.zip
        sudo ./aws/install

}


get_dotfiles
setup_vim
setup_kubernetes
setup_tmux
setup_bash
