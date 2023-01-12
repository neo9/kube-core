{{- define "app-extensions.managedzone" -}}
{{ $name := .value.dnsName | trimAll "." | replace "." "-" }}
apiVersion: dns.gcp.upbound.io/v1beta1
kind: ManagedZone
metadata:
  name: {{ $name }}
spec:
  deletionPolicy: {{ coalesce .value.deletionPolicy "Orphan" }}
  forProvider:
    description: "{{ coalesce .value.description (printf "ManagedZone of %s generated by kube-core for: %s/%s/%s" .value.dnsName .common.cluster.config.name .common.release.namespace ( coalesce .common.release.name $name)) }}"
    dnsName: {{ .value.dnsName }}
    labels:
      managed-by: crossplane
    visibility: {{ coalesce .value.visibility "public" }}
  providerConfigRef:
    name: upbound-gcp
{{- end }}