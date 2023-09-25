# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_file = tplroot ~ ".config.file" %}
{%- from tplroot ~ "/map.jinja" import mapdata as n8n with context %}

include:
  - {{ sls_config_file }}

n8n service is enabled:
  compose.enabled:
    - name: {{ n8n.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if n8n.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ n8n.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
    - require:
      - n8n is installed
{%- if n8n.install.rootless %}
    - user: {{ n8n.lookup.user.name }}
{%- endif %}

n8n service is running:
  compose.running:
    - name: {{ n8n.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if n8n.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ n8n.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if n8n.install.rootless %}
    - user: {{ n8n.lookup.user.name }}
{%- endif %}
    - watch:
      - n8n is installed
      - sls: {{ sls_config_file }}
