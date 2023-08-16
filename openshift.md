kullanıcıyı sudeors ekle
redhat dan crc dosyasını indir

tar xvf crc-linux-amd64.tar.xz
export PATH=$PATH:~/crc-linux-2.24.1-amd64
crc version
crc setup
crc start -p pull-secret.txt 
eval $(crc oc-env)
oc login -u kubeadmin https://api.crc.testing:6443
oc get projects
oc get po -A
oc get all
crc status
oc get all
oc get po -A
crc status
