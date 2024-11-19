# Particionar disco de 2GB
echo -e "n\np\n\n\n\nt\n8e\nw" | sudo fdisk /dev/sdb

#Particionar disco de 1GB
echo -e "n\np\n\n\n\nt\n8e\nw" | sudo fdisk /dev/sdc

#Ejecutar wipefs
sudo wipefs -a /dev/sdb1
sudo wipefs -a /dev/sdc1

#Crear volumenes fisicos
sudo pvcreate /dev/sdb1 /dev/sdc1

#Crear grupo de volumenes
sudo vgcreate vg_datos /dev/sdb1
sudo vgcreate vg_temp /dev/sdc1

#Crear volumenes logicos
sudo lvcreate -L 5M vg_datos -n lv_docker
sudo lvcreate -L 1.5G vg_datos -n lv_workareas
sudo lvcreate -L 512M vg_temp -n lv_swap

#Crear sistemas de archivos
mkfs.ext4 /dev/mapper/vg_datos-lv_docker
mkfs.ext4 /dev/mapper/vg_datos-lv_workareas
mkfs.ext4 /dev/mapper/vg_temp-lv_swap

#Crear el directorio /work/
mkdir work

#Formatear el volumen logico lv_swap a swap y lo habilito
sudo mkswap /dev/mapper/vg_temp-lv_swap
sudo swapon /dev/mapper/vg_temp-lv_swap

#Realizar montaje persistente
echo "/dev/mapper/vg_datos-lv_docker /var/lib/docker ext4 defaults 0 0" | sudo tee -a /etc/fstab
echo "/dev/mapper/vg_datos-lv_workareas /work/ ext4 defaults 0 0" | sudo tee -a /etc/fstab
echo "/dev/mapper/vg_temp-lv_swap swap swap  defaults 0 0" | sudo tee -a /etc/fstab
mount -a

# Reiniciar Docker
sudo systemctl restart docker
