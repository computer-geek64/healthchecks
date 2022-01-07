#!/bin/sh
# db_env_init.sh

export DB_HOST=$(python -c 'import os; print(os.environ["DATABASE_URL"].split("@", 1)[1].split(":", 1)[0])')
export DB_NAME=$(python -c 'import os; print(os.environ["DATABASE_URL"].rsplit(":", 1)[1].split("/", 1)[1])')
export DB_USER=$(python -c 'import os; print(os.environ["DATABASE_URL"].split("://", 1)[1].split(":", 1)[0])')
export DB_PASSWORD=$(python -c 'import os; print(os.environ["DATABASE_URL"].split("://", 1)[1].split(":", 1)[1].split("@", 1)[0])')
export DB_PORT=$(python -c 'import os; print(os.environ["DATABASE_URL"].rsplit(":", 1)[1].split("/", 1)[0])')
