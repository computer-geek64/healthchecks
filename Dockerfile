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

RUN echo "CSRF_TRUSTED_ORIGINS = ['https://myhealthchecks.herokuapp.com']" >> healthchecks/hc/settings.py

ENV DEBUG=False
ENV SITE_NAME=Healthchecks
ENV REGISTRATION_OPEN=False
ARG username
ARG password

RUN healthchecks/manage.py migrate
RUN healthchecks/manage.py compress
RUN echo yes | healthchecks/manage.py collectstatic

RUN echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('${username}', '${username}', '${password}')" | healthchecks/manage.py shell

ENTRYPOINT ["./init.sh"]
