{{- define "jobContent" -}}
{
    "apiVersion": "batch/v1",
    "kind": "Job",
    "metadata": {
        "generateName": "gatling-job-",
        "namespace": "{{ $.Values.namespace }}"
    },
    "spec": {
        "template": {{ toJson .Values.privateLocationJob.spec.template | indent 8 }},
        "ttlSecondsAfterFinished": {{ .Values.privateLocationJob.spec.ttlSecondsAfterFinished }}
    }
}
{{- end }}
