#Crear dockerfile
cat << EOF > Dockerfile
 FROM nginx
 COPY index.html /usr/share/nginx/HTML
EOF

# Agrandar el espacio de lv_docker
sudo lvextend -L +280M /dev/mapper/vg_datos-lv_docker
sudo resize2fs /dev/mapper/vg_datos-lv_docker

#Contruir la imagen
docker build -t enzogr/web1-galvan:latest .

#Subir la imagen
docker push enzogr/web1-galvan:latest

#Crear archivo run.sh
cat << EOF > run.sh
 #!/bin/bash

 #corro la imagen generada anteriormente
 docker run  -d -p 8080:80 enzogr/web1-galvan:latest
EOF

