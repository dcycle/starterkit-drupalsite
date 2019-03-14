echo 'Looking for a domain such as example.local'
ENVFILELOCATION="$BASE/.env"
echo "Looking in $ENVFILELOCATION"
if [ -f "$ENVFILELOCATION" ]; then
  echo "$ENVFILELOCATION exists"
  echo "Looking for variable VIRTUAL_HOST in $ENVFILELOCATION"
  source "$ENVFILELOCATION"
  if [ -z "$VIRTUAL_HOST" ]; then
    echo "VIRTUAL_HOST is not set in $ENVFILELOCATION, setting it to localhost"
    echo 'VIRTUAL_HOST=localhost' >> "$ENVFILELOCATION"
  else
    echo "VIRTUAL_HOST is $VIRTUAL_HOST"
  fi
else
  echo "$ENVFILELOCATION does not exist"
fi
