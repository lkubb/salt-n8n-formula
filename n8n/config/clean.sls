# vim: ft=sls

{#-
    Removes the configuration of the n8n, db containers
    and has a dependency on `n8n.service.clean`_.

    This does not lead to the containers/services being rebuilt
    and thus differs from the usual behavior.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_service_clean = tplroot ~ ".service.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as n8n with context %}

include:
  - {{ sls_service_clean }}

n8n environment files are absent:
  file.absent:
    - names:
      - {{ n8n.lookup.paths.config_n8n }}
      - {{ n8n.lookup.paths.config_db }}
      - {{ n8n.lookup.paths.base | path_join(".saltcache.yml") }}
    - require:
      - sls: {{ sls_service_clean }}
