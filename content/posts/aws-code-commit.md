---
title: "Using AWS Code Commit"
date: 2020-11-20T15:14:17-05:00
draft: false
tags: ["aws", "codecommit"]
comments: false
---

Making sure the AWS CLI is proper installed in the computer

{{< highlight bash >}}
$ aws sts get-caller-identity
{{< / highlight >}}

It should show your account information

{{< highlight json >}}
{
    "Account": "123456789012",
    "UserId": "AKIAIOSFODNN7EXAMPLE",
    "Arn": "arn:aws:iam::123456789012:user/Alice"
}
{{< / highlight >}}

Ensure CodeCommit is installed
{{< highlight bash >}}
$ aws codecommit help
{{< / highlight >}}

## Setting up your CodeCommit repository

Create CodeCommit repository

{{< highlight bash >}}
$ aws codecommit create-repository --repository-name <repository name>
{{< / highlight >}}

Initialize a new git repository
{{< highlight bash >}}
$ git init
{{< / highlight >}}

Add your CodeCommit repository as a remote
{{< highlight bash >}}
$ git remote add origin codecommit://<repository name>
{{< / highlight >}}

After all the configuration is done you can run the common Git commands like Push the code to your new CodeCommit repository
{{< highlight bash >}}
$ git push -u origin master
{{< / highlight >}}
