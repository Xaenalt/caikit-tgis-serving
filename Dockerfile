FROM quay.io/opendatahub/text-generation-inference:fast-836fa5f

USER root

WORKDIR /caikit
COPY caikit /caikit

# git-lfs and grpcurl are used for smoke test, but feels like it'd be useful to have, maybe split to a second dockerfile for testing if not
RUN yum -y install git git-lfs && yum clean all && \
    git lfs install && \
    curl -sL https://github.com/fullstorydev/grpcurl/releases/download/v1.8.7/grpcurl_1.8.7_linux_x86_64.tar.gz | tar zxvf - -C /bin grpcurl && \
    pip install pipenv && \
    pipenv install --system && \
    rm -rf ~/.cache && \
    mkdir -p /opt/models && \
    adduser -g 0 -u 1001 caikit --home-dir /caikit && \
    chown -R 1001:0 /caikit /opt/models && \
    chmod -R g=u /caikit /opt/models

USER 1001

ENV RUNTIME_LIBRARY='caikit_nlp' \
    RUNTIME_LOCAL_MODELS_DIR='/opt/models'

CMD [ "./start-serving.sh" ]
