FROM python:3.6
MAINTAINER Keisuke Murayama <kemura@microsoft.com>

RUN mkdir -p /code \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /code
COPY requirements.txt .
COPY app .

RUN pip install -r requirements.txt

EXPOSE 8000

COPY init_container.sh /bin/

RUN  \
  echo "root:Docker!" | chpasswd \
  && apt-get update \
  && apt-get install -y --no-install-recommends openssh-server \
  && chmod 755 /bin/init_container.sh 

COPY sshd_config /etc/ssh/

EXPOSE 2222 

CMD ["/bin/init_container.sh"]