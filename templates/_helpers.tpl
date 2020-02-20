{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "rudderstack.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "rudderstack.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "rudderstack.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "rudderstack.labels" -}}
helm.sh/chart: {{ include "rudderstack.chart" . }}
{{ include "rudderstack.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "rudderstack.selectorLabels" -}}
app.kubernetes.io/name: {{ include "rudderstack.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "transformer.name" -}}
{{- printf "%s-%s" (include "rudderstack.name" .) "transformer" -}}
{{- end -}}

{{- define "transformer.fullname" -}}
{{- printf "%s-%s" (include "rudderstack.fullname" .) "transformer" -}}
{{- end -}}

{{- define "backend.name" -}}
{{- printf "%s-%s" (include "rudderstack.name" .) "backend" -}}
{{- end -}}

{{- define "backend.fullname" -}}
{{- printf "%s-%s" (include "rudderstack.fullname" .) "backend" -}}
{{- end -}}

{{- define "telegraf-sidecar.name" -}}
{{- printf "%s-%s" (include "rudderstack.name" .) "telegraf-sidecar" -}}
{{- end -}}

{{- define "telegraf-sidecar.fullname" -}}
{{- printf "%s-%s" (include "rudderstack.fullname" .) "telegraf-sidecar" -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for statefulset.
*/}}
{{- define "statefulset.apiVersion" -}}
{{- if semverCompare "<1.14-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "apps/v1beta2" -}}
{{- else -}}
{{- print "apps/v1" -}}
{{- end -}}
{{- end -}}



{{/*telegraf helper functions */}}

{{- define "telegraf.chart" -}}
{{- printf "%s-%s" .Values.telegraf_sidecar.name .Values.telegraf_sidecar.version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "telegraf-sidecar.outputs" -}}
{{- range $outputIdx, $configObject := . -}}
    {{- range $output, $config := . -}}

    [[outputs.{{- $output }}]]
    {{- if $config -}}
    {{- $tp := typeOf $config -}}
    {{- if eq $tp "map[string]interface {}" -}}
        {{- range $key, $value := $config -}}
          {{- $tp := typeOf $value -}}
          {{- if eq $tp "string" }}
      {{ $key }} = {{ $value | quote }}
          {{- end }}
          {{- if eq $tp "float64" }}
      {{ $key }} = {{ $value | int64 }}
          {{- end }}
          {{- if eq $tp "int" }}
      {{ $key }} = {{ $value | int64 }}
          {{- end }}
          {{- if eq $tp "bool" }}
      {{ $key }} = {{ $value }}
          {{- end }}
          {{- if eq $tp "[]interface {}" }}
      {{ $key }} = [
              {{- $numOut := len $value }}
              {{- $numOut := sub $numOut 1 }}
              {{- range $b, $val := $value }}
                {{- $i := int64 $b }}
                {{- $tp := typeOf $val }}
                {{- if eq $i $numOut }}
                  {{- if eq $tp "string" }}
        {{ $val | quote }}
                  {{- end }}
                  {{- if eq $tp "float64" }}
        {{ $val | int64 }}
                  {{- end }}
                {{- else }}
                  {{- if eq $tp "string" }}
        {{ $val | quote }},
                  {{- end}}
                  {{- if eq $tp "float64" }}
        {{ $val | int64 }},
                  {{- end }}
                {{- end }}
              {{- end }}
      ]
          {{- end }}
        {{- end }}
        {{- range $key, $value := $config -}}
          {{- $tp := typeOf $value -}}
          {{- if eq $tp "map[string]interface {}" }}
      [[outputs.{{ $output }}.{{ $key }}]]
            {{- range $k, $v := $value }}
              {{- $tps := typeOf $v }}
              {{- if eq $tps "string" }}
        {{ $k }} = {{ $v | quote }}
              {{- end }}
              {{- if eq $tps "float64" }}
        {{ $k }} = {{ $v | int64 }}.0
              {{- end }}
              {{- if eq $tps "int64" }}
        {{ $k }} = {{ $v | int64 }}
              {{- end }}
              {{- if eq $tps "bool" }}
        {{ $k }} = {{ $v }}
              {{- end }}
              {{- if eq $tps "[]interface {}"}}
        {{ $k }} = [
                {{- $numOut := len $value }}
                {{- $numOut := sub $numOut 1 }}
                {{- range $b, $val := $v }}
                  {{- $i := int64 $b }}
                  {{- if eq $i $numOut }}
            {{ $val | quote }}
                  {{- else }}
            {{ $val | quote }},
                  {{- end }}
                {{- end }}
        ]
              {{- end }}
              {{- if eq $tps "map[string]interface {}"}}
        [[outputs.{{ $output }}.{{ $key }}.{{ $k }}]]
                {{- range $foo, $bar := $v }}
            {{ $foo }} = {{ $bar | quote }}
                {{- end }}
              {{- end }}
            {{- end }}
          {{- end }}
          {{- end }}
    {{- end }}
    {{- end }}
    {{ end }}
{{- end }}
{{- end -}}
