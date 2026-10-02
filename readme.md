Powered by [Hugo](https://gohugo.io/). Hosted on AWS using a simple S3 bucket + CloudFront distribution for static site delivery.

Theme based on [siegerts/hugo-theme-basic](https://github.com/siegerts/hugo-theme-basic).
## Creating new post and pages

```bash
hugo new posts/<post-name>.md
hugo new <page-name>.md
```

## Deploying

The content is deployed to S3 + CloudFront.

```bash
# minify the content
hugo --minify --gc

# Deploys in S3 and delete any file that is not in the local folder
aws s3 sync --acl public-read --delete <local path> <S3 bucket>

# Invalidate CloudFront CDN
aws cloudfront create-invalidation --distribution-id <cloudfront distribution id> --paths '/*'
```
