# Publishing Guide

This guide explains how to publish the `gh-md2pdf-action` for public use.

## Overview

To make this action available for others to use, you need to:

1. **Publish the container image** to GitHub Container Registry (GHCR)
2. **Create releases** for the action repository
3. **Document usage** for other users

## Step 1: Publish Container Image to GHCR

The action uses a container image that must be published to `ghcr.io/tmichett/md2pdf:latest`.

### Option A: Automated Publishing (Recommended)

Create a workflow that automatically builds and publishes the container on push:

1. Create `.github/workflows/publish-container.yml` (see below)
2. Push to your repository
3. The workflow will automatically build and push the container

### Option B: Manual Publishing

```bash
# Login to GHCR
echo $GITHUB_TOKEN | docker login ghcr.io -u tmichett --password-stdin

# Build the container
docker build -f Containerfile -t ghcr.io/tmichett/md2pdf:latest .

# Tag with version (optional but recommended)
docker tag ghcr.io/tmichett/md2pdf:latest ghcr.io/tmichett/md2pdf:v1.0.0

# Push to registry
docker push ghcr.io/tmichett/md2pdf:latest
docker push ghcr.io/tmichett/md2pdf:v1.0.0
```

**Note:** You'll need a GitHub Personal Access Token (PAT) with `write:packages` permission.

## Step 2: Make Container Public

By default, packages in GHCR are private. Make it public:

1. Go to your repository on GitHub
2. Click on "Packages" (right sidebar)
3. Find the `md2pdf` package
4. Click on "Package settings"
5. Scroll down to "Danger Zone"
6. Click "Change visibility" → "Make public"

Or use the GitHub CLI:

```bash
gh api \
  -X PATCH \
  -H "Accept: application/vnd.github+json" \
  /user/packages/container/md2pdf \
  -f visibility=public
```

## Step 3: Create Action Releases

Create releases so users can pin to specific versions:

```bash
# Create a release tag
git tag -a v1.0.0 -m "Initial release of gh-md2pdf-action"
git push origin v1.0.0

# Or create via GitHub UI:
# 1. Go to repository → Releases → "Create a new release"
# 2. Choose tag (create new: v1.0.0)
# 3. Add release notes
# 4. Publish release
```

## Step 4: Update Documentation

Ensure your README includes:

- Clear usage examples
- Input/output documentation
- Requirements
- Troubleshooting

## Step 5: Share Your Action

Once published, others can use it:

```yaml
- uses: tmichett/gh-md2pdf-action@v1.0.0
  with:
    files: README.md
```

Or use the latest version:

```yaml
- uses: tmichett/gh-md2pdf-action@main
```

## Automated Workflows

See the workflow files in `.github/workflows/`:
- `publish-container.yml` - Automatically builds and publishes container
- `release.yml` - Optional: Automatically creates releases

## Versioning Strategy

- **Major versions** (v1, v2): Breaking changes
- **Minor versions** (v1.1, v1.2): New features, backward compatible
- **Patch versions** (v1.0.1): Bug fixes

Tag both the action repository and container image with matching versions.

## Security

- Use GitHub Actions secrets for tokens
- Enable Dependabot for dependency updates
- Regularly update base images and dependencies
- Review and approve container image pulls in workflows

## Testing Before Publishing

1. Test locally with Docker
2. Test in a private repository first
3. Use `act` (GitHub Actions locally) if available
4. Create a test workflow in your repository

## Maintenance

- Keep container image updated
- Monitor for security vulnerabilities
- Respond to issues and pull requests
- Update documentation as needed

