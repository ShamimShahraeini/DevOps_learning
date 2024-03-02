install_percona:
  cmd.run: 
    - name: |
        apt install -y curl
        curl -O https://repo.percona.com/apt/percona-release_latest.generic_all.deb
        apt install -y gnupg2 lsb-release ./percona-release_latest.generic_all.deb
        apt update
        percona-release setup ps80
        apt install percona-server-server -y
    - unless: 'which mysql'