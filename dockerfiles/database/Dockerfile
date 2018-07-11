# Pull base image.
FROM mongo

## Define mountable directories.
## VOLUME ["/data/db"] 
#^ This should only be done if updates are considered destructive
#^ https://github.com/moby/moby/issues/30647 Persistent db's are
#^ supposed to be constructed from named volumes in docker-compose.yml

# Define working directory.
WORKDIR /data

# Define default command.
CMD ["mongod"]

# Expose ports.
#   - 27017: process
#   - 28017: http
EXPOSE 27017
EXPOSE 28017
