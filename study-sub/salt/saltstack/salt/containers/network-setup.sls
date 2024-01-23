{% set NET = 'notbridge' %}

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

# service.running:
#   - tgt: 'L@*-{{ CONTAINER_NAME }}'
#   - name: systemd-networkd
#   - enable: True
