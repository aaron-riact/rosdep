Overview
========

Installing rosdep
-----------------

.. admonition:: Note

    If you want to use rosdep with ROS1/2, you should install rosdep
    following their installation instructions:

    * `ROS1 installation instructions
      <http://wiki.ros.org/ROS/Installation>`_
    * `ROS2 installation instructions
      <http://docs.ros.org/en/iron/Installation.html>`_
      [#rosdep_in_dev_tools]_

    .. [#rosdep_in_dev_tools] In ROS2 Foxy and beyond, rosdep is included in the ros-dev-tools package.

It is recommended to use the system package manager to install rosdep.

rosdep2 is a system package under Ubuntu and Debian::

    # Ubuntu >= 20.04 (Focal)
    sudo apt-get install python3-rosdep
    # Debian >=11 (Bullseye)
    sudo apt-get install python3-rosdep2

If rosdep doesn't exist in your package manager, you can install it
using pip or easy_install::

    # Python 2
    sudo pip install -U rosdep
    # Python 3
    sudo pip3 install -U rosdep
    # easy_install
    sudo easy_install -U rosdep rospkg



Setting up rosdep
-----------------

rosdep needs to be initialized and updated to use::

    sudo rosdep init
    rosdep update

``sudo rosdep init`` will create a `sources list <sources_list>`_
directory in ``/etc/ros/rosdep/sources.list.d`` that controls where
rosdep gets its data from.

``rosdep update`` reads through this sources list to initialize your
local database.

Updating rosdep
---------------

You can update your rosdep database by running::

    rosdep update


Installating rosdeps
--------------------

rosdep takes in the name of a ROS stack or package that you wish to
install the system dependencies for.

Common installation workflow::

    $ rosdep check ros_comm
    All system dependencies have been satisfied
    $ rosdep install geometry

If you're worried about ``rosdep install`` bringing in system
dependencies you don't want, you can run ``rosdep install -s <args>``
instead to "simulate" the installation.  You will be able to see the
commands that rosdep would have run.

Example::

    $ rosdep install -s ros_comm
    #[apt] Installation commands:
      sudo apt-get install libapr1-dev
      sudo apt-get install libaprutil1-dev
      sudo apt-get install libbz2-dev
      sudo apt-get install liblog4cxx10-dev
      sudo apt-get install pkg-config
      sudo apt-get install python-imaging
      sudo apt-get install python-numpy
      sudo apt-get install python-paramiko
      sudo apt-get install python-yaml

You can also query rosdep to find out more information about specific
dependencies::

    $ rosdep keys roscpp
    pkg-config

    $ rosdep resolve pkg-config
    pkg-config

    $ rosdep keys geometry
    eigen
    apr
    glut
    python-sip
    python-numpy
    graphviz
    paramiko
    cppunit
    libxext
    log4cxx
    pkg-config

    $ rosdep resolve eigen
    libeigen3-dev

If you are uncertain the name of a key or package, use ``rosdep search <searchstring>`` which uses fuzzy-search if Python module regex is installed.::

    $ rosdep search pcl dev
    Closest keys:
        libpcl-all-dev

For more information, please see the :ref:`command reference <rosdep_usage>`.


Understanding Virtual Packages
------------------------------

rosdep supports the concept of *virtual packages*, which are particularly important when working with Debian and Ubuntu systems.

What is a virtual package?
'''''''''''''''''''''''''''

A virtual package is an abstract package name that doesn't correspond to a single installable package, but instead represents a capability or interface that can be provided by one or more different real packages. Virtual packages are used to:

* Provide flexibility in package selection
* Allow multiple packages to satisfy the same dependency
* Abstract away implementation details from dependents

How virtual packages work in rosdep
''''''''''''''''''''''''''''''''''''

When rosdep encounters a virtual package on Debian/Ubuntu systems, it:

1. Uses ``apt-cache showpkg`` to detect if a package is virtual
2. A package is considered virtual if it has no versions but has providers listed in the "Reverse Provides" section
3. When installing, rosdep can substitute the virtual package with one of its concrete providers

Example
'''''''

A common example is ``libcurl-dev``:

.. code-block:: bash

    $ apt-cache showpkg libcurl-dev
    Package: libcurl-dev
    Versions: 
    
    Reverse Depends: 
      libdap-dev,libcurl-dev
      libnxml0-dev,libcurl-dev
      libglyr-dev,libcurl-dev
    Dependencies: 
    Provides: 
    Reverse Provides: 
    libcurl4-openssl-dev 7.47.0-1ubuntu2.4 (= )
    libcurl4-nss-dev 7.47.0-1ubuntu2.4 (= )
    libcurl4-gnutls-dev 7.47.0-1ubuntu2.4 (= )

In this case:

* ``libcurl-dev`` is a virtual package (no versions listed)
* It can be provided by ``libcurl4-openssl-dev``, ``libcurl4-nss-dev``, or ``libcurl4-gnutls-dev``
* rosdep will select one of these providers when installing

This allows ROS packages to depend on "libcurl-dev" without needing to know which specific SSL implementation should be used on the target system.

