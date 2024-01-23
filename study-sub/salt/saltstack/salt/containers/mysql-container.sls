{% set CONTAINER_NAME = 'mysql' %}
{% set BASE_PATH = '/var/lib/machines/' %}
{% set FULL_CONTAINER_NAME = "{{ salt['grains.get']('host') }}-{{ CONTAINER_NAME }}" %}
{% set FULL_PATH = '{{ BASE_PATH }}{{ CONTAINER_NAME }}' %}
{% set NET = 'notbridge' %}

############################ container prerequisites

apt_update:
  cmd.run:
    - name: apt update
    - require:
      - pkg: system_packages

system_packages:
  pkg.installed:
    - names:
      - systemd-container
      - bridge-utils
      - debootstrap

############################ container creation

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

{% if NET == 'bridge' %}
create_container_networkdev:
  file.managed:
    - name: /etc/systemd/network/br0.netdev
    - source: salt://containers/configs/net.netdev

create_container_network:
  file.managed:
    - name: /etc/systemd/network/br0.network
    - source: salt://containers/configs/net.network
{% endif%}

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

############################ container setup

## TODO: ask and search for the reason: `Failed to get shell PTY: Unit container-shell@1.service was already loaded or has a fragment file + Failed to get shell PTY: Protocol error`

install_saltminion_on_container:
  cmd.run:
    - name: machinectl shell {{ CONTAINER_NAME }} /bin/bash -c 'wget -O - https://bootstrap.saltproject.io | sh'
    - require: 
      - cmd: create_container


## TODO: add dynamic "master" config > use grains? maybe
configure_saltminion_on_container:
  file.managed:
    - name: {{ BASE_PATH }}{{ CONTAINER_NAME }}/etc/salt/minion
    - source: salt://containers/configs/minion_config.jinja
    - user: root
    - group: root
    - mode: 644
    - makedirs: True
    - template: jinja                  
    - CONTAINER_NAME: {{ CONTAINER_NAME }}  
    - require:
        - cmd: install_saltminion_on_container


key_saltminion_on_container:
  file.absent:
    - name: {{ BASE_PATH }}{{ CONTAINER_NAME }}/etc/salt/pki
    - require:
        - cmd: install_saltminion_on_container

start_salt_minion:
  cmd.run:
    - name: machinectl shell {{ CONTAINER_NAME }} /bin/bash -c 'systemctl restart salt-minion'
    - require:
      - file: configure_saltminion_on_container



  # service.running:
  #   - tgt: 'L@{{ CONTAINER_NAME }}'
  #   - name: systemd-networkd
  #   - enable: True


############################ app in container setup: mysql

# configure-mysql:
#   state.sls:
#     - tgt: 'L@{{ CONTAINER_NAME }}'
#     - sls: mysql
