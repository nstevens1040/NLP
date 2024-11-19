# compile coref_kernels.so on the following Ubuntu release
# NAME="Ubuntu"
# VERSION="20.04.5 LTS (Focal Fossa)"
# ID=ubuntu
# ID_LIKE=debian
# PRETTY_NAME="Ubuntu 20.04.5 LTS"
# VERSION_ID="20.04"
# HOME_URL="https://www.ubuntu.com/"
# SUPPORT_URL="https://help.ubuntu.com/"
# BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
# PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
# VERSION_CODENAME=focal
# UBUNTU_CODENAME=focal
sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade -y && sudo apt autoremove -y
sudo apt install python3-dev python3-pip python3-venv curl -y
if [[ ! -d "$HOME/.temp/" ]]; then
    mkdir "$HOME/.temp/"
fi
if [[ ! -d "$HOME/.temp/bin/" ]]; then
    mkdir "$HOME/.temp/bin/"
fi
if [[ ! -d "$HOME/.temp/zip/" ]]; then
    mkdir "$HOME/.temp/zip/"
fi
if [[ ! -d "$HOME/.temp/bin/libtensorflow/" ]]; then
    mkdir "$HOME/.temp/bin/libtensorflow/"
fi
if [[ ! -d "$HOME/.temp/venv/" ]]; then
    mkdir "$HOME/.temp/venv/"
fi
cd "$HOME/.temp/zip/"
wget "https://storage.googleapis.com/tensorflow/libtensorflow/libtensorflow-cpu-linux-x86_64-2.10.0.tar.gz"
tar -C "$HOME/.temp/bin/libtensorflow/" -xzf libtensorflow-cpu-linux-x86_64-2.10.0.tar.gz
cd "$HOME/.temp/bin/"
git clone https://github.com/kentonl/e2e-coref.git && cd e2e-coref/
if [[ ! -d "./results/" ]]; then
    mkdir results
fi
if [[ ! -f "glove.840B.300d.txt" ]]; then
    curl -O http://downloads.cs.stanford.edu/nlp/data/glove.840B.300d.zip
    unzip glove.840B.300d.zip
    rm glove.840B.300d.zip
fi
if [[ ! -f "e2e-coref.tgz" ]]; then
    curl "https://www.googleapis.com/drive/v3/files/1fkifqZzdzsOEo0DXMzCFjiNXqsKG_cHi?alt=media&key=AIzaSyAs8IzoFwA6yrn2LnMGo0ofwMTaD2csJTk" --output "e2e-coref.tgz"
    tar -xzvf e2e-coref.tgz
fi
if [[ ! -f "char_vocab.english.txt" ]]; then
    wget "https://raw.githubusercontent.com/luheng/lsgn/master/embeddings/char_vocab.english.txt"
fi
python3 -m pip install --upgrade pip
mv requirements.txt requirements.txt.bak
cat <<EOF > requirements.txt
tensorflow-cpu>=1.13.1
tensorflow-hub>=0.4.0
h5py
nltk
pyhocon
scipy
sklearn
EOF

python3 -m venv "$HOME/.temp/venv/e2e-coref"
source "$HOME/.temp/venv/e2e-coref/bin/activate"
python -m pip install --upgrade pip
pip install -r requirements.txt 
TF_CFLAGS=( $(python -c 'import tensorflow as tf; print(" ".join(tf.sysconfig.get_compile_flags()))') )
TF_LFLAGS=( $(python -c 'import tensorflow as tf; print(" ".join(tf.sysconfig.get_link_flags()))') )
export LD_LIBRARY_PATH="$HOME/.temp/bin/libtensorflow/lib"
export LIBRARY_PATH="$HOME/.temp/bin/libtensorflow/lib"
g++ -std=c++17 -shared coref_kernels.cc -o coref_kernels.so -fPIC ${TF_CFLAGS[@]} -Wl,--no-as-needed ${TF_LFLAGS[@]}  -O2

mkdir patch
wget "https://storage.googleapis.com/nlp-137cf635-6c92-49b5-b943-f5c8c75e686f/e2e-coref-patch.tar.gz"
tar -xf e2e-coref-patch.tar.gz -C ./patch

mv coref_model.py coref_model.py.bak
mv coref_ops.py coref_ops.py.bak
mv demo.py demo.py.bak
mv metrics.py metrics.py.bak
mv predict.py predict.py.bak
mv util.py util.py.bak

patch --input=./patch/coref_model.py.patch --output=./coref_model.py ./coref_model.py.bak
patch --input=./patch/coref_ops.py.patch --output=./coref_ops.py ./coref_ops.py.bak
patch --input=./patch/demo.py.patch --output=./demo.py ./demo.py.bak
patch --input=./patch/metrics.py.patch --output=./metrics.py ./metrics.py.bak
patch --input=./patch/predict.py.patch --output=./predict.py ./predict.py.bak
patch --input=./patch/util.py.patch --output=./util.py ./util.py.bak
