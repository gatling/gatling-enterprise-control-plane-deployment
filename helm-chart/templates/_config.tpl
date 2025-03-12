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
    {{- if .enterpriseCloud }}
      enterprise-cloud = {
      {{- if .enterpriseCloud.url }}
        url = "{{ .enterpriseCloud.url }}"
      {{- end }}
      }
    {{- end }}
      id = "{{ .id }}"
      description = "{{ .description }}"
      type = "{{ .type }}"
    {{- if eq .type "kubernetes" }}
      namespace = "{{ $.Values.namespace }}"
      engine = "{{ .engine }}"
      image = {{ toJson .image }}
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
      region = "{{ .region }}
      engine = "{{ .engine }}""
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
      system-properties = {{ toJson .systemProperties }}
    {{- if .javaHome }}
      java-home = "{{ .javaHome }}"
    {{- end }}
      jvm-options = {{ toJson .jvmOptions }}
    }
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
