{{- define "configFileContent" -}}
control-plane {
  token = "{{ .Values.controlPlane.token }}"
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
      namespace = "{{ $.Values.namespace }}"
      engine = "{{ .engine }}"
      image = {{ toJson .image }}
      system-properties = {{ toJson .systemProperties }}
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
