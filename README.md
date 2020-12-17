# pietcreator-docker

[PietCreator](https://github.com/Ramblurr/PietCreator) in a Docker container requiring no privileges
where the GUI is served through a web browser. Everything process in the container runs as a
non-root user.

# Simple

The Docker image is hosted on DockerHub. The following command can be used to launch a container
running this Docker image.

```bash
docker run --detach --publish 8080:8080 vexingcodes/pietcreator
```

Once the container is launched, you can navigate to `http://localhost:8080` to see the PietCreator
GUI. It may take a few seconds before the page can be loaded properly.

You may want to add a `--volume` tag to allow easy transfer of files between the host filesystem and
the container.

# Build-it-Yourself Usage

Execute `./run.sh`. This will build and launch the container, then print a URL to the novnc server.
The resolution can be set using the `RESOLUTION` environment variable, e.g.  `RESOLUTION=1024x768
./run.sh`. The `run.sh` script is merely an example of how to launch the container, and can be
customized as needed or you can simply launch the container by hand quite easily as shown above.

# Configuration

TCP ports `5900` and `8080` can be published in the `docker run` command to make the PietCreator VNC
and NoVNC (respectively) GUIs available outside the docker host.

The `RESOLUTION` environment variable controls the resolution of the NoVNC/VNC server running in the
container. It defaults to `1920x1080`, and can be controlled by adding
`--env RESOLUTION={width}x{height}` to the `docker run` invocation.
