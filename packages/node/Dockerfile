FROM alpine:3.11.6

WORKDIR /opt/vlang

ENV VVV  /opt/vlang
ENV PATH /opt/vlang:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Add the build dependencies
RUN apk --no-cache add \
    # Git support
    git openssh-client \
    # V-development dependencies
    make musl-dev valgrind clang gcc

RUN apk update
RUN apk add make
RUN apk add libpq
RUN apk add --no-cache openssl-dev sqlite-dev 

RUN mkdir -p /opt/vlang && ln -s /opt/vlang/v /usr/bin/v

# Install custom V version from source
WORKDIR /opt/vlang
RUN git clone https://github.com/vlang/v.git /opt/vlang
RUN make VFLAGS='-cc gcc'
RUN v -version

# Install Source Code
WORKDIR /app/src

COPY /src/ /app/src/

# Final Dependencies before compiling
RUN apk add postgresql-dev

RUN v /app/src/ -o /app/bin

# get config files
WORKDIR /app/monochain/
COPY ./monochain/ /app/monochain/

EXPOSE 8000
EXPOSE 8001

WORKDIR /app
CMD ["/app/bin"]

