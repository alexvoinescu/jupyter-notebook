# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
FROM jupyter/scipy-notebook

LABEL maintainer="Alexandru Voinescu <voinescu.alex@gmail.com>"
#This is a mess

USER $NB_UID

RUN conda update --all
RUN python --version

RUN conda install python=3.7 anaconda=custom
RUN python --version

RUN conda install -c bioconda mysqlclient 
RUN conda install -c conda-forge jupyter_contrib_nbextensions

USER root

RUN jupyter contrib nbextension install --system
RUN jupyter contrib nbextension install --user

RUN jupyter nbextension enable --py widgetsnbextension --sys-prefix

RUN jupyter nbextensions_configurator enable --system
RUN jupyter nbextensions_configurator enable --user

USER $NB_UID

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME /home/$NB_USER/.cache/
#RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot"
RUN fix-permissions /home/$NB_USER

RUN python --version
