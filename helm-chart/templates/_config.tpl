{{- define "configFileContent" -}}
control-plane {
  token = "{{ .Values.controlPlane.token }}"
  description = "{{ .Values.controlPlane.description }}"
  extra_content = {
  {{- range $key, $value := .extra_content }}
    {{ $key }} = "{{ $value }}"
  {{- end }}
  }
  locations = [
  {{- range .Values.privateLocations }}
    {
      id = "{{ .id }}"
      description = "{{ .description }}"
      type = "{{ .type }}"
      namespace = "{{ $.Values.namespace }}"
      engine = "{{ .engine }}"
      image {
        type = "{{ .image.type }}"
        {{- if .image.java }}
        java = "{{ .image.java }}"
        {{- end }}
      }

      system-properties {
        {{- range $key, $value := index . "system-properties" }}
        {{ $key }} = "{{ $value }}"
        {{- end }}
      }

      {{- if .javaHome }}
      java-home = "{{ .javaHome }}"
      {{- end }}

      {{- if .jvmOptions }}
      jvm-options = [
        {{- range $index, $option := .jvmOptions }}
        "{{ $option }}"{{ if not (eq (add1 $index) (len .jvmOptions)) }},{{ end }}
        {{- end }}
      ]
      {{- end }}
    {{- if .job.enabled }}
      job = {
        apiVersion = "batch/v1"
        kind = "Job"
        metadata = {
          generateName = "gatling-job-"
          namespace = "{{ $.Values.namespace }}"
        }
        spec = {
          template = {{ .Values.job.spec.template | toJson }}
          ttlSecondsAfterFinished = {{ .Values.job.spec.ttlSecondsAfterFinished }}
        }
      }
    {{- end }}
    }
  {{- end }}
  ]

  {{- if .Values.privatePackage.enabled }}
  repository = {
    type = "{{ .Values.privatePackage.repository.type }}"
    directory = "{{ .Values.privatePackage.repository.directory }}"
    upload {
      directory = "{{ .Values.privatePackage.repository.upload.directory }}"
    }
    server {
      port = {{ .Values.privatePackage.repository.server.port }}
      {{- if .Values.privatePackage.repository.server.bindAddress }}
      bindAddress = "{{ .Values.privatePackage.repository.server.bindAddress }}"
      {{- end }}
      {{- if .Values.privatePackage.repository.server.certificate }}
      certificate {
        path = "{{ .Values.privatePackage.repository.server.certificate.path }}"
        {{- if .Values.privatePackage.repository.server.certificate.password }}
        password = "{{ .Values.privatePackage.repository.server.certificate.password }}"
        {{- end }}
      }
      {{- end }}
    }
    location {
      download-base-url = "{{ index .Values.privatePackage.repository.location "download-base-url" }}"
    }
  }
  {{- end }}
}
{{- end }}