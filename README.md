# A Curious Moon by Rob Conery

This repository contains the implementation I did while reading the book

A Curious Moon by Rob Conery. 

- Website: [https://bigmachine.io/products/a-curious-moon/](https://bigmachine.io/products/a-curious-moon/)
- Github: [https://github.com/red-4/curious-moon](https://github.com/red-4/curious-moon)

## Preparation

I have used Docker for Windows: [https://docs.docker.com/docker-for-windows/install/](https://docs.docker.com/docker-for-windows/install/).

And used the Postgres Docker image from here: [https://hub.docker.com/_/postgres](https://hub.docker.com/_/postgres)

I decided to use a shared folder (between the Windows Host and the Docker Container) to store the implementation files.

The advantage is that I can use VSCode and the Git tools I am familiar with - without additional installation steps.

## Starting the Docker container

`$ docker run -d -p 5432:5432 --name curious-moon-postgres -e POSTGRES_PASSWORD=mysecretpassword postgres`

Prefer the command with the mounted shared folder:

`docker run --volume //c/Workspace/curious-moon-exercise:/home/curious -d -p 5432:5432 --name curious-moon-postgres -e POSTGRES_PASSWORD=mysecretpassword postgres`

## Starting a Bash on the Docker container

`docker exec -it curious-moon-postgres bash`

## Install make

`sudo apt-get update -y` to update the catalogs.

`sudo apt-get intall -y make` to install _make_.

## Get the Cassini RAW data

Download the raw data from [archive.redfour.io/cassini/cassini_data.zip](archive.redfour.io/cassini/cassini_data.zip). To begin with I am only interested in the `master_plan.csv` file.

## Use PGAdmin to connect to the database

Make a new server connection `localhost` with port `5432` and username `postgres` and password `mysecretpassword`.

Name the connection `Curious-Moon-Enceladus`.

## Create a Database using PSQL

Open a Bash on the docker container.

Run `psql -U postgres`.

Run `create database enceladus;`.

Type `\q` to exit PSQL shell