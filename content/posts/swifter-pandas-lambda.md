---
title: "Leveraging Swifter for Pandas Lambda function"
date: 2020-02-05T17:22:55-05:00
draft: false
tags: ["Python", "Pandas"]
comments: true
---

Leveraging Swifter for Pandas Lambda function:

{{< highlight python >}}
import swifter

df['new_column'] = df.swifter.progress_bar(True).apply(lambda x: some_function(x['existing_column']),axis=1)
{{< / highlight >}}
