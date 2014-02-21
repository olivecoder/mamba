.. _installation_guide:

Mamba installation guide
========================

Mamba is written in the Python programming language and supports only version 2.7 of the language (some Mamba components do not support Python 3.x yet). Mamba also need a database server (`SQLite <http://sqlite.org/>`_, `MySQL <http://mysql.com/>`_, `MariaDB <https://mariadb.org/>`_ or `PostgreSQL <http://www.postgresql.org/>`_ are currently supported) in order to create and use schemas through `Storm ORM <http://storm.canonical.com>`_. For HTML rendering, Mamba uses the `Jinja2 <http://jinja.pocoo.org/docs/>`_ templating system.

In order to execute Mamba tests suite `doublex <https://bitbucket.org/DavidVilla/python-doublex>`_ and `PyHamcrest <http://pythonhosted.org/PyHamcrest/>`_ are required.

To build the documentation, Fabric must be installed on the system.

Installation Step
-----------------

1. :ref:`Dependencies`
    1. :ref:`Mandatory Dependencies`
    2. :ref:`Optional Dependencies`
2. :ref:`Installing Mamba`
    1. :ref:`The easy way`
    2. :ref:`Living on the edge`
3. :ref:`Using Mamba`

.. _Dependencies:

Dependencies
------------

These are the Mamba framework dependencies

.. _Mandatory Dependencies:

Mandatory Dependencies
......................

The following dependencies must be satisfied to install mamba.

* |python|_, version >= 2.7 <= 2.7.5 (3.x is not supported)
* |twisted|_, version >= 10.2.0
* |mamba-storm|_, version >= 0.19
* `zope.component <http://docs.zope.org/zope.component/>`_
* `transaction <http://www.zodb.org/zodbbook/transactions.html>`_
*  |jinja2|_, version >= 2.4

Is pretty possible that you also need a database manager and the corresponding Python bindings for it. The database can be either SQLite, MySQL, MariaDB (recommended) or PostgreSQL (recommended).

For SQLite database
~~~~~~~~~~~~~~~~~~~

As you're using Python 2.7, SQLite should be already built in. This may not be true if you compiled Python interpreter yourself, in that case make sure you compile it with --enable-loadable-sqlite-extensions option.

If you are using PyPy, SQLite should be always compiled and present in your installation.

For MySQL and MariaDB databases
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The `MySQLdb <http://sf.net/projects/mysql-python>`_ driver should do the work for both database managers.

For PostgreSQL database
~~~~~~~~~~~~~~~~~~~~~~~

The `psycopg2 <http://pypi.python.org/pypi/psycopg2>`_ driver is our target for PostgreSQL databases if we are using the CPython interpreter

If you are using PyPy as your interpreter you need to install `psycopg2ct <https://github.com/mvantellingen/psycopg2-ctypes>`_ instead. Psycopg2ct is a psycopg2 implementation that uses ctypes and is just what we want to do the job in PyPy.

.. warning::

    Versions of psycopg2 (CPython) higher than 2.4.6 doesn't work with Storm so you have to be sure to install a version lower than 2.5 that is the current version as May 2013


.. _Optional Dependencies:

Optional Dependencies
.....................

The following dependencies must be satisfied if we are planning on running Mamba tests, building the documentation yourself or contributing with the Mamba project

* |doublex|_, version >= 1.5.1
* `PyHamcrest <http://pythonhosted.org/PyHamcrest/>`_
* |sphinx|_, version >= 1.1.3
* |fabric|_
* |virtualenv|_
* |pyflakes|_
* |pep8|_

.. _Installing Mamba:

Installing Mamba
----------------

There are three ways to install mamba in your system.

The first one is install all the Mamba dependencies like any other software: downloading it from sources, precompiled binaries or using your distribution package manager.

The second one is using ``pip`` or ``easy_install`` as::

    $ sudo pip install mamba-framework

.. _The easy way:

The easy way and recommended way: PyPI - the Python Package Index
.............................................

The third one is using virtualenv to create a virtual environment for your Mamba framework installation and then using ``pip`` on it::

    $ virtualenv --no-site-packages -p /usr/bin/python --prompt='(mamba-python2.7) ' mamba-python2.7
    $ source mamba-python2.7/bin/activate
    $ pip install mamba-framework
    $ pip install MySQL-Python

Or if you prefer to use ``virtualenvwrapper``::

    $ mkvirtualenv --no-site-packages -p /usr/bin/python --prompt='(mamba-python2.7) ' mamba-python2.7
    $ pip install mamba-framework
    $ pip install MySQL-Python

We recommend the use of ``virtualenvwrapper`` in development environments as it is cleaner and easier to maintain.

.. _Living on the edge:

Living on the edge
..................

If you like to live in the edge you can clone Mamba's |repo|_ and use the ``setup.py`` script to install it yourself::

    $ git clone https://github.com/PyMamba/mamba-framework.git
    $ cd mamba-framework
    $ mkvirtualenv --no-site-packages -p /usr/bin/pypy --prompt='(mamba-dev-pypy) ' mamba-dev-pypy
    $ pip install -r requirements.txt
    $ ./tests
    $ python setup.py install

.. warning::

    The Mamba |repo| is under heavy development, we do not guarantee the stability of the Mamba in-development version.

.. _Using Mamba:

Using Mamba
-----------

Once you have Mamba installed in your system, you should be able to generate a new project using the ``mamba-admin`` command line tool.

**Enjoy it!**

|
