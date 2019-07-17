FROM ufoym/deepo:all-py36-jupyter-cpu
WORKDIR /root
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        bzip2 \
        libfontconfig \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
    && mkdir /tmp/phantomjs \
    && curl -L https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 \
           | tar -xj --strip-components=1 -C /tmp/phantomjs \
    && cd /tmp/phantomjs \
    && mv bin/phantomjs /usr/local/bin \
    && cd \
    && apt-get purge --auto-remove -y \
        curl \
    && apt-get clean \
    && rm -rf /tmp/* /var/lib/apt/lists/*

# Run as non-root user 
RUN useradd --system --uid 72379 -m --shell /usr/sbin/nologin phantomjs

RUN pip install --upgrade pip \
	&&  pip install bs4 \
	&& pip install selenium \
	&& pip install --upgrade pandas 

CMD jupyter notebook --no-browser \
    --ip=0.0.0.0 --allow-root \
    --NotebookApp.token= \
    --notebook-dir='/root'

