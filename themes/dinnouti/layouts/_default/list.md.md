---
title: {{ .Title }}
url: {{ .Permalink }}
---

{{ range .Pages }}
- [{{ .Title }}]({{ .Permalink }}index.md){{ if .Params.description }}: {{ .Params.description }}{{ end }}
{{- end }}
