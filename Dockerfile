FROM alpine:3.3

ENV NEW_RELIC_LICENSE_KEY YOUR_LICENSE_KEY
ENV NEW_RELIC_SYSMOND_VERSION 2.3.0.132
ENV GLIBC_VERSION 2.23-r1

RUN apk add --update ca-certificates && \
    wget -q "https://github.com/andyshinn/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk" && \
    apk add --allow-untrusted glibc-${GLIBC_VERSION}.apk && \
    wget https://download.newrelic.com/server_monitor/release/newrelic-sysmond-${NEW_RELIC_SYSMOND_VERSION}-linux.tar.gz && \
    tar xvzf newrelic-sysmond-${NEW_RELIC_SYSMOND_VERSION}-linux.tar.gz && \
    cp newrelic-sysmond-${NEW_RELIC_SYSMOND_VERSION}-linux/daemon/nrsysmond.x64 /usr/sbin/nrsysmond && \
    chmod 755 /usr/sbin/nrsysmond && \
    cp newrelic-sysmond-${NEW_RELIC_SYSMOND_VERSION}-linux/scripts/nrsysmond-config /usr/sbin/ && \
    chmod 755 /usr/sbin/nrsysmond-config && \
    mkdir /etc/newrelic && \
    cp newrelic-sysmond-${NEW_RELIC_SYSMOND_VERSION}-linux/nrsysmond.cfg /etc/newrelic/nrsysmond.cfg

CMD nrsysmond-config --set license_key=$NEW_RELIC_LICENSE_KEY && \
    nrsysmond -c /etc/newrelic/nrsysmond.cfg -l /dev/stdout -f
