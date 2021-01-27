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
3. download the RAW cassini data from [Redfour](http://archive.redfour.io/cassini/cassini_data.zip)
4. store the files under `./curious/data`
5. `docker exec -it curious_db bash` to open a _Bash_ on the _Postgres_ container
6. `cd /home/curious` to browse the mounted directory with the make file and raw CSV data
7. `make import_master_plan` to import the master plan data into the _enceladus_ database
8. `localhost:5050` to open a _pgAdmin_ window on the _Docker_ host machine (your local machine)
9. login with `user@example.com` and `123456` to login to the _pgAdmin_
10. create a server connection to the _Postgres_ server using `curious_db:5432` and `user@example.com` with `mysecretpassword` to browse the _enceladus_ database

## Get the Cassini RAW data

Download the raw data from [http://archive.redfour.io/cassini/cassini_data.zip](http://archive.redfour.io/cassini/cassini_data.zip). To begin with I am only interested in the `master_plan.csv` file. The other files `cda.csv`, `inms.csv`, `jpl_flybys.csv`, and `chem_data.csv` will also be necessary later.

## Use PGAdmin to connect to the database

The _docker-compose.yaml_ file contains a pgAdmin container additionally.

Open the browser on your host machine (your local machine) and visit [http://localhost:5050](http://localhost:5050). Use the email `user@example.com` with the password `123456` to login to pgAdmin

Make a new server connection `curious_db` with port `5432` and username `postgres` and password `mysecretpassword`.

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