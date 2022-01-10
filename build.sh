#! /bin/bash
builder=$1
docker buildx prune -af --builder $builder > /dev/null 2>&1
docker rmi layer_test:latest > /dev/null 2>&1 
docker buildx build --builder $builder -q --tag layer_test:latest --cache-from localhost:5000/layer_test:latest --cache-to=type=inline --load .