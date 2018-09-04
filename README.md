# Populate DTR
Simple bash script in a container for populating a Docker Trusted Registry (DTR) for testing.

## Usage
~~~
docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock \
    squizzi/populate-dtr \
    -u <username> \
    -p <password> \
    -H <hostname>
~~~

If desired, defaults can also be configured manually in the script by modifying 
the following blocks:

```
# Populate commonly used defaults if they aren't already set
if [ -z "DTR_USER" ]; then
    DTR_USER="admin"
    echo -e "Using default username: $DTR_USER"
fi

if [ -z "DTR_PASSWORD" ]; then
    DTR_PASSWORD="foobarfun"
    echo -e "Using default password: $DTR_PASSWORD"
fi
```

