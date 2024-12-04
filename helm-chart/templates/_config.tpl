{{- define "configFileContent" -}}
control-plane {
  token = "{{ .Values.controlPlane.token }}"
  description = "{{ .Values.controlPlane.description }}"
  {{- with .Values.controlPlane.extraContent }}
  {{- range $key, $value := . }}
  {{ $key }} = {{ toJson $value }}
  {{- end }}
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
      {{- with .extraContent }}
      {{- range $key, $value := . }}
      {{ $key }} = {{ toJson $value }}
      {{- end }}
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
