{{- define "render.map" -}}
  {{- $map := . -}}
  {{- range $key, $val := $map }}
  "{{ $key }}" = {{- if kindIs "map" $val }} {
    {{- include "render.map" $val | nindent 2 }}
  }
  {{- else if kindIs "string" $val }}
    {{ tpl $val $ }}
  {{- else }}
    {{ $val }}
  {{- end }}
  {{- end -}}
{{- end -}}
