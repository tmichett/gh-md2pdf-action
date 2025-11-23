# Publishing to GitHub Marketplace

This guide explains how to publish `gh-md2pdf-action` to the GitHub Marketplace so others can discover and use it.

## Prerequisites

Before publishing to the marketplace, ensure:

- ✅ Repository is **public**
- ✅ Repository has a single `action.yml` file at the root
- ✅ Action name is unique (not already in marketplace)
- ✅ You have at least one release/tag created
- ✅ README.md is comprehensive and clear
- ✅ Action works correctly and is tested

## Step 1: Accept Marketplace Developer Agreement

1. Go to your repository on GitHub: `https://github.com/tmichett/gh-md2pdf-action`
2. Click on **Settings** tab
3. In the left sidebar, click **Actions**
4. Scroll down to **GitHub Marketplace** section
5. Click **Accept the GitHub Marketplace Developer Agreement**
6. Read and accept the agreement

## Step 2: Prepare Your Release

### Create a Release Tag

```bash
# Create and push a release tag
git tag -a v1.0.0 -m "Initial marketplace release"
git push origin v1.0.0
```

Or create via GitHub UI:
1. Go to **Releases** → **Draft a new release**
2. Choose tag: `v1.0.0` (create new tag)
3. Release title: `v1.0.0 - Initial Release`
4. Description: See template below

### Release Description Template

```markdown
## 🎉 Initial Release

Convert Markdown files to PDF with professional styling and Mermaid diagram support.

### Features

- ✅ Mermaid diagram rendering
- ✅ GitHub-style markdown styling
- ✅ Automatic PDF bookmarks
- ✅ Emoji support
- ✅ Batch processing
- ✅ Flexible configuration

### Usage

\`\`\`yaml
- uses: tmichett/gh-md2pdf-action@v1.0.0
  with:
    files: README.md
    output_dir: Docs
\`\`\`

### Documentation

See [README.md](https://github.com/tmichett/gh-md2pdf-action/blob/v1.0.0/README.md) for complete documentation.
```

## Step 3: Publish to Marketplace

When creating or editing a release:

1. **Scroll down** to find the checkbox: **"Publish this Action to the GitHub Marketplace"**
2. **Check the box** to enable marketplace publishing
3. **Select Primary Category**:
   - Recommended: **"Documentation"** or **"Utilities"**
   - Other options: "Continuous Integration", "Deployment"
4. **Select Secondary Category** (optional):
   - Recommended: **"Utilities"** or **"Documentation"**
5. **Click "Publish release"** or "Update release"

## Step 4: Verify Publication

After publishing:

1. Go to: `https://github.com/marketplace?type=actions`
2. Search for "Markdown to PDF Converter" or "tmichett/gh-md2pdf-action"
3. Your action should appear in search results
4. Click on it to see the marketplace listing

## Marketplace Listing Details

### What Appears on Marketplace

- **Name**: From `action.yml` (`name` field)
- **Description**: From `action.yml` (`description` field)
- **Author**: From `action.yml` (`author` field)
- **Icon & Color**: From `action.yml` (`branding` section)
- **Categories**: Selected during release publishing
- **Repository**: Link to your repository
- **Latest Version**: Latest release tag
- **README**: Your repository's README.md

### Categories

Choose categories that best describe your action:

- **Primary**: Documentation, Utilities, Continuous Integration
- **Secondary**: Deployment, Code Quality, Testing

## Updating Your Marketplace Listing

### For New Releases

1. Create a new release tag (e.g., `v1.1.0`)
2. Draft a new release
3. Check **"Publish this Action to the GitHub Marketplace"**
4. Select categories (can be different from previous)
5. Publish

### Updating Existing Listing

- Update `action.yml` description → Next release will reflect changes
- Update README.md → Changes appear immediately
- Update categories → Check/uncheck during next release

## Best Practices

### 1. Clear Description

Your `action.yml` description should be:
- Clear and concise (first 160 characters are most important)
- Include key features
- Mention what problem it solves

### 2. Comprehensive README

Your README should include:
- Quick start example
- Detailed usage examples
- Input/output documentation
- Troubleshooting
- Contributing guidelines

### 3. Semantic Versioning

Use semantic versioning:
- `v1.0.0` - Initial release
- `v1.1.0` - New features (backward compatible)
- `v1.0.1` - Bug fixes
- `v2.0.0` - Breaking changes

### 4. Release Notes

Always include:
- What's new
- Breaking changes (if any)
- Migration guide (if needed)
- Usage examples

### 5. Testing

Before publishing:
- Test the action in a real workflow
- Verify all inputs work correctly
- Test error handling
- Verify outputs are correct

## Marketplace Requirements

GitHub requires:

- ✅ Public repository
- ✅ Single `action.yml` at root
- ✅ Unique action name
- ✅ Valid action metadata
- ✅ At least one release
- ✅ Accepted Marketplace Developer Agreement

## Troubleshooting

### Action Not Appearing in Marketplace

- **Check repository is public**: Settings → Change visibility
- **Verify action.yml exists**: Must be at repository root
- **Check release is published**: Not just a draft
- **Verify marketplace checkbox**: Must be checked during release
- **Wait a few minutes**: Marketplace updates can take time

### Cannot Find "Publish to Marketplace" Option

- **Accept Developer Agreement**: Settings → Actions → GitHub Marketplace
- **Repository must be public**: Private repos can't be published
- **Must have a release**: Create at least one release first

### Action Name Already Taken

- Choose a different name in `action.yml`
- Update repository name if needed
- Recreate releases with new name

## Promoting Your Action

After publishing:

1. **Add to Awesome Actions**: https://github.com/sdras/awesome-actions
2. **Share on social media**: Twitter, LinkedIn, Reddit
3. **Write a blog post**: Dev.to, Medium, personal blog
4. **Add badges to README**:
   ```markdown
   ![GitHub release](https://img.shields.io/github/v/release/tmichett/gh-md2pdf-action)
   ![GitHub Marketplace](https://img.shields.io/badge/marketplace-gh--md2pdf--action-blue?logo=github)
   ```

## Monitoring

Track your action's usage:

- **GitHub Insights**: Repository → Insights → Traffic
- **Marketplace Analytics**: GitHub doesn't provide detailed analytics
- **Stars & Forks**: Monitor repository engagement
- **Issues & PRs**: Track user feedback

## Support

- **Documentation**: Keep README updated
- **Issues**: Respond to user issues promptly
- **Examples**: Provide clear usage examples
- **Changelog**: Maintain a CHANGELOG.md

## Next Steps

1. ✅ Accept Marketplace Developer Agreement
2. ✅ Create first release (v1.0.0)
3. ✅ Publish to marketplace
4. ✅ Verify listing appears
5. ✅ Share and promote
6. ✅ Monitor and iterate

Good luck with your marketplace listing! 🚀

