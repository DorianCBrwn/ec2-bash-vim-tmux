#!/bin/bash
# Setting up an Amazon Linux 2 Instance with the Ubuntu AMI
set -e -x

get_dotfiles() {

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

setup_vim() {

  echo "(2/4) SETTING UP VIM..."
  local DIR=/home/ec2-user
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

}

setup_tmux() {

  echo "(3/4) SETTING UP TMUX..."
  # Install tmux dependencies
  sudo yum -y install tmux
  # Get a simple startup script
  mv /home/ec2-user/dotfiles/stm.sh /bin/stm
  chmod +x /bin/stm

  # Install htop
  sudo yum -y install htop
}

setup_bash() {

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
  cp /usr/local/share/oh-my-bash/bashrc /home/ec2-user/.bashrc
  sed -i 's/OSH_THEME=.*/OSH_THEME="pure"/g' /home/ec2-user/.bashrc

}

setup_devops_tools() {
  # Install AWS CLI
  sudo yum -y install aws-cli
  # Install kubectl
  curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.30.0/2024-05-12/bin/linux/amd64/kubectl
  sudo chmod +x ./kubectl
  mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH
  echo 'export PATH=$HOME/bin:$PATH' >>~/.bashrc

  # Install eksctl
  # for ARM systems, set ARCH to: `arm64`, `armv6` or `armv7`
  ARCH=amd64
  PLATFORM=$(uname -s)_$ARCH

  curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
  tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
  sudo mv /tmp/eksctl /usr/local/bin
  # Add Completion for eksctl
  . <(eksctl completion bash)

  # Install Docker
  sudo yum -y install docker
}

get_dotfiles
setup_vim
setup_tmux
setup_bash
setup_devops_tools
