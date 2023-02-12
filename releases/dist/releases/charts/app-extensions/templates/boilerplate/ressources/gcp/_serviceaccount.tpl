{{- define "app-extensions.gcp-serviceaccount" -}}
{{- $name := (coalesce .value.name .key) }}
{{- $resourceName := (coalesce .value.resourceName .value.name .key) }}
apiVersion: iam.gcp.crossplane.io/v1alpha1
kind: ServiceAccount
metadata:
  name: {{ $resourceName }}
  annotations:
    crossplane.io/external-name: {{ coalesce .value.externalName $name }}
spec:
  deletionPolicy: {{ coalesce .value.deletionPolicy "Orphan" }}
  forProvider:
    displayName: {{ coalesce .value.displayName $name }}
    description: "{{ coalesce .value.description (printf "SA generated by kube-core for: %s/%s/%s" .common.cluster.config.name .common.release.namespace ( coalesce .common.release.name $name)) }}"
  providerConfigRef:
    name: gcp
{{- end }}
