update_apt:
  cmd.run:
    - name: apt-get update

install_nfs_server:
  pkg.installed:
    - name: nfs-kernel-server
    - require:
      - cmd: update_apt
    - unless: dpkg -l | grep -q nfs-kernel-server

create_shared_directory:
  cmd.run:
    - name: mkdir /mnt/dbshareddir
    - unless: test -d /mnt/dbshareddir

set_directory_owner:
  cmd.run:
    - name: chown nobody:nogroup /mnt/dbshareddir
    - require:
      - cmd: create_shared_directory
    - unless: stat -c %U:%G /mnt/dbshareddir | grep -q 'nobody:nogroup'

set_directory_permissions:
  cmd.run:
    - name: chmod 777 /mnt/dbshareddir
    - require:
      - cmd: set_directory_owner
    - unless: stat -c %a /mnt/dbshareddir | grep -q '777'

configure_exports:
  file.managed:
    - name: /etc/exports
    - source: salt://mysql/nfs/configs/master_exports
    - template: jinja
    - context:
        replica_ip: {{ salt['pillar.get']('replica1:ip') }} 
    - require:
      - cmd: set_directory_permissions

exportfs_apply:
  cmd.run:
    - name: exportfs -a
    - require:
      - file: configure_exports
    - unless: showmount -e | grep -q '/mnt/dbshareddir'

restart_nfs_server:
  service.running:
    - name: nfs-kernel-server
    - enable: True
    - reload: True
    - require:
      - cmd: exportfs_apply
    - unless: systemctl is-active --quiet nfs-kernel-server
