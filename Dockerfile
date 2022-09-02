FROM python:3.9-slim-buster as build-env

RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --disable-pip-version-check --no-cache-dir https://download.pytorch.org/whl/cpu/torch-1.11.0%2Bcpu-cp39-cp39-linux_x86_64.whl \
    https://download.pytorch.org/whl/cpu/torchvision-0.12.0%2Bcpu-cp39-cp39-linux_x86_64.whl \
    https://files.pythonhosted.org/packages/72/ed/358a8bc5685c31c0fe7765351b202cf6a8c087893b5d2d64f63c950f8beb/timm-0.6.7-py3-none-any.whl 

RUN rm -rf /opt/venv/bin/pip* && \
    rm -rf /opt/venv/bin/*-info 

FROM gcr.io/distroless/python3-debian11
COPY inference.py /usr/app/
WORKDIR /usr/app 
ENV PYTHONPATH /usr/app

COPY --from=build-env /opt/venv/lib/python3.9/site-packages /usr/app

ENTRYPOINT [ "python3", "/usr/app/inference.py" ]

# ENTRYPOINT [ "/venv/bin/python3", "inference.py" ]

# FROM gcr.io/distroless/python3

# COPY --from=build-env /usr/src/app /app

# WORKDIR /app
# FROM debian:11-slim AS build-env

# WORKDIR /usr/src/app

# RUN apt-get update && \
#     apt-get install  --no-install-suggests --no-install-recommends --yes python3-venv gcc libpython3-dev && \
#     python3 -m venv venv && \
#     venv/bin/pip install --no-cache-dir --upgrade pip setuptools wheel && \
#     rm -rf /var/lib/{apt,dpkg,cache,log}/


# RUN  venv/bin/pip install --no-cache-dir https://download.pytorch.org/whl/cpu/torch-1.12.1%2Bcpu-cp39-cp39-linux_x86_64.whl && \
#      venv/bin/pip install --no-cache-dir timm  

# COPY . .
