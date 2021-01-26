# My notes about: A Curious Moon by Rob Conery

This repository contains the implementation I did while reading the book. All SQL queries as well as a description **how to setup everything on Windows 10 using Docker** are also part of this repository.

A Curious Moon by Rob Conery.

![cover](./images/cover.png)

- Website: [https://bigmachine.io/products/a-curious-moon/](https://bigmachine.io/products/a-curious-moon/)
- Github: [https://github.com/red-4/curious-moon](https://github.com/red-4/curious-moon)

---

## [Quickstart](./quickstart.md)

1. build the Docker images `docker compose build`
    - or `docker-compose build db` to build the database image alone 
2. `docker-compose up -d` to download the Docker images and start the containers
3. `docker exec -it postgres bash` to open a _Bash_ on the _Postgres_ container
4. `cd /home/curious` to browse the mounted directory with the make file and raw CSV data
5. `make import_master_plan` to import the master plan data into the _enceladus_ database
6. `localhost:5050` to open a _pgAdmin_ window on the _Docker_ host machine (your local machine)
7. login with `user@example.com` and `123456` to login to the _pgAdmin_
8. create a server connection to the _Postgres_ server using `curious_db:5432` and `user@example.com` with `mysecretpassword` to browse the _enceladus_ database

---

## Docker preparation

I have used Docker for Windows: [https://docs.docker.com/docker-for-windows/install/](https://docs.docker.com/docker-for-windows/install/).

### Using Docker Compose ...

To work with the _Docker_ image I have created a *docker-compose.yaml* file. 
Visiting this file you will notice that the container port `5432` is mounted to the default _Postgres_ port `5432`.
You will also notice the credentials how to access the database - e.g. with [pgAdmin](https://www.pgadmin.org/).
The configuration file mounts a directory `c:\Workspace\curious-moon-exercise` into the container. This is also where I keep this git-Repo locally.
This way you can edit files using the familiar editing tools - e.g. _Visual Studio Code_ and _Git_.
Feel free to adjust the configuration to your needs.

Run `docker-compose up -d` to start the container in the background. 

### ... or run Docker manually

Pull the [Postgres Docker image](https://hub.docker.com/_/postgres).

I decided to use a shared folder (between the Windows Host and the Docker container) to store the implementation files.

`docker run --volume ./curious:/home/curious -d -p 5432:5432 --name curious-moon-exercise -e POSTGRES_PASSWORD=mysecretpassword postgres`

If you want to run the Docker container without the mounted folder you can use the following command:

`docker run -d -p 5432:5432 --name curious-moon-exercise -e POSTGRES_PASSWORD=mysecretpassword postgres`

### Alternative Docker image

Alternatively you can use the *Docker* image which combines **PostgreSQL 13.1** and **GNU Make 4.2.1**.

[https://registry.hub.docker.com/r/makomweb/images/tags](https://registry.hub.docker.com/r/makomweb/images/tags)

Replace the official *Postgres* image in your `docker-compose.yaml` file:

~~~yaml
#image: postgres
image: makomweb/images:postgres-13.1-with-make-4.2.1
~~~

After that run `docker-compose up -d` to download the image and start the container.

## Starting a Bash on the Docker container

Once the Postgres database is running you can start with the exercise.

`docker exec -it postgres bash` opens a _Bash_ on the container.
Make sure you use the correct container name here.

### Install Make on the container

We will need *Make* to do the exercise.

~~~
Note:
If you are running the alternative Docker image it is not necessary to install *Make*.
It already comes with it preinstalled.
~~~

`apt-get update -y` to update the *APT* catalogs.

`apt-get install -y make` to install _Make_.

## Get the Cassini RAW data

Download the raw data from [http://archive.redfour.io/cassini/cassini_data.zip](http://archive.redfour.io/cassini/cassini_data.zip). To begin with I am only interested in the `master_plan.csv` file. The other files `cda.csv`, `inms.csv`, `jpl_flybys.csv`, and `chem_data.csv` will also be necessary later.

## Use PGAdmin to connect to the database

The _docker-compose.yaml_ file contains a pgAdmin container additionally.

Open the browser on your host machine (your local machine) and visit [http://localhost:5050](http://localhost:5050). Use the email `user@example.com` with the password `123456` to login to pgAdmin

Make a new server connection `postgres` with port `5432` and username `postgres` and password `mysecretpassword`.

Name the connection `Curious-Moon-Enceladus`.

## Create a Database using PSQL

Open a *Bash* on the *Docker* container.

`psql -U postgres` to open the Postgres shell (PSQL) for the user `postgres` to type SQL commands directly.

E.g. `create database enceladus;` to create a database if it is not there yet (e.g. if it was dropped before)

Type `\q` to exit Postgres shell (PSQL).

## Images

I really liked Dee's drawings to make things clearer - that's why I drew them myself.

### Cosmic dust analyzer (CDA)

![cda](./images/cda.png)

### Ion and Neutral Mass Spectrometer (INMS)

![inms](./images/inms.png)