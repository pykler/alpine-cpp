FROM alpine:latest

VOLUME "/project"

WORKDIR "/project"

ENV BASH_ENV=/etc/profile

# remember to keep package list sorted
RUN echo "  ---> Install packages" \
    && apk update \
    && apk upgrade \
    && apk --update add \
        bash \
        build-base \
        cmake \
        cppcheck \
        g++ \
        gcc \
        libstdc++ \
        python3 \
    && echo "  ---> Install python3 pip" \
    && python3 -m ensurepip \
    && rm -r /usr/lib/python*/ensurepip \
    && pip3 install --no-cache --upgrade pip setuptools wheel \
    && if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi \
    && echo "  ---> Install conan via python3 pip" \
    && pip install conan \
    && echo "  ---> Setup arch dependant settings" \
    && if [ $(getconf LONG_BIT) -eq 32 ]; then echo "export CONAN_ENV_ARCH="x86"" > /etc/profile.d/conanx86.sh ; fi \
    && echo "  ---> Cleaning cache" \
    && rm -rf /var/cache/apk/* \
    && echo "  ---> RUN complete"

ENTRYPOINT [ "bash", "-c" ]
