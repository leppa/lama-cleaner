# syntax=docker/dockerfile:1.2

FROM python:3.11-slim

RUN --mount=type=cache,target=/root/.cache pip install --upgrade pip

# For the CPU build set it to --extra-index-url https://download.pytorch.org/whl/cpu
ARG pip_install_torch_extra=""
# xformers need torch 2.0.1
RUN --mount=type=cache,target=/root/.cache pip install torch==2.0.1 torchvision==0.15.2 ${pip_install_torch_extra}

# xformers need torch to be already installed
RUN --mount=type=cache,target=/root/.cache pip install xformers==0.0.22 accelerate

# Version of lama-cleaner from pip
ARG version
RUN --mount=type=cache,target=/root/.cache pip install lama-cleaner==${version}
RUN --mount=type=cache,target=/root/.cache lama-cleaner --install-plugins-package

# Persisent storage for PyTorch and HuggingFace
VOLUME /root/.cache

ADD run-lama-cleaner.sh /usr/bin/

EXPOSE 8080

# Default value for the --device parameter: cuda, cpu, or mps
ARG device=cuda
ENV COMPUTE_DEVICE=${device}

ENV HOST="0.0.0.0"
ENV DEFAULT_MODEL="lama"
ENV ENABLED_FEATURES=""

ENTRYPOINT ["run-lama-cleaner.sh"]
