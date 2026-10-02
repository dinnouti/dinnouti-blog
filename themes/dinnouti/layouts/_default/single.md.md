---
title: {{ .Title }}
url: {{ .Permalink }}
{{- if .Params.description }}
description: {{ .Params.description }}
{{- end }}
date: {{ .Date.Format "2006-01-02" }}
{{- if .Params.tags }}
tags: {{ delimit .Params.tags ", " }}
{{- end }}
---

{{ .RawContent }}
