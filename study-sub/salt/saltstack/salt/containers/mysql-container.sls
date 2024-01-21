{% set CONTAINER_NAME = 'mysql' %}
{% set BASE_PATH = '/var/lib/machines/' %}
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

create_container_fs:
  cmd.run:
    - name: |
        mkdir -p {{ BASE_PATH }}{{ CONTAINER_NAME }}
        #debootstrap --include=systemd,dbus stable {{ BASE_PATH }}{{ CONTAINER_NAME }}
        chroot {{ BASE_PATH }}{{ CONTAINER_NAME }} printf 'pts/0\npts/1\n' >> /etc/securetty
        chroot {{ BASE_PATH }}{{ CONTAINER_NAME }} /bin/bash -c "echo -e '1234\n1234' | passwd"

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

{% if not salt['file.directory_exists' ]('/etc/systemd/nspawn/') %}
create_container_configdir:
  file.directory:
    - name:  /etc/systemd/nspawn/
    - mode:  755
{% endif %}


## TODO: make the config files dynamic (jinja>var>container, path, ...)
create_container_configfile:
  file.managed:
    - name: /etc/systemd/nspawn/{{ CONTAINER_NAME }}.nspawn
    - source: salt://containers/configs/configfile.nspawn

create_container_unitfile:
  file.managed:
    - name: /etc/systemd/system/container@{{ CONTAINER_NAME }}.service
    - source: salt://containers/configs/unitfile.service

# copy_salt_install_script_to_container:
#   file.managed:
#     - name: '{{BASE_PATH}}{{ CONTAINER_NAME }}/root/bootstrap_salt.sh'
#     - source: /tmp/bootstrap_salt.sh

# copy_salt_install_key_to_container:
#   file.managed:
#     - name: '{{BASE_PATH}}{{ CONTAINER_NAME }}/root/salt-gpg-Fx6JQxBk.pub'
#     - source: /tmp/salt-gpg-Fx6JQxBk.pub

create_container:
  cmd.run:
    - name: |
        systemctl daemon-reload
        systemctl start container@{{ CONTAINER_NAME }}.service
        systemctl enable container@{{ CONTAINER_NAME }}.service

############################ container setup

# install_saltminion_on_container:
#   cmd.run:
#     - name: machinectl shell {{ CONTAINER_NAME }} /usr/bin/sh /root/bootstrap_salt.sh -x python3 git v3006.1
#     - runas: root
    

requirements_to_install_saltminion_on_container:
  cmd.run:
    - name: |
        machinectl shell {{ CONTAINER_NAME }} /usr/bin/bash -c 'apt install curl -y'
        machinectl shell {{ CONTAINER_NAME }} /usr/bin/bash -c 'curl -fsSL -o /etc/apt/keyrings/salt-archive-keyring-2023.gpg https://repo.saltproject.io/salt/py3/debian/12/amd64/SALT-PROJECT-GPG-PUBKEY-2023.gpg; ls'
        machinectl shell {{ CONTAINER_NAME }} /usr/bin/bash -c 'echo "deb [signed-by=/etc/apt/keyrings/salt-archive-keyring-2023.gpg arch=amd64] https://repo.saltproject.io/salt/py3/debian/12/amd64/latest bookworm main" | tee /etc/apt/sources.list.d/salt.list; ls'
    - runas: root

## TODO: ask and search for the reason: `Failed to get shell PTY: Unit container-shell@1.service was already loaded or has a fragment file`
bug:
  cmd.run:
    - name: |
        systemctl restart container@{{ CONTAINER_NAME }}.service
    - require_in: 
      - cmd: install_saltminion_on_container

install_saltminion_on_container:
  cmd.run:
    - name: |       
        machinectl shell {{ CONTAINER_NAME }} /usr/bin/apt-get update
        machinectl shell {{ CONTAINER_NAME }} /usr/bin/bash -c 'apt-get install salt-minion -y'
    - require: 
      - cmd: requirements_to_install_saltminion_on_container

## TODO: add 'require' statements
copy_salt_config_to_container:
  file.copy:
    - name: {{ BASE_PATH }}{{ CONTAINER_NAME }}/etc/salt/minion
    - source: /etc/salt/minion

configure_salt_minion:
  file.managed:
    - name: {{ BASE_PATH }}{{ CONTAINER_NAME }}/etc/salt/minion_id
    - source: salt://containers/configs/minion_config.jinja
    - user: root
    - group: root
    - mode: 644

start_salt_minion:
  cmd.run:
    - name: machinectl shell {{ CONTAINER_NAME }} /usr/bin/bash -c 'systemctl restart salt-minion'



  # service.running:
  #   - tgt: 'L@{{ CONTAINER_NAME }}'
  #   - name: systemd-networkd
  #   - enable: True


############################ app in container setup: mysql

# configure-mysql:
#   state.sls:
#     - tgt: 'L@{{ CONTAINER_NAME }}'
#     - sls: mysql
