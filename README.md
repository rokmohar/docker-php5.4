To build docker images run:

`docker build -t awwa/symfony1.4 .`

To run docker container: 

`docker run -p 2022:22 -p 3306:3306 -p 8080:8080 -t -v /sfproject:/home/sfproject -v /mysql-data:/var/lib/mysql awwa/symfony1.4`
