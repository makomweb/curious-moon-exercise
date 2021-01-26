# Quickstart

1. build the Docker images `docker compose build`
    - or `docker-compose build db` to build the database image alone 
2. `docker-compose up -d` to download the Docker images and start the containers
3. `docker exec -it postgres bash` to open a _Bash_ on the _Postgres_ container
4. `cd /home/curious` to browse the mounted directory with the make file and raw CSV data
5. `make import_master_plan` to import the master plan data into the _enceladus_ database
6. `localhost:5050` to open a _pgAdmin_ window on the _Docker_ host machine (your local machine)
7. login with `user@example.com` and `123456` to login to the _pgAdmin_
8. create a server connection to the _Postgres_ server using `curious_db:5432` and `user@example.com` with `mysecretpassword` to browse the _enceladus_ database