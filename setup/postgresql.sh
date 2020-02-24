# instructions to install PostgreSQL 11 on an Ubuntu server

# create the file /etc/apt/sources.list.d/pgdg.list  and add the following line
# deb http://apt.postgresql.org/pub/repos/apt/ YOUR_UBUNTU_VERSION_HERE-pgdg main
deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main


# import the repository signing key
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -


# update packages on server
sudo apt-get update


# install DB
sudo apt-get install postgresql-11


# additional packages
sudo apt-get install libpq-dev


# db ready, now connect and create user and db and tables
sudo -u postgres -i


# enter db environment 
psql
