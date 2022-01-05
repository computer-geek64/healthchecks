#!/bin/sh
# healthchecks_cleanup.sh

/code/healthchecks/manage.py prunenotifications
#/code/healthchecks/manage.py pruneusers
/code/healthchecks/manage.py prunetokenbucket
/code/healthchecks/manage.py pruneflips
