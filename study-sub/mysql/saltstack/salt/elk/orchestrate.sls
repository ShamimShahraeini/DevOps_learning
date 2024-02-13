# elastic-container_setup:
#   salt.state:
#     - tgt: 'minion[1,2]'
#     - sls:
#       - containers.init
#     - unless: machinectl | grep elastic
## TODO: target minions more reusable

{% for node, attr in salt.pillar.get('containers', []).items() %}

elastic_setup_{{ node }}:
  salt.state:
    - tgt: '{{ attr.host }}'
    - sls:
      - elk.elastic-setup
{% endfor %}
