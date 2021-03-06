#! /bin/sh
#set -x

# update /etc/apt/sources.list
sudo sed -i -e 's%http://.*.ubuntu.com%http://ftp.jaist.ac.jp/pub/Linux%g' /etc/apt/sources.list

# update OS
sudo apt update -y
sudo apt upgrade -y

# install gcc & ruby
sudo apt install build-essential -y
sudo apt install ruby -y

# install athrill
if [ ! -d athrill ]; then
git clone https://github.com/tmori/athrill.git
git clone https://github.com/tmori/athrill-target.git
(cd athrill-target/v850e2m/build_linux; make timer32=true clean; make timer32=true)
PATH=${HOME}/athrill/bin/linux:"${PATH}"
fi

# install 64bit gcc
if [ ! -f athrill-gcc-package.tar.gz ];then
wget https://github.com/toppers/athrill-gcc-v850e2m/releases/download/v1.1/athrill-gcc-package.tar.gz
tar xzf athrill-gcc-package.tar.gz
(cd athrill-gcc-package; tar xzvf athrill-gcc.tar.gz; sudo mv usr/local/athrill-gcc /usr/local)
fi
PATH=/usr/local/athrill-gcc/bin/:${HOME}/athrill/bin/linux:"${PATH}"
LD_LIBRARY_PATH=/usr/local/athrill-gcc:/usr/local/athrill-gcc/lib:"${LD_LIBRARY_PATH}"
export LD_LIBRARY_PATH

# setup bash initialize file
if [ ! grep athrill ${HOME}/.bashrc ]; then
cat <<EOF >>${HOME}/.bashrc
export PATH=/usr/local/athrill-gcc/bin/:\${HOME}/athrill/bin/linux:\${PATH}
export LD_LIBRARY_PATH=/usr/local/athrill-gcc:/usr/local/athrill-gcc/lib:${LD_LIBRARY_PATH}
EOF
fi

# install EV3RT development environment
git clone https://github.com/tmori/athrill-sample.git
(cd athrill-sample/ev3rt/ev3rt-beta7-release/asp3/sdk/workspace; make img=athrillsample clean; make img=athrillsample)

