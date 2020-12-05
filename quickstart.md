# Quickstart

1. `docker-compose up -d` to download the Docker images and start the containers
2. `docker exec -it postgres bash` to open a Bash on the Postgres container
3. `cd /home/curious` to browse the mounted directory with the make file and raw CSV data
4. `make import_master_plan` to import the master plan data into the _enceladus_ database
5. `localhost:5050` to open a pgAdmin window on the Docker host machine (your local machine)
6. login with `user@example.com` and `123456` to login to the pgAdmin
7. create a server connection to the Postgres server using `postgres:5432` and `user@example.com` with `mysecretpassword` to browse the _enceladus_ database