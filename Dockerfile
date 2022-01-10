FROM rockylinux/rockylinux:8

# Create an empty dir
RUN mkdir /some_dir

# Set working dir - this is the line which seems to get stuff mixed up - without it, the layer sizes make sense
WORKDIR /some_dir

# Download a 10kB file
RUN curl -X GET "https://httpbin.org/bytes/10000" -H "accept: application/octet-stream" > ./dump
