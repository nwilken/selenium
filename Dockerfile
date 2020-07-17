FROM maven:3-amazoncorretto
LABEL maintainer="Nate Wilken <wilken@asu.edu>"

COPY google-chrome.repo /etc/yum.repos.d/

RUN yum update -y && \
    yum install -y wget curl tar unzip chrome-stable xorg-x11-server-Xvfb && \
    yum clean all && \
    rm -rf /var/cache/yum

ARG SELENIUM_STANDALONE_VERSION=3.8.1
ARG SELENIUM_SUBDIR=3.8
RUN curl -sS -o /usr/local/bin/selenium-server-standalone.jar https://selenium-release.storage.googleapis.com/${SELENIUM_SUBDIR}/selenium-server-standalone-${SELENIUM_STANDALONE_VERSION}.jar && \
    chmod 0755 /usr/local/bin/selenium-server-standalone.jar

RUN CHROMEDRIVER_VERSION=$(curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE) && \
    mkdir -p /opt/chromedriver-$CHROMEDRIVER_VERSION && \
    curl -sS -o /tmp/chromedriver_linux64.zip https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip && \
    unzip -qq /tmp/chromedriver_linux64.zip -d /opt/chromedriver-$CHROMEDRIVER_VERSION && \
    rm /tmp/chromedriver_linux64.zip && \
    chmod +x /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver && \
    ln -fs /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver /usr/local/bin/chromedriver

WORKDIR /aat

RUN adduser -U testuser && \
    chown -R testuser:testuser .
    
USER testuser
