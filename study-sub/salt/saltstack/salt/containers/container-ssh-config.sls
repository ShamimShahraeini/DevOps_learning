install_ssh_packages:
  pkg.installed:
    - names:
      - openssh-server
      - openssh-client

configure_ssh:
  file.managed:
    - name: /etc/ssh/sshd_config.d/sshd_config.conf
    - source: salt://containers/configs/sshd_config
    - template: jinja
    - require:
      - pkg: install_ssh_packages

generate_ssh_key:
  cmd.run:
    - name: ssh-keygen -q -N '' -f .ssh/id_rsa
    - unless: test -f .ssh/id_rsa

restart_ssh:
  service.running:
    - name: ssh
    - onchanges :
      - file: configure_ssh
