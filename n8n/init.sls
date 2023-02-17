# vim: ft=sls

{#-
    *Meta-state*.

    This installs the n8n, db containers,
    manages their configuration and starts their services.
#}

include:
  - .package
  - .config
  - .service
