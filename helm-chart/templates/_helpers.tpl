################################################################################
# HOCON Value Helper
################################################################################
{{/*
Convert a value to HOCON format.
Handles two cases:
1. Static value (string, number, boolean) -> returns quoted string or raw value
2. Secret reference object with {secretName, key, env} -> returns ${ENV_VAR}

Usage: {{ include "hocon-value" $value }}

Examples:
  {{ include "hocon-value" "my-string" }}          -> "my-string"
  {{ include "hocon-value" 8080 }}                 -> 8080
  {{ include "hocon-value" true }}                 -> true
  {{ include "hocon-value" (dict "secretName" "db-secrets" "key" "username" "env" "DB_USER") }}
                                                                -> ${DB_USER}
*/}}
{{- define "hocon-value" -}}
{{- $value := . -}}
{{- if kindIs "map" $value -}}
  {{- if and (hasKey $value "secretName") (hasKey $value "key") (hasKey $value "env") -}}
    {{- /* This is a secret reference */ -}}
${
{{- $value.env -}}
}
  {{- else -}}
    {{- /* This is a regular map, should not happen for leaf values */ -}}
    {{- fail "Unexpected map value without secretName/key/env fields" -}}
  {{- end -}}
{{- else if kindIs "string" $value -}}
  {{- /* String value - quote it */ -}}
"{{ $value }}"
{{- else if kindIs "bool" $value -}}
  {{- /* Boolean value - no quotes */ -}}
{{ $value }}
{{- else if or (kindIs "int" $value) (kindIs "float64" $value) -}}
  {{- /* Numeric value - no quotes */ -}}
{{ $value }}
{{- else if kindIs "invalid" $value -}}
  {{- /* Null/undefined value */ -}}
null
{{- else -}}
  {{- /* Fallback - quote it */ -}}
"{{ $value }}"
{{- end -}}
{{- end -}}

################################################################################
# Collect Secret References
################################################################################
{{/*
Recursively collect all secret references from a configuration object.
Returns a JSON array of objects with {envName, secretName, secretKey}

Usage: {{ include "gatling-helm.collect-secrets" .Values.config }}

Returns: [
  {"envName": "DB_USER", "secretName": "db-secrets", "key": "username"},
  {"envName": "DB_PASS", "secretName": "db-secrets", "key": "password"}
]
*/}}
{{- define "gatling-helm.collect-secrets" -}}
{{- include "gatling-helm-inner.collect-secrets-recursive" (dict "value" . "secrets" list) -}}
{{- end -}}

{{/*
Recursive helper for collecting secrets.
Internal use only - use "gatling-helm.collect-secrets" instead.
*/}}
{{- define "gatling-helm-inner.collect-secrets-recursive" -}}
{{- $value := .value -}}
{{- $secrets := .secrets -}}

{{- if kindIs "map" $value -}}
  {{- if and (hasKey $value "secretName") (hasKey $value "key") (hasKey $value "env") -}}
    {{- /* This is a secret reference - add it to the list */ -}}
    {{- $secretRef := dict "envName" $value.env "secretName" $value.secretName "secretKey" $value.key -}}
    {{- $secrets = append $secrets $secretRef -}}
  {{- else -}}
    {{- /* This is a nested object - recurse into it */ -}}
    {{- range $key, $val := $value -}}
      {{- $secrets = include "gatling-helm-inner.collect-secrets-recursive" (dict "value" $val "secrets" $secrets) | fromJsonArray -}}
    {{- end -}}
  {{- end -}}
{{- else if kindIs "slice" $value -}}
  {{- /* Handle arrays */ -}}
  {{- range $val := $value -}}
    {{- $secrets = include "gatling-helm-inner.collect-secrets-recursive" (dict "value" $val "secrets" $secrets) | fromJsonArray -}}
  {{- end -}}
{{- end -}}

{{- toJson $secrets -}}
{{- end -}}
