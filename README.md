Run code without native installation


# Getting start

## Setup environment
```bash
docker login
source setup.bash

# Build docker image
dbuild DockerfilePath tagname

# Start contianer (Intel GPU)
drunintel tseanliu/docker_env_gui:ubuntu18_melodic u18_melodic

# Start contianer (Nvidia GPU)
drunnvidia tseanliu/docker_env_gui:ubuntu18_melodic u18_melodic

# Login into container
dexec u18_melodic

# Stop and remove container
drm u18_melodic
```
