# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_clean = tplroot ~ '.config.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as n8n with context %}

include:
  - {{ sls_config_clean }}

n8n is absent:
  compose.removed:
    - name: {{ n8n.lookup.paths.compose }}
    - volumes: {{ n8n.install.remove_all_data_for_sure }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if n8n.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ n8n.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if n8n.install.rootless %}
    - user: {{ n8n.lookup.user.name }}
{%- endif %}
    - require:
      - sls: {{ sls_config_clean }}

n8n compose file is absent:
  file.absent:
    - name: {{ n8n.lookup.paths.compose }}
    - require:
      - n8n is absent

n8n user session is not initialized at boot:
  compose.lingering_managed:
    - name: {{ n8n.lookup.user.name }}
    - enable: false
    - onlyif:
      - fun: user.info
        name: {{ n8n.lookup.user.name }}

n8n user account is absent:
  user.absent:
    - name: {{ n8n.lookup.user.name }}
    - purge: {{ n8n.install.remove_all_data_for_sure }}
    - require:
      - n8n is absent
    - retry:
        attempts: 5
        interval: 2

{%- if n8n.install.remove_all_data_for_sure %}

n8n paths are absent:
  file.absent:
    - names:
      - {{ n8n.lookup.paths.base }}
    - require:
      - n8n is absent
{%- endif %}
