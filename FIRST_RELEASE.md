# Creating Your First Release

This guide helps you create the first release so others can use your action with version tags.

## Why Create a Release?

Without a release tag, users must use `@main` which:
- Points to the latest code (may change)
- Not ideal for production workflows
- Can break if you make breaking changes

With releases, users can:
- Pin to specific versions: `@v1.0.0`
- Use major version tags: `@v1` (points to latest v1.x.x)
- Get stability and reproducibility

## Quick Steps

### 1. Ensure Everything is Committed

```bash
git status
git add .
git commit -m "Prepare for v1.0.0 release"
git push origin main
```

### 2. Create and Push Release Tag

```bash
# Create annotated tag
git tag -a v1.0.0 -m "Initial release of gh-md2pdf-action"

# Push tag to GitHub
git push origin v1.0.0
```

### 3. Create GitHub Release (Optional but Recommended)

1. Go to: https://github.com/tmichett/gh-md2pdf-action/releases
2. Click **"Draft a new release"**
3. Select tag: `v1.0.0`
4. Release title: `v1.0.0 - Initial Release`
5. Add release notes (see template below)
6. Click **"Publish release"**

### 4. Verify Release

```bash
# Check tags
git tag -l

# Verify on GitHub
# Go to: https://github.com/tmichett/gh-md2pdf-action/releases
```

## Release Notes Template

```markdown
## 🎉 Initial Release (v1.0.0)

First release of gh-md2pdf-action - Convert Markdown files to PDF with Mermaid diagram support.

### Features

- ✅ Convert Markdown to PDF
- ✅ Mermaid diagram rendering
- ✅ GitHub-style markdown styling
- ✅ Automatic PDF bookmarks from headings
- ✅ Emoji support
- ✅ Batch processing (multiple files)
- ✅ Flexible configuration (file list or YAML config)

### Usage

\`\`\`yaml
- uses: tmichett/gh-md2pdf-action@v1.0.0
  with:
    files: README.md
    output_dir: Docs
\`\`\`

### Documentation

- [README.md](https://github.com/tmichett/gh-md2pdf-action/blob/v1.0.0/README.md)
- [Quick Start Guide](https://github.com/tmichett/gh-md2pdf-action/blob/v1.0.0/QUICK_START.md)

### Container Image

- `ghcr.io/tmichett/md2pdf:v1.0.0`
- `ghcr.io/tmichett/md2pdf:latest`
```

## After Creating Release

Users can now use:

```yaml
# Specific version (recommended for production)
- uses: tmichett/gh-md2pdf-action@v1.0.0

# Major version (points to latest v1.x.x)
- uses: tmichett/gh-md2pdf-action@v1

# Latest code (development)
- uses: tmichett/gh-md2pdf-action@main
```

## Version Tag Formats

GitHub Actions supports:

- `@v1.0.0` - Specific version (recommended)
- `@v1` - Latest v1.x.x version
- `@v1.0` - Latest v1.0.x version
- `@main` - Latest code from main branch
- `@master` - Latest code from master branch (if exists)

## Troubleshooting

### Tag Not Found Error

If users get "unable to find version `v1`":

1. **Verify tag exists**:
   ```bash
   git tag -l
   ```

2. **Verify tag is pushed**:
   ```bash
   git ls-remote --tags origin
   ```

3. **Check tag format**: Must start with `v` (e.g., `v1.0.0` not `1.0.0`)

4. **Wait a moment**: GitHub may need a few seconds to process the tag

### Users Should Use

- **Before first release**: `@main`
- **After first release**: `@v1.0.0` or `@v1`

## Next Steps

After creating your first release:

1. ✅ Update documentation to reference `@v1.0.0`
2. ✅ Consider publishing to GitHub Marketplace (see [MARKETPLACE.md](MARKETPLACE.md))
3. ✅ Update examples in README
4. ✅ Announce the release

## Future Releases

For future releases:

```bash
# Minor release (new features)
git tag -a v1.1.0 -m "Add new feature"
git push origin v1.1.0

# Patch release (bug fixes)
git tag -a v1.0.1 -m "Fix bug"
git push origin v1.0.1

# Major release (breaking changes)
git tag -a v2.0.0 -m "Breaking changes"
git push origin v2.0.0
```

