# Customized RHEL bootc images

All Podman commands need to be run with root privileges!

## Build entitlement image

>[!warning]
> First add the correct organisation and activation keys to the `entitlement.Containerfile`.

- `podman build -f .\entitlement.Containerfile -t rhel_entitlement:latest .`

## Build bootc base image

- `podman build --cap-add=all --security-opt=label=type:container_runtime_t --device /dev/fuse -f .\rhel-bootc.Containerfile -t rhel-bootc:base .`

## Build a customized image

- `podman build -f rhel-build.Containerfile -t rhel-bootc:custom .`