update_apt:
  cmd.run:
    - name: apt-get update

install_nfs_server:
  pkg.installed:
    - name: nfs-common
    - require:
      - cmd: update_apt
    - unless: dpkg -l | grep -q nfs-common

create_shared_directory:
  cmd.run:
    - name: mkdir /var/dbshareddir
    - unless: test -d /var/dbshareddir

use_shared_dir:
  cmd.run:
    - name: mount -t nfs {{ salt['pillar.get']('master:ip') }}:/mnt/dbshareddir /var/dbshareddir
    - require:
        - cmd: create_shared_directory

get_socalled_dumpfile:
  cmd.run:
    - name: cp /var/dbshareddir/dbdump.sql /var/lib/mysql/dbdump.sql
    - require:
      - cmd: use_shared_dir
