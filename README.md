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

```
$ docker run -d -p 5432:5432 --name my-postgres -e POSTGRES_PASSWORD=mysecretpassword postgres
```

with the mounted shared folder

```
docker run --volume //c/Users/marti/Data:/home/data -d -p 5432:5432 --name my-postgres -e POSTGRES_PASSWORD=mysecretpassword postgres
```

## Starting a Bash on the Docker container

```
docker exec -it my-postgres bash
```

## Install make

`sudo apt-get update -y` to update the catalogs.

`sudo apt-get intall -y make` to install _make_.