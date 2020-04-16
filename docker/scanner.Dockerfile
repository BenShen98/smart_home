FROM balenalib/rpi-debian-python:3
COPY epsonscan.tar.gz /epsonscan.tar.gz

RUN tar -xzf epsonscan.tar.gz && \
    cd imagescan-bundle-common-3.62.0.arm.deb/ && \
    ./install.sh --without-network --without-ocr-engine && \
    rm -rf imagescan-bundle-common-3.62.0.arm.deb epsonscan.tar.gz
    # TODO: remove cached optimse

CMD top>/dev/null
