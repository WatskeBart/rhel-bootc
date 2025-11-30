FROM registry.redhat.io/rhel9/rhel-bootc:latest AS builder

RUN --mount=type=bind,from=localhost/rhel_entitlement:latest,source=/rhel_entitlement/rhsm-mount/etc-pki-entitlement/,target=/etc/pki/entitlement/ \
    --mount=type=bind,from=localhost/rhel_entitlement:latest,source=/rhel_entitlement/rhsm-mount/etc-yum.repos.d/redhat.repo,target=/etc/yum.repos.d/redhat.repo \
    --mount=type=bind,from=localhost/rhel_entitlement:latest,source=/rhel_entitlement/rhsm-mount/rhsm/,target=/run/secrets/rhsm/ \
    /usr/libexec/bootc-base-imagectl build-rootfs --manifest=minimal /target-rootfs

FROM scratch

COPY --from=builder /target-rootfs/ /

RUN --mount=type=bind,from=localhost/rhel_entitlement:latest,source=/rhel_entitlement/rhsm-mount/etc-pki-entitlement/,target=/etc/pki/entitlement/ \
    --mount=type=bind,from=localhost/rhel_entitlement:latest,source=/rhel_entitlement/rhsm-mount/etc-yum.repos.d/redhat.repo,target=/etc/yum.repos.d/redhat.repo \
    --mount=type=bind,from=localhost/rhel_entitlement:latest,source=/rhel_entitlement/rhsm-mount/rhsm/,target=/run/secrets/rhsm/ \
    <<EORUN bash
    dnf upgrade -y
    dnf install -y vim tmux
    dnf clean all
    rm -rf /var/cache/yum
EORUN

LABEL containers.bootc 1
LABEL ostree.bootable 1

ENV container=oci

STOPSIGNAL SIGRTMIN+3

CMD ["/sbin/init"]