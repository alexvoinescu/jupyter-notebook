# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
FROM jupyter/scipy-notebook

LABEL maintainer="Alexandru Voinescu <voinescu.alex@gmail.com>"

USER $NB_UID

RUN conda update --all
RUN python --version

RUN conda install python=3.7 anaconda=custom
RUN python --version

RUN conda install -c conda-forge mysqlclient 
RUN conda install -c conda-forge jupyter_contrib_nbextensions
RUN conda install -c conda-forge numpy
RUN conda install -c conda-forge xlsxwriter
RUN conda install -c conda-forge plotly 
RUN conda install -c conda-forge requests
RUN conda install -c jmcmurray json 
RUN conda install -c conda-forge time
RUN conda install -c conda-forge ipython
RUN conda install tornado=5.1.1
RUN conda install -c conda-forge matplotlib 
RUN conda install -c conda-forge beakerx
RUN conda install -c conda-forge ipywidgets
 
RUN pip install DateTime
RUN pip install random2

RUN conda install -c conda-forge certifi 
RUN conda install -c conda-forge chardet 
RUN conda install -c conda-forge cycler
RUN conda install -c conda-forge cython
RUN conda install -c conda-forge et_xmlfile 
RUN conda install -c conda-forge idna
RUN conda install -c conda-forge jdcal
RUN conda install -c conda-forge numexpr 
RUN conda install -c conda-forge numpy 
RUN conda install -c conda-forge openpyxl
RUN conda install -c conda-forge pandas
RUN conda install -c conda-forge patsy
RUN conda install -c conda-forge pyparsing
RUN conda install -c conda-forge python-dateutil
RUN conda install -c conda-forge pytz
RUN conda install -c conda-forge scipy
RUN conda install -c conda-forge six
RUN conda install -c conda-forge statsmodels
RUN conda install -c conda-forge typing
RUN conda install -c conda-forge urllib3
RUN conda install -c conda-forge xlrd
RUN conda install -c conda-forge xlsxwriter
RUN conda install -c conda-forge decorator

USER root

RUN jupyter contrib nbextension install --system
RUN jupyter contrib nbextension install --user

RUN jupyter nbextension enable --py widgetsnbextension --sys-prefix

RUN jupyter nbextensions_configurator enable --system
RUN jupyter nbextensions_configurator enable --user

USER $NB_UID

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME /home/$NB_USER/.cache/
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot"
RUN fix-permissions /home/$NB_USER

RUN python --version

RUN pip install IP2Location
RUN pip install tqdm
RUN pip install boto3

RUN pip install --upgrade snowflake-connector-python

