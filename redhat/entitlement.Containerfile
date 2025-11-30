FROM registry.access.redhat.com/ubi9/ubi:latest AS build

RUN subscription-manager register --org=ORGID --activationkey=ACTKEY
RUN mkdir -p rhel_entitlement/rhsm-mount/{etc-pki-entitlement,etc-yum.repos.d,rhsm}
RUN cp -rp /etc/pki/entitlement/* rhel_entitlement/rhsm-mount/etc-pki-entitlement
RUN cp -rp /etc/rhsm/* rhel_entitlement/rhsm-mount/rhsm
# Extract only the required repos for bootc images (RS= record separator, ORS= output record separator)
RUN awk '/-appstream-/' RS= ORS="\n\n" /etc/yum.repos.d/redhat.repo >> rhel_entitlement/rhsm-mount/etc-yum.repos.d/redhat.repo
RUN awk '/-baseos-/' RS= ORS="\n\n" /etc/yum.repos.d/redhat.repo >> rhel_entitlement/rhsm-mount/etc-yum.repos.d/redhat.repo
RUN awk '/-supplementary-/' RS= ORS="\n\n" /etc/yum.repos.d/redhat.repo >> rhel_entitlement/rhsm-mount/etc-yum.repos.d/redhat.repo
RUN subscription-manager unregister

FROM scratch
COPY --from=build /rhel_entitlement/rhsm-mount/ /rhel_entitlement/rhsm-mount/