# Scalable and secure access with SSH
# Acceso seguro y escalable con SSH

Un problema con las claves ssh es que no tienen tiempo de vencimiento,
millones de claves se generan todos los días y se agregan a los archivos
authorized_keys para conceder permisos de acceso a los servidores.

Estás claves no están supervisadas y una clave privada de un computador robado o
tomado por alguien puede conceder permiso de accesos a los servidores.

Usando ésta estratégia podemos crear una infraestructura similar a los 
certificados X509, donde se crea una entidad de autoridad y luego se crea una nueva 
clave pública para los usuarios que necesiten acceso a un servidor.

En el servidor se configura la clave pública CA y luego los clientes con su nueva clave
firmada tendrán acceso, donde se restringe el tiempo de duración y a que usuario se 
puede loguear.

# Pasos
 - Primero creamos el CA usando el script create_ca.sh, colocar siempre una clave para proteger la clave privada, se crean dos archivos: la clave pública y la clave privada
 - La clave pública se puede configurar en los servidores que desean o también se pueden crear múltiples CA para distintos servicios.
 - Se copia la clave pública ca_key.pub en la carpeta /etc/ssh/ del servidor o servidores
 - Configurar sus servidores SSH para confiar en el CA modificando el archivo /etc/ssh/sshd_config
 - TrustedUserCAKeys /etc/ssh/ca_key.pub
 - Para no permitir que los usuarios agreguen sus propias claves al archivo authorized_keys se modifica el servidor /etc/ssh/sshd_config para que cambie la ruta donde estará ubicado el archivo authorized_keys
 - AuthorizedKeysFile      /etc/ssh/authorized_keys/%u/keys /etc/ssh/authorized_keys/%u/keys2**
 - Este nueva ruta no estará disponible para los usuarios y cambiar el archivo HOME/.ssh/authorized_keys no tendrá efecto
 - No permitir login con password
 - PasswordAuthentication no 
 - Reiniciar el servidor
 - El usuario cuando requiera acceso a un servidor debe proporcionar la clave pública al administrador del CA
 - Copiar el archivo id_rsa.pub al directorio del proyecto
 - Ejecutar sig_pub.sh
 - Lo primero que muestra es la información de la clave pública ssh del usuario para comprobar que realmente sea el.
 - Introducir datos que serviran para firmar la nueva clave y llevar una auditoria.
 - ID: nombre del usuario que solicita el acceso
 - PRINCIPAL: nombre del usuario o usuarios linux que tendrá acceso, por ejemplo, "root,ubuntu,otrousuario", el usuario prodrá iniciar sesión en esas cuentas.
 - LIVE: Tiempo de duración de vigencia de la clave pública, (+1m,+1h,+1d,+52w), +52w es un año aprox.
 - Luego se crea una nueva clave pública id_rsa-cert.pub en el directorio keys/fecha
 - Ese nuevo archivo se comparte al usuario solicitante
 - Ahora puede hacer login al servidor previamente configurado con el comando:
 - ssh -i id_rsa-cert.pub nombreusuario@servidor
 - ** Importante para obtener login es necesario el par de claves del lado del cliente, la privada que originó el clave pública que se va a firmar y la nueva clave firmada por el CA.

# Notas
 - No hay forma de revocar claves firmadas así que se recomienda crear una nueva CA en caso de que una clave esté comprometida.
 - Es recomendable crear nuevas CA cada cierto tiempo y asignar nuevamente los permisos.
 - Para más información leer https://engineering.fb.com/2016/09/12/security/scalable-and-secure-access-with-ssh/ ya que se pueden crear otras formas para autenticar servidores, creación de grupos de usuarios para acceso ssh.