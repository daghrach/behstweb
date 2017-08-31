############################################################
# install bedtools 2.25.0 and python packages
############################################################
apt-get update

apt-get install --yes \
 build-essential \
 libgcc1 \
 libc6 \
 libstdc++6 \
 gcc-multilib \
 apt-utils \
 unzip \
 zlib1g \
 zlib1g-dev \
 filo  

apt-get install --yes python2.7 python2.7-dev libpython2.7 libpython2.7-dev

apt-get install --yes openssl \
 git 

cd  /usr/local/
git clone https://github.com/arq5x/bedtools2.git
cd /usr/local/bedtools2
git checkout v2.25.0 
make

ln -s /usr/local/bedtools2/bin/* /usr/local/bin/

cd  /app
wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py
pip install -r requirements.txt

