#!/usr/bin/env python

from setuptools import setup, find_packages

setup(
    name='REPL_GEN',
    version='0.1',
    description="Ripples Data Generator",
    packages = find_packages(
        # include=['ocr', 'api'],
        exclude=["*.tests", "*.tests.*", "tests.*", "tests"]),
    install_requires=[
        'scipy==0.19.1',
        'plotly==2.0.0',
        'pytest==3.1.3',
        'pytest-cov==2.5.1',
        'pytest-xdist==1.20.1',
        'Pillow==4.2.1',
        'editdistance==0.3.1',
        'pandas==0.20.3',
        'opencv-python==3.3.0.9',
        'opencv-contrib-python==3.3.0.9',
        'scikit-image==0.13.1',
        'pytz==2017.2',
        'imgaug==0.2.5',
        'beautifulsoup4==4.6.0',
        'requests==2.18.1',
        'seaborn==0.8.1',
        'torch==0.4.0',
        'click==6.7',
        ],
    extras_require={
        'cpu': [
            'tensorflow==1.8.0',
        ],
        'gpu': [
            'tensorflow-gpu==1.8.0',
        ],
    },
       dependency_links=[
           'https://download.pytorch.org/whl/cu80/torch-0.4.0-cp36-cp36m-linux_x86_64.whl#egg=torch-0.4.0',
       ]
)
