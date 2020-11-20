Powered by [Hugo](https://gohugo.io/). Hosted at Amazon Web Services using [AWS Amplify Console](https://aws.amazon.com/amplify/) provides a Git-based workflow for hosting fullstack serverless web apps and static websites with continuous deployment.

Theme based on [siegerts/hugo-theme-basic](https://github.com/siegerts/hugo-theme-basic).
## Creating new post and pages

```bash
hugo new posts/<post-name>.md
hugo new <page-name>.md
```

## Deploying

The content is deployed with [AWS Amplify Console](https://aws.amazon.com/amplify/console/). The instructions below is for a S3 and CloudFront deployment

```bash
# minify the content
hugo --minify --gc

# Deploys in S3 and delete any file that is not in the local folder
aws s3 sync --acl public-read --delete <local path> <S3 bucket>

# Invalidate CloudFront CDN
aws cloudfront create-invalidation --distribution-id <cloudfront distribution id> --paths '/*'
```