# Upload Dataset to GCS

```

```

# Import Dataset to BigQuery
# Setup Apache Supeset
A project using bigquery, SQL Alchemy, and Python to analyze the OWID Covid-19 Dataset

Add Credentials
```sh
export GOOGLE_APPLICATION_CREDENTIALS="<path_to_json_file>"
```

https://hackersandslackers.com/bigquery-and-sql-databases/

Installing Superset from Scratch

OS Dependencies

Superset stores database connection information in its metadata database. For that purpose, we use the cryptography Python library to encrypt connection passwords. Unfortunately, this library has OS level dependencies.

Debian and Ubuntu

The following command will ensure that the required dependencies are installed:
```sh
apt-get update -y
apt-get install -y build-essential libssl-dev libffi-dev python3-dev python3-pip libsasl2-dev libldap2-dev python3-venv

# Fedora and RHEL-derivative Linux distributions

Install the following packages using the yum package manager:

sudo yum install gcc gcc-c++ libffi-devel python-devel python-pip python-wheel openssl-devel cyrus-sasl-devel openldap-devel
```

# Mac OS X

If you're not on the latest version of OS X, we recommend upgrading because we've found that many issues people have run into are linked to older versions of Mac OS X. After updating, install the latest version of XCode command line tools:

```sh
xcode-select --install
We don't recommend using the system installed Python. Instead, first install the homebrew manager and then run the following commands:

brew install pkg-config libffi openssl python

env LDFLAGS="-L$(brew --prefix openssl)/lib" CFLAGS="-I$(brew --prefix openssl)/include" pip install cryptography==2.4.2
```

Let's also make sure we have the latest version of pip and setuptools:

```sh
pip install --upgrade setuptools pip
pip install dataclasses
```
# Python Virtual Environment

We highly recommend installing Superset inside of a virtual environment. Python ships with virtualenv out of the box but you can install it using:

```sh
pip install virtualenv

# You can create and activate a virtual environment using:
# virtualenv is shipped in Python 3.6+ as venv instead of pyvenv.
# See https://docs.python.org/3.6/library/venv.html
python3 -m venv venv
. venv/bin/activate

echo 'export GOOGLE_APPLICATION_CREDENTIALS="/root/greg-playground-310720-dd81478fc29c.json"' >> ~/.bash_profile

source ~/.bash_profile

pip install pybigquery

Once you activated your virtual environment, all of the Python packages you install or uninstall will be confined to this environment. You can exit the environment by running deactivate on the command line.

Installing and Initializing Superset
First, start by installing apache-superset:

pip install apache-superset
Then, you need to initialize the database:

superset db upgrade
Finish installing by running through the following commands:

# Create an admin user (you will be prompted to set a username, first and last name before setting a password)
```sh
export FLASK_APP=superset
superset fab create-admin

# Load some data to play with
superset load_examples

# Create default roles and permissions
superset init

# To start a development web server on port 8088, use -p to bind to another port
superset run --host=0.0.0.0 -p 8088 --with-threads --reload --debugger
```

https://superset.apache.org/docs/databases/bigquery
