#!/bin/bash

echo "🧪 Start Bonus Test"

CONTAINER_NAME=emlov2:session-01

## Test build container

RUN_OUT=$(docker build -t $CONTAINER_NAME .)

if [ $? -eq 0 ]; then
	echo "✅ Build container success"
else
	echo "❌ Docker build failed !"
	exit 1
fi

# Test size of container

SIZE=$(docker inspect --format='{{ .Size }}' $CONTAINER_NAME)

# if size < 900 MB then success
MAX_SIZE_BYTES=943718400
if [ $SIZE -lt $MAX_SIZE_BYTES ]; then
	echo "✅ Size of container is $SIZE < 900MB"
else
	echo "❌ Size of container is $SIZE > 900MB"
	exit 1
fi

exit 0