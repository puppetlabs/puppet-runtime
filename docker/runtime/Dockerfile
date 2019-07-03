FROM centos:7

ARG vcs_ref
ARG build_date
ARG version="201904091"
ARG project="agent"
ARG project_branch="master"

ENV RUNTIME_FILE="${project}-runtime-${project_branch}-${version}.el-7-x86_64.tar.gz"
ENV SETTINGS_FILE="${project}-runtime-${project_branch}-${version}.el-7-x86_64.settings.yaml"

LABEL org.label-schema.maintainer="Puppet Release Team <release@puppet.com>" \
      org.label-schema.vendor="Puppet" \
      org.label-schema.url="https://github.com/puppetlabs/puppet-runtime" \
      org.label-schema.name="$project Runtime, $project_branch branch" \
      org.label-schema.license="Apache-2.0" \
      org.label-schema.version="$version" \
      org.label-schema.vcs-url="https://github.com/puppetlabs/puppet-runtime" \
      org.label-schema.vcs-ref="$vcs_ref" \
      org.label-schema.build-date="$build_date" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.dockerfile="/Dockerfile"

RUN mkdir /runtime
  
RUN yum clean all && \
    yum install -y wget && \
    yum clean all

WORKDIR /runtime

RUN wget https://artifactory.delivery.puppetlabs.net/artifactory/rpm__local/development/puppet-runtime/$version/el-7-x86_64/${project}-runtime-${project_branch}-${version}.el-7-x86_64.tar.gz && \
    wget https://artifactory.delivery.puppetlabs.net/artifactory/rpm__local/development/puppet-runtime/$version/el-7-x86_64/${project}-runtime-${project_branch}-${version}.el-7-x86_64.tar.gz.sha1 && \
    wget https://artifactory.delivery.puppetlabs.net/artifactory/rpm__local/development/puppet-runtime/$version/el-7-x86_64/${project}-runtime-${project_branch}-${version}.el-7-x86_64.settings.yaml && \
    wget https://artifactory.delivery.puppetlabs.net/artifactory/rpm__local/development/puppet-runtime/$version/el-7-x86_64/${project}-runtime-${project_branch}-${version}.el-7-x86_64.settings.yaml.sha1

COPY validate_downloads.sh /runtime
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN chmod +x /runtime/validate_downloads.sh && \
    /runtime/validate_downloads.sh && \
    gunzip -c ${project}-runtime-${project_branch}-${version}.el-7-x86_64.tar.gz | tar -k -C / -xf -

WORKDIR /
