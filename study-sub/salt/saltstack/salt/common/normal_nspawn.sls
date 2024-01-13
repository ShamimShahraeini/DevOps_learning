common_normal_nspawn:
  cmd.run:
    - name: |
        debootstrap --include=systemd,dbus stable /var/lib/machines/debian
        
        systemd-nspawn --directory=/var/lib/machines/debian -xb -M my-test

    - runas: root

  nspawn.run:
    - name: my-test
    - cmd: |
        apt install build-essential -y
        groupadd -g 666 supers
        bash -c "echo \"%supers ALL=(ALL) NOPASSWD:ALL\" > /etc/sudoers.d/supers"
        useradd -m -G supers test
        bash -c "echo -e \"1234\" | passwd test"