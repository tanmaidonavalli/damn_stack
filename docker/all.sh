#!/bin/bash
rm -rf ../nodejs/node_modules
rm -f ../nodejs/output.log
rm -f ../nodejs/package-lock.json
db=example
did=`docker ps | grep mysql | awk '{print $1}'`
docker exec -it $did sh -c "mysql -ppassword $db"
DIR=`PWD`'/..'
docker create --name mysql57 -p3306:3306 -e MYSQL_ROOT_PASSWORD="password" -v $DIR/mysql:/docker-entrypoint-initdb.d mysql:5.7 >> containers.list
docker create --name webserver -p 80:80 -v $DIR/apache:/usr/local/apache2/htdocs httpd >> containers.list
docker create --name nodeserver -p 8080:8080 -v $DIR/nodejs:/src -w /src -u node -it node sh -c "sleep 10 && node node_modules/nodemon/bin/nodemon server.js > /src/output.log" >> containers.list 
cat containers.list | xargs docker stop 
cat containers.list | xargs docker rm
rm containers.list
./clean.sh
./destroy.sh
./init.sh
./create.sh
./run.sh
sleep 13
touch ../nodejs/server.js
sleep 2
echo "DAMN READY"
cd ../nodejs
npm install mysql express nodemon
touch output.log
cat containers.list | xargs docker start 
cat containers.list | xargs docker stop
