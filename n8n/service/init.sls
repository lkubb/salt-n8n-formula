# vim: ft=sls

{#-
    Starts the n8n, db container services
    and enables them at boot time.
    Has a dependency on `n8n.config`_.
#}

include:
  - .running
