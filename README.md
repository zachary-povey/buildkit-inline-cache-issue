This repo provides a minimum working example for an issue spotted with buildkit's inline caching in versions >=0.8.0

## Running

**NB**

- Requires docker with buildx installed.
- Will remove some images/containers from your local docker (those with names it uses, e.g. registry)

Run:

```
./test.sh <buildkit_version>
```

And the script will:

- (cleanup from any previous half-finished run)
- create a new buildx builder using buildkit with the specified version
- boot up a local docker registry
- build the image described in the dockerfile, using inline caching
- run a docker history command
- push the image to the local registry
- rerun the build, using cache-from based on the local registry image we just pushed
- run a docker history command
- (cleanup containers/images)

If you use buildkit version 0.7.0 the two history outputs will be identical as expected. However, if you use a version >= 0.8.0 the second history command will seemingly be offset - it will report the "WORKDIR" command created a layer which is 10kB- and the subsequent command, which downloads a 10kB file, will create a layer which is 0kB in size.
