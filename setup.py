from setuptools import setup
from codecs import open
from os import path
from greengo import __version__

here = path.abspath(path.dirname(__file__))

with open(path.join(here, 'README.md'), encoding='utf-8') as f:
    long_description = f.read()

setup(
    name='greengo',
    version=__version__,
    description='AWS Greengrass file-based setup tool',
    long_description=long_description,
    long_description_content_type='text/markdown',
    keywords=['AWS', 'IoT', 'Greengrass', 'Lambda'],
    url='http://github.com/akaanirban/greengo',
    author='Dmitri Zimine, Anirban Das',
    author_email='dz_removethis@stackstorm.com, anirban.das.rpi@gmail.com',
    license='MIT',
    packages=['greengo'],
    install_requires=[
        'fire',
        'boto3',
        'botocore',
        'pyyaml'
    ],
    setup_requires=['pytest-runner'],
    tests_require=['pytest', 'mock'],
    entry_points={
        'console_scripts': ['greengo=greengo.greengo:main'],
    },
    zip_safe=False
)
