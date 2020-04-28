FROM centos:7

ARG vcs_ref
ARG build_date
ARG version="201904091"
ARG project="agent"
ARG project_branch="master"
ARG artifactory=https://artifactory.delivery.puppetlabs.net/artifactory/rpm__local/development/puppet-runtime/${version}/el-7-x86_64
ARG file_base=${project}-runtime-${project_branch}-${version}.el-7-x86_64
ARG file_base_uri=${artifactory}/${file_base}

LABEL org.label-schema.maintainer="Puppet Release Team <release@puppet.com>" \
      org.label-schema.vendor="Puppet" \
      org.label-schema.url="https://github.com/puppetlabs/puppet-runtime" \
      org.label-schema.license="Apache-2.0" \
      org.label-schema.vcs-url="https://github.com/puppetlabs/puppet-runtime" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.dockerfile="/Dockerfile"

COPY validate_downloads.sh /runtime/validate_downloads.sh
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# hadolint ignore=DL3020
ADD ${file_base_uri}.tar.gz \
    ${file_base_uri}.tar.gz.sha1 \
    ${file_base_uri}.settings.yaml \
    ${file_base_uri}.settings.yaml.sha1 \
    /

ENV RUNTIME_FILE="${file_base}.tar.gz" \
    SETTINGS_FILE="${file_base}.settings.yaml"

LABEL org.label-schema.name="$project Runtime, $project_branch branch" \
      org.label-schema.version="$version" \
      org.label-schema.vcs-ref="$vcs_ref" \
      org.label-schema.build-date="$build_date"

RUN chmod +x /runtime/validate_downloads.sh && \
    /runtime/validate_downloads.sh && \
    gunzip -c ${file_base}.tar.gz | tar -k -C / -xf -
