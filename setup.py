from setuptools import setup, Extension
from Cython.Build import cythonize
import numpy
setup(
    name='graphlet',
    author='Kexing Zhou',
    author_emial='zhoukexing@pku.edu.cn',
    description='python wrapper for orca',
    install_requires=['numpy'],
    setup_requires=['cython'],
    ext_modules=cythonize(Extension(
        'graphlet',
        sources=['graphlet.pyx'],
        language='c++',
        include_dirs=[numpy.get_include()],
        library_dirs=[],
        libraries=[],
        extra_link_args=[],
        extra_compile_args=['-Wno-cpp', '-Wno-unused-variable']
    ))
)