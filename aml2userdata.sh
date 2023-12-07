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
    # Install black for formatting

    # Install vim plug for package management
    curl -fLo $DIR/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    chown -R ec2-user:ec2-user $DIR/.vim
    # Install packages
    runuser -l ec2-user -c 'vim +PlugInstall +qall'

}

setup_tmux () {

    echo "(3/4) SETTING UP TMUX..."
    # Install tmux dependencies
    sudo yum -y update
    sudo yum -y install tmux


    # Get the latest version
    git clone https://github.com/tmux/tmux.git
    cd tmux
    sh autogen.sh
    ./configure && make install
    cd ..
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
    fc-cache -fv

    # Install trueline prompt
    wget https://raw.githubusercontent.com/petobens/trueline/master/trueline.sh -P ~/
    # Get settings from trueline-settings file and append to bashrc
    # cat $DIR/.trueline-settings >> ~/.bashrc
    echo 'source ~/trueline.sh' >> ~/.bashrc
    source ~/.bashrc

}

get_dotfiles
setup_vim
setup_tmux
setup_bash
