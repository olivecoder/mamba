# -*- encoding: utf-8 -*-
# -*- mamba-file-type: mamba-model -*-
# Copyright (c) ${year} - ${author} <${author_email}>

"""
.. model:: ${model_name}
    :plarform: ${platforms}
    :synopsis: ${synopsis}

.. modelauthor:: ${author} <${author_email}>
"""

# it's better if you remove this star import and import just what you
# really need from mamba.enterprise
from mamba.enterprise import *

from mamba.application import model


class ${model_class}(model.Model):
    """
    ${synopsis}
    """

    __storm_table__ = '${model_table}'
    ${class_properties}
    ${model_properties}
