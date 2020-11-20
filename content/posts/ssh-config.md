---
title: "Automatic Login in SSH using config file"
date: 2018-12-18T21:08:08-05:00
draft: false
tags: ["Linux", "ssh"]
comments: true
---

Remembering tons of SSH hosts and respective signature files is hard. This is when the config file comes in place. Edit the file ~/.ssh/config.

{{< highlight bash >}}
$ vi ~/.ssh/config
{{< / highlight >}}

Add the following:
{{< highlight bash >}}
Host server1
     HostName server1.example.com
     User root
     Port 22
     IdentityFile ~/.ssh/test.pem
{{< / highlight >}}

Next time you try to login to the server:
{{< highlight bash >}}
$ ssh server1
{{< / highlight >}}