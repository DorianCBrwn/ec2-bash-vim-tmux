#!/bin/bash
# Setting up an Amazon Linux 2 Instance with the Ubuntu AMI
set -e -x

get_dotfiles () {

    echo "(1/4): GETTING DOTFILES..."
    #Install git
    sudo yum -y install git
    local DIR=/home/ec2-user
    git clone https://github.com/DorianCBrwn/ec2-bash-vim-tmux $DIR/dotfiles
    ln -s $DIR/dotfiles/.tmux.conf $DIR/.tmux.conf
    ln -s $DIR/dotfiles/.vimrc $DIR/.vimrc
    ln -s $DIR/dotfiles/.trueline-settings $DIR/.trueline-settings
    chown -R ec2-user:ec2-user $DIR/dotfiles $DIR/.vimrc $DIR/.tmux.conf

}

setup_vim () {

    echo "(2/4) SETTING UP VIM..."
    local DIR=/home/ec2-user

}

setup_tmux () {

    echo "(3/4) SETTING UP TMUX..."
    # Install tmux dependencies
    sudo yum -y install tmux
    # Get a simple startup script
    mv /home/ec2-user/dotfiles/stm.sh /bin/stm
    chmod +x /bin/stm

    # Install htop
    sudo yum -y install htop
}

setup_bash () {

    echo "(4/4) SETTING UP Bash Environment..."
    local DIR=/home/ec2-user
    # Install nerd fonts
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/CascadiaCode.zip
    # Check if fonts directory exists install to local if not
    if [ ! -d "$DIR/.local/share/fonts" ]; then
        unzip CascadiaCode.zip -d ~/.fonts
        else
        unzip CascadiaCode.zip -d ~/.local/share/fonts
    fi
    sudo yum -y install fontconfig

    fc-cache -fv

    # # Install trueline prompt
    # wget https://raw.githubusercontent.com/petobens/trueline/master/trueline.sh -P ~/
    # # Get settings from trueline-settings file and append to bashrc
    # # cat $DIR/.trueline-settings >> ~/.bashrc
    # echo 'source ~/trueline.sh' >> ~/.bashrc
    # source ~/.bashrc

    # Install Oh My Bash
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" --prefix=/usr/local --unattended

    # Change theme to powerline-multiline
    cp /usr/local/share/oh-my-bash/bashrc home/ec2-user/.bashrc
    sed -i 's/OSH_THEME=.*/OSH_THEME="powerline-multiline"/g' /home/ec2-user/.bashrc

}

get_dotfiles
setup_vim
setup_tmux
setup_bash
