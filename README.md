Run kaibo code without native installation


# Getting start

## Setup environment
```bash
docker login
source setup.bash

# Build docker image
dbuild

# Start contianer (Intel GPU)
drunintel <CONTAINER_NAME>

# Start contianer (Nvidia GPU)
drunnvidia <CONTAINER_NAME>

# Login into container
dlogin <CONTAINER_NAME>

# Stop and remove container
drm <CONTAINER_NAME>
```
