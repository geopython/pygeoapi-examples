{{/*
Expand the name of the chart.
*/}}
{{- define "pygeoapi.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "pygeoapi.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "pygeoapi.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "pygeoapi.labels" -}}
helm.sh/chart: {{ include "pygeoapi.chart" . }}
{{ include "pygeoapi.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "pygeoapi.selectorLabels" -}}
app.kubernetes.io/name: {{ include "pygeoapi.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "pygeoapi.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "pygeoapi.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

# root path handler
{{- define "pygeoapi.domain" -}}
{{- $serviceHost := printf "%s.%s.svc.cluster.local:%s" (include "pygeoapi.fullname" .) .Release.Namespace (.Values.service.port | toString) -}}
{{- $ingressHost := (first .Values.ingress.hosts).host -}}
{{ ternary $ingressHost $serviceHost .Values.ingress.enabled }}
{{- end }}

{{- define "pygeoapi.subPath" -}}
{{ (first (first .Values.ingress.hosts).paths).path }}
{{- end }}