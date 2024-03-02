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