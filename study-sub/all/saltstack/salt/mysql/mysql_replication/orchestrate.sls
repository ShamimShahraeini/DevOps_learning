
{% for node, attr in salt.pillar.get('containers', []).items() %}
mysql_setup_{{ node }}:
  salt.state:
    - tgt: '{{ attr.host }}'
    - sls:
      - mysql.mysql_setup.init

{% if attr.role == 'db-master' %}
mysql_rep_{{ node }}:
  salt.state:
    - tgt: '{{ attr.host }}'
    - sls:
      - mysql.mysql_replication.master
{% elif attr.role == 'db-replica' %}
mysql_rep_{{ node }}:
  salt.state:
    - tgt: '{{ attr.host }}'
    - sls:
      - mysql.mysql_replication.replication
{% endif %}

{% if attr.role == 'db-master' %}
mysql_dump_{{ node }}:
  salt.state:
    - tgt: '{{ attr.host }}'
    - sls:
      - mysql.mysql_replication.dump_master_data
{% elif attr.role == 'db-replica' %}
mysql_use_dump_{{ node }}:
  salt.state:
    - tgt: '{{ attr.host }}'
    - sls:
      - mysql.mysql_replication.use_dump_on_replica
{% endif %}

mysql_restart_{{ node }}:
  salt.state:
    - tgt: '{{ attr.host }}'
    - sls:
      - mysql.mysql_setup.service
    - watch:
      - salt: mysql_setup_{{ node }}
      
{% endfor %}


#  on master > salt-run state.orchestrate mysql.mysql_replication.orchestrate