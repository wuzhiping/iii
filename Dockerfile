FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y jq redis-server vim supervisor python3-pip wget curl netcat-openbsd unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


RUN curl -fsSL https://install.iii.dev/iii/main/install.sh | sh
ENV PATH="/root/.local/bin:$PATH"
RUN iii --version

COPY ./supervisord.conf /src/supervisord.conf
COPY ./wait-for-it.sh /src/wait-for-it.sh

COPY ./nats.conf /src/nats.conf
ADD  ./nats/ /src/nats
COPY ./temporal /src/temporal
COPY ./temporal.toml /src/temporal.toml

RUN pip install jupyterlab uv -i https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple
RUN pip install -U ipywidgets  -i https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple
RUN pip install fastapi nats-py redis gunicorn uvicorn temporalio tqdm aiohttp requests  -i https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple
RUN pip install iii-sdk

WORKDIR /src
COPY worker.py /src/worker.py
COPY config.yaml /src/config.yaml

RUN iii worker add iii-pubsub

RUN iii worker add harness

EXPOSE 49134 3111 3112 9464

COPY caddy /src/caddy
COPY Caddyfile /src/Caddyfile

CMD ["/usr/bin/supervisord", "-n","-c", "/src/supervisord.conf"]
