# vim: ft=sls

{#-
    *Meta-state*.

    Undoes everything performed in the ``n8n`` meta-state
    in reverse order, i.e. stops the n8n, db services,
    removes their configuration and then removes their containers.
#}

include:
  - .service.clean
  - .config.clean
  - .package.clean
