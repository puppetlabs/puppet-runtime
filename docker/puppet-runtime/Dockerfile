FROM centos:7

ARG vcs_ref
ARG build_date
ARG version="201904091"
ARG project="agent"
ARG project_branch="master"

LABEL org.label-schema.maintainer="Puppet Release Team <release@puppet.com>" \
      org.label-schema.vendor="Puppet" \
      org.label-schema.url="https://github.com/puppetlabs/puppet-runtime" \
      org.label-schema.license="Apache-2.0" \
      org.label-schema.vcs-url="https://github.com/puppetlabs/puppet-runtime" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.dockerfile="/Dockerfile"

COPY validate_downloads.sh /runtime/validate_downloads.sh
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV RUNTIME_FILE="${project}-runtime-${project_branch}-${version}.el-7-x86_64.tar.gz" \
    SETTINGS_FILE="${project}-runtime-${project_branch}-${version}.el-7-x86_64.settings.yaml"

LABEL org.label-schema.name="$project Runtime, $project_branch branch" \
      org.label-schema.version="$version" \
      org.label-schema.vcs-ref="$vcs_ref" \
      org.label-schema.build-date="$build_date"

RUN yum clean all && \
    yum install -y wget && \
    yum clean all && \
    wget --no-verbose https://artifactory.delivery.puppetlabs.net/artifactory/rpm__local/development/puppet-runtime/$version/el-7-x86_64/${project}-runtime-${project_branch}-${version}.el-7-x86_64.tar.gz && \
    wget --no-verbose https://artifactory.delivery.puppetlabs.net/artifactory/rpm__local/development/puppet-runtime/$version/el-7-x86_64/${project}-runtime-${project_branch}-${version}.el-7-x86_64.tar.gz.sha1 && \
    wget --no-verbose https://artifactory.delivery.puppetlabs.net/artifactory/rpm__local/development/puppet-runtime/$version/el-7-x86_64/${project}-runtime-${project_branch}-${version}.el-7-x86_64.settings.yaml && \
    wget --no-verbose https://artifactory.delivery.puppetlabs.net/artifactory/rpm__local/development/puppet-runtime/$version/el-7-x86_64/${project}-runtime-${project_branch}-${version}.el-7-x86_64.settings.yaml.sha1 && \
    chmod +x /runtime/validate_downloads.sh && \
    /runtime/validate_downloads.sh && \
    gunzip -c ${project}-runtime-${project_branch}-${version}.el-7-x86_64.tar.gz | tar -k -C / -xf -
