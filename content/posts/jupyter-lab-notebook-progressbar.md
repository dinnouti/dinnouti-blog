---
title: "Adding Progressbar to a Jupyter Lab Notebook"
date: 2020-02-05T17:22:55-05:00
draft: false
tags: ["Python", "Jupyter", "Machine Learning"]
comments: true
---


{{< highlight bash >}}
pip3 install tqdm --user
{{< / highlight >}}

{{< highlight python >}}
from tqdm import tqdm
for i, row in tqdm(df.iterrows(), total=df.shape[0]):
    ifor_val = something
    if <condition>:
        ifor_val = something_else
    df.at[i,'ifor'] = ifor_val
    pass
{{< / highlight >}}
