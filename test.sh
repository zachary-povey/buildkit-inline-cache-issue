#! /bin/bash
set -e

version=$1
builder=default
if [ "${version}" != "default" ] 
then
	./create-builder.sh $version
	builder=v${version}
fi

# Cleanup
docker stop registry > /dev/null 2>&1 || true
docker rm registry > /dev/null 2>&1 || true
docker rmi localhost:5000/layer_test:latest > /dev/null 2>&1 || true

echo "Starting a fresh local registry..."
docker run -d -p 5000:5000 --restart=always --name registry registry:2 > /dev/null

echo "Building the first time..."
./build.sh $builder

echo "History without remote inline cache:"
docker history layer_test

echo "Pushing to local registry..."
docker tag layer_test:latest localhost:5000/layer_test:latest > /dev/null 
docker push localhost:5000/layer_test:latest > /dev/null

echo "Rerunning build - cache pulls from local registry.."
./build.sh $builder 

echo "History with remote inline cache:"
docker history layer_test

docker buildx rm $builder
docker rmi localhost:5000/layer_test:latest > /dev/null
docker stop registry > /dev/null
docker rm registry > /dev/null