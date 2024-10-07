{{- define "configFileContent" -}}
control-plane {
  token = "{{ .Values.controlPlane.token }}"
  description = "{{ .Values.controlPlane.description }}"
  extra_content = {{ toJson .extra_content }}
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
      java-home = "{{ .javaHome }}"
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
      {{- if .keepLoadGeneratorAlive }}
      debug.keep-load-generator-alive = {{ .keepLoadGeneratorAlive }}
      {{- end }}
    }
  {{- end }}
  ]

  {{- if .Values.privatePackage.enabled }}
  repository = {{ toJson .Values.privatePackage.repository }}
  {{- end }}
}
{{- end }}
