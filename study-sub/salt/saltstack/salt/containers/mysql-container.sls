{% set container_name = 'mysql-container' %}
{% set DIR_PATH = '/var/lib/machines/' %}

############################ container setup

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

# TODO: install salt minion on containers to handle the configs w that

create-container_fs:
  cmd.run:
    - name: |
        mkdir -p {{ DIR_PATH }}{{ container_name }}
        debootstrap --include=systemd,dbus stable {{DIR_PATH}}{{ container_name }}
        chroot {{DIR_PATH}}{{ container_name }} printf 'pts/0\npts/1\n' >> /etc/securetty
        chroot {{DIR_PATH}}{{ container_name }} /bin/bash -c "echo -e '1234\n1234' | passwd"
        chroot {{DIR_PATH}}{{ container_name }} bash -c 'apt update && apt install -y default-mysql-server; ls'
        chroot {{DIR_PATH}}{{ container_name }} printf '{{ container_name }}' > /etc/hostname

create-container:
  cmd.run:
    # - name: |        
    #     systemd-nspawn -D {{ DIR_PATH }}{{ container_name }} bash -c 'apt update && apt install -y default-mysql-server; ls'
    #     systemd-nspawn -D {{ DIR_PATH }}{{ container_name }} --boot -M mysql --private-network --network-veth --network-interface=enp0s8 -p 3306:3306
    - name: machinectl start {{ container_name }}
  # service.running:
  #   - name: systemd-networkd
  #   - enable: True
  # service.running:
  #   - tgt: 'L@{{ container_name }}'
  #   - name: systemd-networkd
  #   - enable: True


############################ app in container setup: mysql

configure-mysql:
  state.sls:
    - tgt: 'L@{{ container_name }}'
    - sls: mysql
