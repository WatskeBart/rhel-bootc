# Customized RHEL bootc images

> [!warning]
> All Podman commands need to be run with root/administrative privileges!

## Build entitlement image

> [!important]
> First add the correct organisation and activation key to the `entitlement.Containerfile`.

- `podman build -f .\entitlement.Containerfile -t rhel_entitlement:latest .`

## Build bootc base image

- `podman build --cap-add=all --security-opt=label=type:container_runtime_t --device /dev/fuse -f .\rhel-bootc.Containerfile -t rhel-bootc:base .`

## Build a customized image

- `podman build -f rhel-build.Containerfile -t rhel-bootc:custom .`

## Build a ISO image

> [!important]
> Make sure the folder `./output` exists before running the command below!

```bash
podman run \
--rm \
-it \
--privileged \
--pull=newer \
--security-opt label=type:unconfined_t \
-v ./config.toml:/config.toml:ro \
-v ./output:/output \
-v /var/lib/containers/storage:/var/lib/containers/storage \
registry.redhat.io/rhel9/bootc-image-builder:latest \
--type anaconda-iso \
--use-librepo=True \
localhost/rhel-bootc:custom
```
