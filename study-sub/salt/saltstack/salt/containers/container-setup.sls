{% set CONTAINER_NAME = 'mysql' %}
{% set BASE_PATH = '/var/lib/machines/' %}

include:
  - containers.prerequisites

############################ container fs creation

{% if not salt['file.directory_exists' ]('{{ BASE_PATH }}{{ CONTAINER_NAME }}') %}
create_container_fs:
  cmd.run:
    - name: |
        mkdir -p {{ BASE_PATH }}{{ CONTAINER_NAME }}
        debootstrap --include="systemd,dbus,wget,net-tools" stable {{ BASE_PATH }}{{ CONTAINER_NAME }}
        chroot {{ BASE_PATH }}{{ CONTAINER_NAME }} printf 'pts/0\npts/1\n' >> /etc/securetty
        chroot {{ BASE_PATH }}{{ CONTAINER_NAME }} /bin/bash -c "echo -e '1234\n1234' | passwd"
        chroot {{ BASE_PATH }}{{ CONTAINER_NAME }} /bin/bash -c "echo -e '$(hostname)-{{ CONTAINER_NAME }}' | tee /etc/hostname"
{% endif %}

############################ container creation

create_container_configfile:
  file.managed:
    - name: /etc/systemd/nspawn/{{ CONTAINER_NAME }}.nspawn
    - source: salt://containers/configs/configfile.nspawn
    - makedirs: True
    - template: jinja                  
    - CONTAINER_NAME: {{ CONTAINER_NAME }}      

create_container_unitfile:
  file.managed:
    - name: /etc/systemd/system/container@{{ CONTAINER_NAME }}.service
    - source: salt://containers/configs/unitfile.service
    - template: jinja                  
    - CONTAINER_NAME: {{ CONTAINER_NAME }}    

create_container:
  cmd.run:
    - name: |
        systemctl daemon-reload
        systemctl start container@{{ CONTAINER_NAME }}.service
        systemctl enable container@{{ CONTAINER_NAME }}.service
        sleep 30
