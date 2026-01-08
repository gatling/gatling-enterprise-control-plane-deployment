control-plane {
  token = ${?CONTROL_PLANE_TOKEN}
  description = "{{ .Values.controlPlane.description }}"
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
  enterprise-cloud = {
    {{- with .Values.controlPlane.enterpriseCloud.proxy }}
    proxy = {
    {{- with .forward }}
      forward {
        url = "{{.url}}"
      }
    {{- end }}
    {{- with .http }}
      http = {
        url = "{{.url}}"
        noproxy = "{{.noproxy}}"
        {{- with .credentials }}
        credentials = {
          username = "{{.username}}"
          password = "{{.password}}"
        }
        {{- end }}
      }
      {{- end }}
      {{- with .truststore }}
      truststore = {
        path = "{{.path}}" 
      }
      {{- end }}
      {{- with .keystore }}
      keystore = {
        path = "{{.path}}" 
        password = "{{.password}}"
      }
      {{- end }}
    }
    {{ end }}
  }
  {{ end }}
  locations = [
  {{- range .Values.privateLocations }}
    {
      id = "{{ .id }}"
      description = "{{ .description }}"
      type = "{{ .type }}"
      {{- if .enterpriseCloud }}
      enterprise-cloud = {
        {{- with .enterpriseCloud.proxy }}
        proxy = {
          {{- with .forward }}
          forward {
            url = "{{.url}}"
          }
          {{- end }}
          {{- with .http }}
          http = {
            url = "{{.url}}"
            noproxy = "{{.noproxy}}"
            {{- with .credentials }}
            credentials = {
              username = "{{.username}}"
              password = "{{.password}}"
            }
            {{- end }}
          }
          {{- end }}
          {{- with .truststore }}
          truststore = {
            path = "{{.path}}" 
          }
          {{- end }}
          {{- with .keystore }}
          keystore = {
            path = "{{.path}}" 
            password = "{{.password}}"
          }
          {{- end }}
        }
        {{ end }}
      }
      {{ end }}
    {{- if eq .type "kubernetes" }}
      namespace = "{{ $.Values.namespace }}"
      engine = "{{ .engine }}"
      image = {{ toJson .image }}
      {{- if .context }}
      context = "{{ .context }}"
      {{- end }}
      {{- with .job }}
      job = {
        apiVersion = "batch/v1"
        kind = "Job"
        metadata: {
            generateName = "gatling-job-"
            namespace = "{{ $.Values.namespace }}"
        }
        spec = {
            template = {{ toJson .spec.template }}
            ttlSecondsAfterFinished = {{ .spec.ttlSecondsAfterFinished }}
        }
      }
      {{- end }}
    {{ end }}
    {{- if eq .type "aws" }}
      region = "{{ .region }}"
      engine = "{{ .engine }}"
      ami = {{ toJson .ami }}
      security-groups = {{ toJson .securityGroups }}
      instance-type = "{{ .instanceType }}"
      spot = {{ toJson .spot }}
      subnets = {{ toJson .subnets }}
      auto-associate-public-ipv4 = {{ toJson .autoAssociatePublicIPv4 }}
      elastic-ips = {{ toJson .elasticIps }}
      {{- if .profileName }}
      profile-name = "{{ .profileName }}"
      {{- end }}
      {{- if .iamInstanceProfile }}
      iam-instance-profile = "{{ .iamInstanceProfile }}"
      {{- end }}
      tags = {{ toJson .tags }}
      tags-for = {{ toJson .tagsFor }}
    {{- end }}
    {{- if eq .type "azure" }}
      region = "{{ .region }}"
      engine = "{{ .engine }}"
      size = "{{ .size }}"
      image = {{ toJson .image }}
      subscription = "{{ .subscription }}"
      network-id = "{{ .networkId }}"
      subnet-name = "{{ .subnetName }}"
      associate-public-ip = {{ toJson .associatePublicIp }}
      tags = {{ toJson .tags }}
    {{- end }}
    {{- if eq .type "gcp" }}
      zone = "{{ .zone }}"
      project = "{{ .project }}"
      {{- if .instanceTemplate }}
      instance-template = "{{ .instanceTemplate }}"
      {{- end }}
      machine = {{ toJson .machine }}
    {{- end }}
      debug.keep-load-generator-alive = {{ toJson (default false .keepLoadGeneratorAlive) }}
      system-properties = {
      {{- range $key, $val := .systemProperties }}
        "{{ $key }}" = "{{ $val }}"
      {{- end }}
      }
    {{- if .javaHome }}
      java-home = "{{ .javaHome }}"
    {{- end }}
      jvm-options = {{ toJson .jvmOptions }}
    }
  {{- end }}
  ]
  {{- if .Values.privatePackage.enabled }}
    {{- if .Values.privatePackage.repository.server }}
    server: {{ toJson .Values.privatePackage.repository.server }}
    {{- end }}
  {{- $repoType := .Values.privatePackage.repository.type }}
  {{- $config := index .Values.privatePackage.repository.configurations $repoType }}
  repository = {
    {{- if .Values.privatePackage.repository.upload }}
    upload = {{ toJson .Values.privatePackage.repository.upload }}
    {{- end }}
    type = "{{ $repoType }}"
    {{- range $key, $value := $config }}
    "{{ $key }}" = {{ toJson $value }}
    {{- end }}
  }
  {{- end }}
}
