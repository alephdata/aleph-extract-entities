FROM alpine:3.9

# Not using Python image because this is smaller
RUN apk update && apk upgrade && \
    apk add --no-cache python3 libstdc++

# Install Python binary builds
RUN apk add --no-cache --virtual=build_deps python3-dev g++ gfortran && \
    pip3 install --no-cache-dir spacy-nightly protobuf grpcio && \
    apk del build_deps

# Download spaCy models
RUN python3 -m spacy download xx

RUN mkdir -p /service
WORKDIR /service
ADD setup.py /service/
ADD entityextractor/ /service/entityextractor
RUN pip3 install --no-cache-dir -e /service

EXPOSE 50000
CMD ["python3", "/service/entityextractor/service.py"]
