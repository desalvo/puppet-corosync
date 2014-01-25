puppet-corosync
======

Puppet module for managing corosync configurations.

#### Table of Contents
1. [Overview - What is the corosync module?](#overview)
2. [Usage](#usage)

Overview
--------

This module is a simple configurator for corosync/pacemaker services.

Usage
-----

Parameters:
* **bindnetaddr**: the IP to bind the servies to
* **broadcast**: set this to true if you want to use broadcast instead of multicast
* **mcastaddr**: the multicast address, if using multicast
* **mcastport**: the multicast port of the cluster
* **pacemaker**: set this to the value of the pacemaker protocol, if you want to automatically start pacemaker
* **secauth**: enable or disable secure authentication (default false)
* **authkey**: the authentication key

**Sample usage**

```corosync
class {'corosync':
    bindnetaddr => $ipaddress,
    mcastaddr   => '226.94.1.1',
    mcastport   => 5405,
    secauth     => false,
    authkey     => 'puppet:///modules/mymodule/authkey',
    pacemaker   => 0
}
```

Contributors
------------

* https://github.com/desalvo/puppet-corosync/graphs/contributors

Release Notes
-------------

**0.1.0**

* Initial version
