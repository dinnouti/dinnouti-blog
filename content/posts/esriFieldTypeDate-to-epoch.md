---
title: "Convert esriFieldTypeDate, ESRI date, or epoch to a date format using javascript"
date: 2013-09-04T10:19:08-05:00
draft: false
tags: ["Javascript", "ESRI"]
comments: true
---

{{< highlight js >}}
// eftd is an esriFieldTypeDate
eftd = 1379894400000;
dt = new Date(eftd).toUTCString(); // "Mon, 23 Sep 2013 00:00:00 GMT"
dt = new Date(eftd).toISOString() // "2013-09-23T00:00:00.000Z"
dt = new Date(eftd).toISOString().substr(0,10); // "2013-09-23"

dt = new Date(eftd);
dtStr = dt.getFullYear()+ '-' +(dt.getMonth() + 1)+ '-' +(dt.getDate() + 1); // "2013-9-23"
{{< / highlight >}}