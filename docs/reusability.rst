.. _reusability:

Mamba reusability
=================

Mamba applications, controllers, templates, models and components can be reused all packed in an importable application using the Mamba reusability system.

The motivation for supporting this system in mamba is pretty straightforward, as Python developers, sometimes we need a common feature like being able to send emails to our users using some type of SMTP service in our applications. Mamba itself is not able to send emails because it doesn't know how to do it, this is an implementation design decision as we think sending emails is not part of the responsabilities of the framework but it's a pretty standard need for several web related projects, but not all.

The need to reuse the same type of features in several of our projects show us the importance to add some way of easy-code-reusability system in mamba, and now here we are.

How it works?
-------------

Mamba is able to include and reuse applications and components from and to your applications using the Mamba packaging system.

Although we are allowed to reuse any Python application just adding a package directly inside our `application` directory (and it works and has nothing wrong), Mamba uses the `mamba-admin` command line tool to package Mamba-based applications and create reusable Mamba packages. These packages can then be installed globally or per-user using `mamba-admin package` subcommand.

Installing an application
~~~~~~~~~~~~~~~~~~~~~~~~~

When we are happy with our reusable application code we can then make it shareable between Mamba applications using the `package` system but we have to fit some requirements first:

    * Your application root **must** contain a `docs` directory (with documentation about your shared package)
    * Your application root **must** contain a `LICENSE` and `README.rst` files on it
    * Your application **must** be error-free as it is going to be compiled by Mamba packaging script

When we fit all those requirements we can just use the `mamba-admin package` command line to *pack* or *install* our application::

    $ mamba-admin package install -g

|

The above command will install the mamba application directly to the global `site-package` of our Python installation. If we can't install our application directly in the global `site-package` maybe because we don't have root access and we are not running into a `virtualenv` environment we can install the package in the `user site-package` using the `-u` option instead of `-g`. Obviously we can't use both options at the same time.

.. _packing-an-application:

Packing an application
~~~~~~~~~~~~~~~~~~~~~~

The goal of packing a Mamba application is *not* to distribute it as a standalone Mamba full application. Mamba packing system doesn't intend to be a replacement for distribute/setuptools/distutils/distutils2 in any way. If what you want to do is create a full Mamba installable package ready to distribute with others using `pip` or similar you better go to this (unofficial) `Guide to Packaging using distribute <http://guide.python-distribute.org/>`_ or `Distributing Python Modules  <http://docs.python.org/2/distutils/index.html>`_ from the official documentation.

Sometimes what we want to do is just pack our application to share with others or to perform a *fine tuning* on it. The `mamba-admin package` command line tool adds a subcommand to pack our application in both `.tar.gz` and `.egg` format so we can just share it with other or decompress it and perform all the changes we need to the `setup.py` file and the application structure just using it as a *valid mamba package* template before to share it.

The `pack` subcommand is used to this task and it accepts exactly the same parameters than install does except those that are specific for define the installation location (`-g` and `-u`) and adds the `-e` and `-c` one as well in order to generate an `.egg` distribution package and adds the `config` directory into the packed file if neccesary.

To pack an application we just run `mamba-admin` command line tool inside the directory of the appliction we want to pack (note that the same requirements than with the `install` command are applied here as well)::

    $ mamba-admin package pack

The above command will create a `mamba-<app_name>-<version>.tar.gz` file in the root directory of our application.

Installing packed applications
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Install a previously packed application use the same syntax and command that install the application directly but adding the file path as the last argument::

    $ mamnba-admin package install -g mamba-<app_name>-<version>.tar.gz

This will install the given file in the global `site-packages` of our Python installation.


How I use it?
-------------

After install a mamba application we can just add it totally or parcially into another application using the configuration file `installed_packages.json`::

    {
        "packages": {
            "dummy_example": {
                "autoimport": true,
                "use_scripts": true
            }
        }
    }

If `"autoimport"` is set as `true`, Mamba will add and register controllers from the installed package into our local application. That means if the installed package have a controller called `contact` our application is going to import and register it and all it's routes into our application. So if for example our imported package has a controller registered on route `/shop` we can just navigate to `http://localhost:1936/shop` in our new application and we will get the `shop` controller rendered page (maybe we should add some database configuration if the shared package needs it, just read the documentation on the shared package to discover what we need to set in our application to make the package work).

If we create a new controller called `contact` in our `application/controller` directory, then our new controller will hide and replace  the shared one but already registered routes will be available and this can raise an exception in the best of the cases, in the worst the application may seems to be working fine but strange behaviours are expected so be careful with this. You **have to** extend your controller from the shared one in order to don't have problems with that.

If you really need to extend the imported packages controllers, is maybe better if the `"autoimport"` option is just set as `false` and you extend whatever controller that you need. An example of a controller `contact` from an application called `dummy` extension is as follow:

.. sourcecode:: python

    # -*- encoding: utf-8 -*-
    # -*- mamba-file-type: mamba-controller -*-
    # Copyright (c) 2013 - Oscar Campos <oscar.campos@member.fsf.org>

    """
    .. controller:: Shared
        :platform: Unix, Windows
        :synopsis: Shared Controller

    .. controllerauthor:: Oscar Campos <oscar.campos@member.fsf.org>
    """

    from mamba.application import route

    from dummy.controller.contact import Contact

    class Shared(Contact):
        """
        Shared Controller
        """

        name = 'Shared'
        __route__ = 'contact'

        def __init__(self):
            """
            Put your initialization code here
            """
            super(Shared, self).__init__()

        @route('/')
        def root(self, request, **kwargs):
            return super(Shared, self).root()(request, **kwargs)

Note how in the previous code, we are calling the function returned by `super(Shared, self).root()` that means, we are calling the wrapped function `root` from the shared controller `Contact` bypassing its own `@route` decorator, if we dont do that, we should get a 500 error because recursion depth exceeded as we are calling the `Contact` `@route` decorator instead of the real `root` method.

If `use_scripts` is set as `true`, Mamba will include all the scripts from the shared package in the `scripts` and `stylesheets` **mambaerized** resources so they are totally available into your application. You can override them by creating you own scripts with the same name in your `application/view/scripts` and `application/view/stylesheets` directories.

The same is applicable for shared templates and scripts in controller sub-directories.

In the other hand, shared templates are always included in the `Jinja2` search path so them are always available in our application. If we need to override a shared template we just have to create a template in our `application/view/templates` or `application/view/<controller>` directories and Mamba will use those instead of the shared ones.

Assets included in the `static` directory of the shared package are always available in our application `assets/` route as well. If we need to override one of them, just create a new file in our application `static` directory with the same name as the asset that we want to override.

Models
~~~~~~

Models are always available, does not matters if autoimport is set as true or false, we can use them like:

.. sourcecode:: python

    from dummy.model.some_model import SomeModel

    some1 = SomeModel()

Is always better if you subclass the shared models into your own application models, in this way you can generate the SQL schema and perform other mainteance tasks like database dump:

.. sourcecode:: python

    from dummy.model.some_model import SomeModel as SharedSomeModel


    class SomeModel(SharedSomeMode):
        """Just a subclass of the shared model to make it available
        """


|
|