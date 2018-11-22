# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
FROM jupyter/minimal-notebook

LABEL maintainer="Alexandru Voinescu <voinescu.alex@gmail.com>"
#This is a mess
USER root

# libav-tools for matplotlib anim
RUN apt-get update && \
    apt-get install -y --no-install-recommends ffmpeg && \
    apt-get install -y gcc mono-mcs && \
    apt-get install -y unixodbc unixodbc-dev && \
    apt-get install -y libmysqlclient-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER $NB_UID

RUN conda update -n base conda
RUN pip install --upgrade pip

# Install Python 3 packages
# Remove pyqt and qt pulled in for matplotlib since we're only ever going to
# use notebook-friendly backends in these images
RUN conda install --quiet --yes \
    'blas=*=openblas' \
    'ipywidgets' \
    'pandas*' \
    'numexpr' \
    'matplotlib' \
    'scipy' \
    'seaborn' \
    'scikit-learn' \
    'scikit-image' \
    'sympy' \
    'cython' \
    'patsy' \
    'statsmodels' \
    'cloudpickle' \
    'dill' \
    'numba' \
    'bokeh' \
    'sqlalchemy' \
    'hdf5' \
    'h5py' \
    'vincent' \
    'beautifulsoup4=' \
    'protobuf' \
    'xlrd' && \
    conda remove --quiet --yes --force qt pyqt

#RUN conda clean -tipsy && \
    # Activate ipywidgets extension in the environment that runs the notebook server
    # jupyter nbextension enable --py widgetsnbextension --sys-prefix
    # Also activate ipywidgets extension for JupyterLab
    #jupyter labextension install @jupyter-widgets/jupyterlab-manager@^0.37 && \
    #jupyter labextension install jupyterlab_bokeh && \

RUN npm cache clean --force
RUN rm -rf $CONDA_DIR/share/jupyter/lab/staging
RUN rm -rf /home/$NB_USER/.cache/yarn
RUN rm -rf /home/$NB_USER/.node-gyp
RUN fix-permissions $CONDA_DIR
RUN fix-permissions /home/$NB_USER


# Install facets which does not have a pip or conda package at the moment
RUN cd /tmp && \
    git clone https://github.com/PAIR-code/facets.git && \
    cd facets && \
    jupyter nbextension install facets-dist/ --sys-prefix && \
    cd && \
    rm -rf /tmp/facets && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

#Install pyMySql and extensions for notebook
RUN pip install PyMySQL

USER root

RUN pip install --upgrade jupyter_contrib_nbextensions
RUN jupyter contrib nbextension install --system
RUN jupyter contrib nbextension install --user
RUN pip install jupyter_nbextensions_configurator
RUN jupyter nbextensions_configurator enable --system
RUN jupyter nbextensions_configurator enable --user

RUN pip install cython \
                matplotlib \
                python-dateutil \
                pytz \
                pyparsing \
                pandas \
                numpy \
                openpyxl \
                xlrd \
                six \
                numexpr \
                statsmodels \
                requests \
                openpyxl \
                pillow \
                yapf \
                pyodbc \
                mysqlclient \
                autopep8 \
                xlsxwriter \
                pymongo \
                selenium \
                tweepy

RUN conda install -c conda-forge beakerx ipywidgets

RUN conda upgrade notebook

RUN conda install python=3.7 anaconda=custom

RUN python --version

RUN pip install ipywidgets
RUN jupyter nbextension enable --py widgetsnbextension --sys-prefix
RUN jupyter nbextension install facets-dist/ 

RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager
RUN jupyter labextension install jupyterlab_bokeh

USER $NB_UID

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME /home/$NB_USER/.cache/
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" && \
    fix-permissions /home/$NB_USER

USER $NB_UID
