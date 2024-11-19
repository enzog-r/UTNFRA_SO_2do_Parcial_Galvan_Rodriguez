#!/bin/bash

ruta="/usr/local/bin/"
nombre_archivo="GalvanAltaUser-Groups.sh"

sudo bash -c "cat > $ruta$nombre_archivo" <<'EOF'
#!/bin/bash

archivo='/home/EnzoGalvan/UTN-FRA_SO_Examenes/202406/bash_script/Lista_Usuarios.txt'

lista_nombres=()
lista_grupos=()
lista_directorios=()

clave=$(sudo grep $(whoami) /etc/shadow | awk -F ':' '{print $2}')

#inicio el bucle por cada linea
for linea in $(cat "$archivo"); do
    
    #extraigo el nombre de usuario, el grupo y el directorio
    nombre_usuario=$(echo "$linea" | grep -i -E '2p*' |awk -F ',' ' {print $1}')
    grupo=$(echo "$linea" | grep -i -E '2p*' |awk -F ',' ' {print $2}')
    directorio=$(echo "$linea" | grep -i -E '2p*' |awk -F ',' ' {print $3}')

#verifico si en variable nombre_usuario hay algo 
    if [ -n "$nombre_usuario" ];then
        lista_nombres+=("$nombre_usuario")
        lista_grupos+=("$grupo")
        lista_directorios+=("$directorio")
    fi
done

for i in ${!lista_nombres[@]}; do

	sudo groupadd -f ${lista_grupos[i]}
        sudo useradd -m -d ${lista_directorios[i]} -s /bin/bash -p $clave ${lista_nombres[i]} -G ${lista_grupos[i]}

done
EOF
sudo chmod 755 $ruta$nombre_archivo

sudo bash $ruta$nombre_archivo


