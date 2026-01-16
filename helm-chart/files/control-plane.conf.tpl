control-plane {
  token = ${?CONTROL_PLANE_TOKEN}
  description = {{ include "hocon-value" .Values.controlPlane.description }}
  {{- if and .Values.controlPlane.builder (default false .Values.controlPlane.builder.enabled) }}
  builder {
    git.global.credentials {
    {{- if eq .Values.controlPlane.builder.cloneOver "https" }}
      https {
        username = ${?GIT_USERNAME}
        password = ${?GIT_TOKEN}
      }
    {{- end}}
    }
  }
  {{- end }}
  {{- if .Values.controlPlane.enterpriseCloud }}
  enterprise-cloud {
    {{- with .Values.controlPlane.enterpriseCloud.proxy }}
    proxy {
    {{- with .forward }}
      forward {
        url = {{ include "hocon-value" .url}}
      }
    {{- end }}
    {{- with .http }}
      http {
        url = {{ include "hocon-value" .url }}
        noproxy = {{ include "hocon-value" .noproxy }}
        {{- with .credentials }}
        credentials {
          username = {{ include "hocon-value" .username}}
          password = {{ include "hocon-value" .password}}
        }
        {{- end }}
      }
      {{- end }}
      {{- with .truststore }}
      truststore {
        path = {{ include "hocon-value" .path }}
      }
      {{- end }}
      {{- with .keystore }}
      keystore {
        path = {{ include "hocon-value" .path }}
        password = {{ include "hocon-value" .password }}
      }
      {{- end }}
    }
    {{ end }}
  }
  {{ end }}
  locations = [
  {{- range .Values.privateLocations }}
    {
      id = {{ include "hocon-value" .id }}
      description = {{ include "hocon-value" .description }}
      type = {{ include "hocon-value" .type }}
      {{- if .enterpriseCloud }}
      enterprise-cloud {
        {{- with .enterpriseCloud.proxy }}
        proxy {
          {{- with .forward }}
          forward {
            url = {{ include "hocon-value" .url }}
          }
          {{- end }}
          {{- with .http }}
          http {
            url = {{ include "hocon-value" .url }}
            noproxy = {{ include "hocon-value" .noproxy }}
            {{- with .credentials }}
            credentials {
              username = {{ include "hocon-value" .username }}
              password = {{ include "hocon-value" .password }}
            }
            {{- end }}
          }
          {{- end }}
          {{- with .truststore }}
          truststore {
            path = {{ include "hocon-value" .path }}
          }
          {{- end }}
          {{- with .keystore }}
          keystore {
            path = {{ include "hocon-value" .path}}
            password = {{ include "hocon-value" .password }}
          }
          {{- end }}
        }
        {{ end }}
      }
      {{ end }}
    {{- if eq .type "kubernetes" }}
      namespace = "{{ $.Values.namespace }}"
      engine = {{ include "hocon-value" .engine }}
      image = {{ toJson .image }}
      {{- if .context }}
      context = {{ include "hocon-value" .context }}
      {{- end }}
      {{- with .job }}
      job {
        apiVersion = "batch/v1"
        kind = "Job"
        metadata {
            generateName = "gatling-job-"
            namespace = "{{ $.Values.namespace }}"
        }
        spec {
            template = {{ toJson .spec.template }}
            ttlSecondsAfterFinished = {{ include "hocon-value" .spec.ttlSecondsAfterFinished }}
        }
      }
      {{- end }}
    {{ end }}
    {{- if eq .type "aws" }}
      region = {{ include "hocon-value" .region }}
      engine = {{ include "hocon-value" .engine }}
      ami = {{ toJson .ami }}
      security-groups = {{ toJson .securityGroups }}
      instance-type = {{ include "hocon-value" .instanceType }}
      spot = {{ toJson .spot }}
      subnets = {{ toJson .subnets }}
      auto-associate-public-ipv4 = {{ toJson .autoAssociatePublicIPv4 }}
      elastic-ips = {{ toJson .elasticIps }}
      {{- if .profileName }}
      profile-name = {{ include "hocon-value" .profileName }}
      {{- end }}
      {{- if .iamInstanceProfile }}
      iam-instance-profile = {{ include "hocon-value" .iamInstanceProfile }}
      {{- end }}
      tags = {{ toJson .tags }}
      tags-for = {{ toJson .tagsFor }}
    {{- end }}
    {{- if eq .type "azure" }}
      region = {{ include "hocon-value" .region }}
      engine = {{ include "hocon-value" .engine }}
      size = {{ include "hocon-value" .size }}
      image = {{ toJson .image }}
      subscription = {{ include "hocon-value" .subscription }}
      network-id = {{ include "hocon-value" .networkId }}
      subnet-name = {{ include "hocon-value" .subnetName }}
      associate-public-ip = {{ toJson .associatePublicIp }}
      tags = {{ toJson .tags }}
    {{- end }}
    {{- if eq .type "gcp" }}
      zone = {{ include "hocon-value" .zone }}
      project = {{ include "hocon-value" .project }}
      {{- if .instanceTemplate }}
      instance-template = {{ include "hocon-value" .instanceTemplate }}
      {{- end }}
      machine = {{ toJson .machine }}
    {{- end }}
    {{- if eq .type "dedicated" }}
      engine = {{ include "hocon-value" .engine }}
      hosts = {{ toJson .hosts }}
      {{- if .workingDirectory }}
      working-directory = {{ include "hocon-value" .workingDirectory }}
      {{- end }}
      ssh {
        user = {{ include "hocon-value" .ssh.user }}
        private-key {
          path = {{ include "hocon-value" .ssh.privateKey.path }}
          {{- if .ssh.privateKey.password }}
          password = {{ include "hocon-value" .ssh.privateKey.password }}
          {{- end }}
        }
        {{- if .ssh.port }}
        port = {{ include "hocon-value" .ssh.port }}
        {{- end }}
        {{- if .ssh.connectionTimeout }}
        connection-timeout = {{ include "hocon-value" .ssh.connectionTimeout }}
        {{- end }}
      }
    {{- end }}
      debug.keep-load-generator-alive = {{ toJson (default false .keepLoadGeneratorAlive) }}
      system-properties {
      {{- range $key, $val := .systemProperties }}
        "{{ $key }}" = {{ include "hocon-value" $val }}
      {{- end }}
      }
    {{- if .javaHome }}
      java-home = {{ include "hocon-value" .javaHome }}
    {{- end }}
    {{- if .jvmOptions }}
      jvm-options = {{ toJson .jvmOptions }}
    {{- end }}
    }
  {{- end }}
  ]
  {{- if .Values.privatePackage.enabled }}
    {{- if .Values.privatePackage.repository.server }}
    server = {{ toJson .Values.privatePackage.repository.server }}
    {{- end }}
  {{- $repoType := .Values.privatePackage.repository.type }}
  {{- $config := index .Values.privatePackage.repository.configurations $repoType }}
  repository {
    {{- if .Values.privatePackage.repository.upload }}
    upload = {{ toJson .Values.privatePackage.repository.upload }}
    {{- end }}
    type = {{ include "hocon-value" $repoType }}
    {{- range $key, $value := $config }}
    "{{ $key }}" = {{ toJson $value }}
    {{- end }}
  }
  {{- end }}
}
