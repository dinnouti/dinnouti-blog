---
title: "logging in Python"
date: 2020-02-05T17:22:55-05:00
draft: false
tags: ["Python"]
comments: true
---

Snippet how to log data in Python

{{< highlight python >}}
import logging

logging.basicConfig(
    format='%(asctime)s - %(levelname)s - %(module)s - %(message)s',
    level=logging.INFO,
    filename='log.log'
)
{{< / highlight >}}
