{% set CONTAINER_NAME = salt['pillar.get'](grains.get('id') + ':container_name') %}
{% set BASE_PATH = salt['pillar.get'](grains.get('id') + ':container_base_path') %}
{% set BIND_PATH = salt['pillar.get'](grains.get('id') + ':bind_path') %}
{% set PORT = salt['pillar.get'](grains.get('id') + ':port') %}
{% set FULL_PATH = BASE_PATH ~ CONTAINER_NAME %}

include:
  - containers.prerequisites

############################ container fs creation

{% if not salt['file.directory_exists' ]('{{ FULL_PATH }}') %}
create_container_fs:
  cmd.run:
    - name: |
        mkdir -p {{ FULL_PATH }}
        debootstrap --include="systemd,dbus,wget,net-tools,ssh" stable {{ FULL_PATH }}
        chroot {{ FULL_PATH }} printf 'pts/0\npts/1\n' >> /etc/securetty
        chroot {{ FULL_PATH }} /bin/bash -c "echo -e '1234\n1234' | passwd"
        chroot {{ FULL_PATH }} /bin/bash -c "echo -e '$(hostname)-{{ CONTAINER_NAME }}' | tee /etc/hostname"
    - unless: test -f {{ FULL_PATH }}/etc/securetty
{% endif %}

############################ container creation

create_container_configfile:
  file.managed:
    - name: /etc/systemd/nspawn/{{ CONTAINER_NAME }}.nspawn
    - source: salt://containers/configs/configfile.nspawn
    - makedirs: True
    - template: jinja                  
    - CONTAINER_NAME: {{ CONTAINER_NAME }}  
    - BIND_PATH: {{ BIND_PATH }}    
    - PORT: {{ PORT }}
    - unless: test -f /etc/systemd/nspawn/{{ CONTAINER_NAME }}.nspawn

create_container_unitfile:
  file.managed:
    - name: /etc/systemd/system/container@{{ CONTAINER_NAME }}.service
    - source: salt://containers/configs/unitfile.service
    - template: jinja                  
    - CONTAINER_NAME: {{ CONTAINER_NAME }}    
    - unless: test -f /etc/systemd/system/container@{{ CONTAINER_NAME }}.service

create_container:
  cmd.run:
    - name: |
        systemctl daemon-reload
        systemctl start container@{{ CONTAINER_NAME }}.service
        systemctl enable container@{{ CONTAINER_NAME }}.service
        sleep 30
    - unless: machinectl | grep {{ CONTAINER_NAME }}
    - watch:
      - file: create_container_unitfile
