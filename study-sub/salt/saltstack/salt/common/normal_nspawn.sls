{% set DIR_PATH = '/var/lib/machines/debian' %}
{% set CONTAINER_NAME = 'my-test' %}


dependencies_config:
  cmd.run:
    - name: |
        debootstrap --include=systemd,dbus stable {{DIR_PATH}}
        chroot {{DIR_PATH}} printf 'pts/0\npts/1\n' >> /etc/securetty
        chroot {{DIR_PATH}} /bin/bash -c "echo -e '1234\n1234' | passwd"
    - runas: root

copy_nspawnfiles_dependencies:
  file.managed:
    - name: /etc/systemd/nspawn/{{CONTAINER_NAME}}.nspawn
    - source: salt://conf.nspawn
    - makedirs: True

copy_unitfiles_dependencies:
  file.managed:
    - name: /etc/systemd/system/{{CONTAINER_NAME}}.service
    - source: salt://unitfile.service
    - makedirs: True

run_container:
  # service.running:
  #   - enable: True
  #   - start: True
  #   - watch:
  #     - pkg: {{CONTAINER_NAME}}
  #   - runas: root
  cmd.run:
    - name: machinectl start {{CONTAINER_NAME}}


user_manage_nspawn:
  module.run:
    - name: nspawn.run
    - m_name: my-test
    - m_cmd: |
        apt install build-essential -y
        groupadd -g 666 supers
        bash -c "echo \"%supers ALL=(ALL) NOPASSWD:ALL\" > /etc/sudoers.d/supers"
        useradd -m -G supers test
        bash -c "echo -e \"1234\" | passwd test"


##        chroot {{DIR_PATH}} printf 'Boot=on\nEphemeral=on\nUser=root\nHostname=my-test\nPrivateUsers=pick\n' >> /etc/systemd/nspawn/my-test.nspawn
##        systemd-nspawn --directory={{DIR_PATH}} -x -M my-test --private-users=pick --private-users-ownership=auto