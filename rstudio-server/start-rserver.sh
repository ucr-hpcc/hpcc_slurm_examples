#!/bin/bash -l

# Load rstudio-server
module load rstudio-server

# Get script directory and go there
CWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# Setup user-specific secure cookie key
USER=`whoami`
COOKIE_KEY_PATH=/tmp/${USER}_secure-cookie-key
rm -f $COOKIE_KEY_PATH
mkdir -p $(dirname $COOKIE_KEY_PATH)

#python -c 'import uuid; print(uuid.uuid4())' > $COOKIE_KEY_PATH
uuid > $COOKIE_KEY_PATH
chmod 600 $COOKIE_KEY_PATH

export RETICULATE_PYTHON=$(which python)

# Generate password
export RSTUDIO_PASSWORD=$(date +%s | sha256sum | base64 | head -c 16 ; echo)

# Get random port
PORT=$(shuf -i8000-9999 -n1)

# Print info
echo -e "\nSetup your tunnel like so:
\tssh -NL $PORT:$HOSTNAME:$PORT $USER@cluster.hpcc.ucr.edu
This command will hang, it does not produce any output.

Next open your internet browser to:
\thttp://localhost:$PORT

Use the following credentials to login:
\tusername: $USER
\tpassword: $RSTUDIO_PASSWORD

For more information regarding SSH tunnels, vists here:
\thttps://hpcc.ucr.edu/manuals_linux-cluster_jobs.html#web-browser-access

For help please email: support@hpcc.ucr.edu

Now running RStudio Server...
"

RSTUDIO_PASSWORD=$RSTUDIO_PASSWORD rserver \
  --server-daemonize=0 \
  --rsession-path="$CWD/rsession.sh" \
  --secure-cookie-key-file=$COOKIE_KEY_PATH \
  --auth-encrypt-password=1 \
  --rsession-which-r=$(which R) \
  --www-port=$PORT \
  --auth-none=0 \
  --auth-pam-helper="$CWD/rstudio_auth" \

