# elaborado por Jairo Grateron
# jgrateron@gmail.com
# para más información y otras opciones leer
# https://engineering.fb.com/2016/09/12/security/scalable-and-secure-access-with-ssh/

mkdir -p ca 
cd ca

if [ ! -e ca_key ]; then
    # create rsa or ecdsa key
    ssh-keygen -t rsa  -C CA -f ca_key
    #ssh-keygen -t ecdsa -C CA -f ca_key
    echo
    echo "** copy public key CA ca_key.pub into /etc/ssh/ server or servers"
    echo "** Now configure your SSH servers to trust it with this single line change in /etc/ssh/sshd_config: **"
    echo "** TrustedUserCAKeys /etc/ssh/ca_key.pub **"
    echo "** Change location file authorized_keys, ssh-copy-id it has no effect or changes in HOME/.ssh/authorized_keys"
    echo "** AuthorizedKeysFile      /etc/ssh/authorized_keys/%u/keys /etc/ssh/authorized_keys/%u/keys2**"    
    echo "** PasswordAuthentication no **"
    echo "** restart ssh-server **"
fi


