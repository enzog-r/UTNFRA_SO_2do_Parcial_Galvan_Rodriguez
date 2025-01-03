#Crear carpeta templates en /roles/2do_parcial
mkdir templates


#Crear archivo datos_alumno.j2
 Nombre: {{ alumno_nombre }}
 Apellido: {{ alumno_apellido }}
 División: {{ alumno_division }}

#Crear archivo datos_equipo.j2:
 Nombre Distribucion: {{ ansible_facts.distribution }}
 IP: {{ ansible_default_ipv4.address }}
 Todas las IP: {{ ansible_facts.all_ipv4_addresses }}

#Completar el archivo main.yml en /tasks
# tasks file for 2do_parcial

- debug:
    msg: "Tareas del 2do Parcial"

- name: "Crear directorios en /tmp/"
  file:
    path: "/tmp/2do_parcial/{{ item }}"
    state: directory
    mode: '0775'
    recurse: yes
  with_items:
    - "alumno"
    - "equipo"

- name: "Crear archivo datos_alumno.txt"
  template:
    src: datos_alumno.j2
    dest: /tmp/2do_parcial/alumno/datos_alumno.txt
  vars:
    alumno_nombre: "Enzo"
    alumno_apellido: "Galvan Rodriguez"
    alumno_division: "113"

- name: "Crear archivo datos_equipo.txt"
  template:
    src: datos_equipo.j2
    dest: /tmp/2do_parcial/equipo/datos_equipo.txt

- name: "Crear archivo vacío para 2PSupervisores"
  file:
    path: /etc/sudoers.d/2PSupervisores
    state: touch
    mode: '0440'

- name: "Agrego NOPASSW en sudoers para el grupo 2PSupervisores"
  become: yes
  lineinfile:
    path: /etc/sudoers.d/2PSupervisores
    state: present
    line: '%2PSupervisores ALL=(ALL) NOPASSWD: ALL'
    validate: 'visudo -cf %s'



#Ejecutar ansible
sudo ansible-playbook -i inventory/hosts playbook.yml
