Available states
----------------

The following states are found in this formula:

.. contents::
   :local:


``n8n``
^^^^^^^
*Meta-state*.

This installs the n8n, db containers,
manages their configuration and starts their services.


``n8n.package``
^^^^^^^^^^^^^^^
Installs the n8n, db containers only.
This includes creating systemd service units.


``n8n.config``
^^^^^^^^^^^^^^
Manages the configuration of the n8n, db containers.
Has a dependency on `n8n.package`_.


``n8n.service``
^^^^^^^^^^^^^^^
Starts the n8n, db container services
and enables them at boot time.
Has a dependency on `n8n.config`_.


``n8n.clean``
^^^^^^^^^^^^^
*Meta-state*.

Undoes everything performed in the ``n8n`` meta-state
in reverse order, i.e. stops the n8n, db services,
removes their configuration and then removes their containers.


``n8n.package.clean``
^^^^^^^^^^^^^^^^^^^^^
Removes the n8n, db containers
and the corresponding user account and service units.
Has a depency on `n8n.config.clean`_.
If ``remove_all_data_for_sure`` was set, also removes all data.


``n8n.config.clean``
^^^^^^^^^^^^^^^^^^^^
Removes the configuration of the n8n, db containers
and has a dependency on `n8n.service.clean`_.

This does not lead to the containers/services being rebuilt
and thus differs from the usual behavior.


``n8n.service.clean``
^^^^^^^^^^^^^^^^^^^^^
Stops the n8n, db container services
and disables them at boot time.


