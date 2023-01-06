{{- define "app-extensions.targethttpsproxy" -}}
{{ $name := (coalesce .value.name .key) }}

apiVersion: compute.gcp.upbound.io/v1beta1
kind: TargetHTTPSProxy
metadata:
  name: {{ $name }}
  annotations:
    crossplane.io/external-name: {{ coalesce .value.externalName $name }}
spec:
  deletionPolicy: {{ coalesce .value.deletionPolicy "Orphan" }}
  forProvider:
    sslCertificates:
      {{ range .value.managedSslCertificates | required ".value.managedSslCertificates is required" }}
      - {{ . }}
      {{ end }}
    urlMap: {{ .value.urlMap | required ".value.urlMap is required" }}
    description: "{{ coalesce .value.description (printf "TargetHttpsProxy of %s generated by kube-core for: %s/%s/%s" .value.urlMap .common.cluster.config.name .common.release.namespace ( coalesce .common.release.name $name)) }}"
  providerConfigRef:
    name: upbound-gcp

{{- end }}
