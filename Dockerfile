# Dockerfile
FROM python:3.8

RUN apt-get update
RUN apt-get install -y gcc cron uuid-runtime

WORKDIR /code
RUN git clone https://github.com/healthchecks/healthchecks

RUN pip install --upgrade pip
RUN pip install wheel
RUN pip install -r healthchecks/requirements.txt

COPY src .
RUN chmod 644 healthchecks_cleanup.cron
RUN cp healthchecks_cleanup.cron /etc/cron.d/healthchecks_cleanup.cron
RUN crontab /etc/cron.d/healthchecks_cleanup.cron

ENV DEBUG=False
ENV SITE_NAME=Healthchecks
ENV SITE_ROOT=https://myhealthchecks.herokuapp.com
ENV REGISTRATION_OPEN=False
ENV DB=postgres

ARG email_use_tls=True
ENV EMAIL_USE_TLS=${email_use_tls}
ARG email_port=587
ENV EMAIL_PORT=${email_port}
ARG email_host=smtp.gmail.com
ENV EMAIL_HOST=${email_host}
ARG email_host_user
ENV EMAIL_HOST_USER=${email_host_user}
ARG email_host_password
ENV EMAIL_HOST_PASSWORD=${email_host_password}

ARG username
ARG password
ARG database_url

RUN echo "CSRF_TRUSTED_ORIGINS = ['${SITE_ROOT}']" >> healthchecks/hc/settings.py

RUN export DATABASE_URL=${database_url} && . ./db_env_init.sh && healthchecks/manage.py migrate
RUN export DATABASE_URL=${database_url} && . ./db_env_init.sh && healthchecks/manage.py compress
RUN export DATABASE_URL=${database_url} && . ./db_env_init.sh && echo yes | healthchecks/manage.py collectstatic

RUN export DATABASE_URL=${database_url} && . ./db_env_init.sh && echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('${username}', '${username}', '${password}')" | healthchecks/manage.py shell

ENTRYPOINT ["./init.sh"]
