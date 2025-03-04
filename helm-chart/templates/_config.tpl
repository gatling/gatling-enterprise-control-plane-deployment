{{- define "configFileContent" -}}
control-plane {
  token = ${?CONTROL_PLANE_TOKEN}
  description = "{{ .Values.controlPlane.description }}"
{{- if .Values.controlPlane.enterpriseCloud }}
  enterprise-cloud = {
  {{- if .Values.controlPlane.enterpriseCloud.url }}
    url = "{{ .Values.controlPlane.enterpriseCloud.url }}"
  {{- end }}
  }
{{- end }}
  locations = [
  {{- range .Values.privateLocations }}
    {
      id = "{{ .id }}"
      description = "{{ .description }}"
      type = "{{ .type }}"
    {{- if eq .type "kubernetes" }}
      namespace = "{{ $.Values.namespace }}"
      engine = "{{ .engine }}"
      image = {{ toJson .image }}
      system-properties = {{ toJson .systemProperties }}
    {{- end }}
    {{- if .javaHome }}
      java-home = "{{ .javaHome }}"
    {{- end }}
      jvm-options = {{ toJson .jvmOptions }}
    {{- if .enterpriseCloud }}
      enterprise-cloud = {
      {{- if .enterpriseCloud.url }}
        url = "{{ .enterpriseCloud.url }}"
      {{- end }}
      }
    {{- end }}
    {{- if eq .type "aws" }}
      region = "{{ .region }}"
      {{- if .ami }}
      ami {
        type = "{{ .ami.type }}"
        {{- if .ami.id }}
        id = "{{ .ami.id }}"
        {{- end }}
      }
      {{- end }}
      {{- if .securityGroups }}
      security-groups = {{ toJson .securityGroups }}
      {{- end }}
      {{- if .instanceType }}
      instance-type = "{{ .instanceType }}"
      {{- end }}
      {{- if .subnets }}
      subnets = {{ toJson .subnets }}
      {{- end }}
      {{- if .autoAssociatePublicIPv4 }}
      auto-associate-public-ipv4 = {{ toJson .autoAssociatePublicIPv4 }}
      {{- end }}
      {{- if .elasticIps }}
      elastic-ips = {{ toJson .elasticIps }}
      {{- end }}
      {{- if .profileName }}
      profile-name = "{{ .profileName }}"
      {{- end }}
      {{- if .iamInstanceProfile }}
      iam-instance-profile = "{{ .iamInstanceProfile }}"
      {{- end }}
      {{- if .tags }}
      tags {
        {{- range $key, $value := .tags }}
        {{ $key }} = "{{ $value }}"
        {{- end }}
      }
      {{- end }}
      {{- if .tagsFor }}
      tags-for {
        {{- if .tagsFor.instance }}
        instance {
          {{- range $key, $value := .tagsFor.instance }}
          {{ $key }} = "{{ $value }}"
          {{- end }}
        }
        {{- end }}
        {{- if .tagsFor.volume }}
        volume {
          {{- range $key, $value := .tagsFor.volume }}
          {{ $key }} = "{{ $value }}"
          {{- end }}
        }
        {{- end }}
        {{- if .tagsFor.networkInterface }}
        network-interface {
          {{- range $key, $value := .tagsFor.networkInterface }}
          {{ $key }} = "{{ $value }}"
          {{- end }}
        }
        {{- end }}
      }
      {{- end }}
    {{- end }}
  {{- if eq .type "kubernetes" }}
    {{- with .job }}
      job = {
        "apiVersion": "batch/v1",
        "kind": "Job",
        "metadata": {
            "generateName": "gatling-job-",
            "namespace": "{{ $.Values.namespace }}"
        },
        "spec": {
            "template": {{ toJson .spec.template }},
            "ttlSecondsAfterFinished": {{ .spec.ttlSecondsAfterFinished }}
        }
      }
    {{- end }}
      debug.keep-load-generator-alive = {{ toJson (default false .keepLoadGeneratorAlive) }}
    }
  {{- end }}
{{- end }}
  ]
  {{- if .Values.privatePackage.enabled }}
  {{- $repoType := .Values.privatePackage.repository.type }}
  {{- $config := index .Values.privatePackage.repository.configurations $repoType }}
  repository = {
    upload: {{ toJson .Values.privatePackage.repository.upload }},
    server: {{ toJson .Values.privatePackage.repository.server }},
    type: "{{ $repoType }}"
    {{- range $key, $value := $config }}
    {{ $key }}: {{ toJson $value }},
    {{- end }}
  }
  {{- end }}
}
{{- end }}
