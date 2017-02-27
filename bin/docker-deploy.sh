
name=`cat package.json | jq '.name' | sed 's/"\(.*\)"/\1/'`
repo=`cat package.json | jq '.repository.url' | sed 's/"\(.*\)"/\1/'`
echo $name $repo

docker build -t $name $repo
docker ps -a -q -f "name=/${name}" | xargs -r -n 1 docker rm -f 
docker rm -f `docker ps -q -f name=$name`
docker run --name $name -d \
  --network=host \
  --restart unless-stopped \
  -e NODE_ENV=$NODE_ENV \
  $name