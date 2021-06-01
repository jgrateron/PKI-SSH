#!/bin/bash
# elaborado por Jairo Grateron
# jgrateron@gmail.com

mkdir -p audit

FECHA=$(date +%Y%m%d)

#revisamos si no existe el archivo de correlativo de serial, se crea
if [ ! -e ca/serial ]; then
   echo "1" > ca/serial
fi

#revisamos si existe la clave privada del ca ca_key
if [ -e ca/ca_key ]; then
   if [ -e id_rsa.pub ]; then
   
      #vemos el contenido a firmar
      ssh-keygen -lf id_rsa.pub 
      SERIAL=$(cat ca/serial)

      read -p "ID: " ID
      read -p "PRINCIPAL (root,ubuntu): " PRINCIPAL
      read -p "LIVE (+1m,+1h,+1d,+52w): " LIVE

      DIR="keys/$FECHA/$ID"
      mkdir -p $DIR

      ssh-keygen -s ca/ca_key -I $ID -n "$PRINCIPAL" -V $LIVE -z $SERIAL id_rsa.pub 2>> "audit/$FECHA.txt"

      #incrementamos el serial
      SERIAL=$((SERIAL+1))
      echo $SERIAL > ca/serial
   
      #movemos el archivo al directorio donde se almacenaran las claves creadas
      mv id_rsa-cert.pub "$DIR/id_rsa-cert.pub"

      #vemos el contenido de la nueva clave privada
      ssh-keygen -Lf "$DIR/id_rsa-cert.pub"

      #borramos la clave pública
      rm id_rsa.pub
      echo "Share the file to the owner of the public key '$DIR/id_rsa-cert.pub'"
      echo "From client deletes all identities from the agent"
      echo "ssh-add -D"
      echo "From client login to server:"
      echo "ssh -i id_rsa-cert.pub server"
   else
      echo "the public key does not exist (id_rsa.pub)"
   fi
else
   echo "CA private key does not exist"
fi
