#!/bin/sh
# init.sh

export SECRET_KEY="$(uuidgen -r)"
cron
healthchecks/manage.py sendalerts &
healthchecks/manage.py runserver "0.0.0.0:${PORT}"
