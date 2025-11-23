# GitHub Marketplace Publishing Checklist

Quick checklist for publishing to GitHub Marketplace.

## ✅ Pre-Publishing Requirements

- [ ] Repository is **public**
- [ ] Single `action.yml` file exists at repository root
- [ ] Action name in `action.yml` is unique
- [ ] README.md is comprehensive and clear
- [ ] Action has been tested and works correctly
- [ ] At least one release/tag exists

## 📋 Step-by-Step Checklist

### Step 1: Accept Developer Agreement

- [ ] Go to: Repository → **Settings** → **Actions**
- [ ] Scroll to **GitHub Marketplace** section
- [ ] Click **"Accept the GitHub Marketplace Developer Agreement"**
- [ ] Read and accept the agreement

### Step 2: Prepare Release

- [ ] Create release tag: `git tag -a v1.0.0 -m "Initial release"`
- [ ] Push tag: `git push origin v1.0.0`
- [ ] Or create release via GitHub UI

### Step 3: Draft Release

- [ ] Go to: **Releases** → **Draft a new release**
- [ ] Select tag: `v1.0.0` (create new if needed)
- [ ] Add release title: `v1.0.0 - Initial Release`
- [ ] Add release description (see MARKETPLACE.md for template)
- [ ] **Check the box**: "Publish this Action to the GitHub Marketplace"

### Step 4: Select Categories

- [ ] **Primary Category**: Select one
  - [ ] Documentation (recommended)
  - [ ] Utilities (recommended)
  - [ ] Continuous Integration
  - [ ] Other (specify)
- [ ] **Secondary Category** (optional): Select if applicable
  - [ ] Utilities
  - [ ] Documentation
  - [ ] Deployment
  - [ ] Other (specify)

### Step 5: Publish

- [ ] Click **"Publish release"**
- [ ] Wait for processing (may take a few minutes)

### Step 6: Verify

- [ ] Go to: https://github.com/marketplace?type=actions
- [ ] Search for your action name
- [ ] Verify action appears in results
- [ ] Click on listing to verify details are correct
- [ ] Check that README displays correctly

## 🎯 Post-Publishing

- [ ] Add repository topics: `github-action`, `markdown`, `pdf`, `mermaid`, `documentation`, `marketplace`
- [ ] Add badges to README (see MARKETPLACE.md)
- [ ] Share on social media/communities
- [ ] Monitor issues and user feedback
- [ ] Consider adding to Awesome Actions list

## 📝 Release Description Template

Use this template for your marketplace release:

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

## 🔍 Verification

After publishing, verify:

- [ ] Action appears in marketplace search
- [ ] Action page displays correctly
- [ ] README renders properly
- [ ] Categories are correct
- [ ] Version number is correct
- [ ] Usage examples work

## 🐛 Troubleshooting

If action doesn't appear:

- [ ] Verify repository is public
- [ ] Check that marketplace checkbox was checked
- [ ] Verify release is published (not draft)
- [ ] Wait a few minutes (propagation delay)
- [ ] Check action.yml is valid
- [ ] Verify Developer Agreement was accepted

## 📚 Resources

- [Full Marketplace Guide](MARKETPLACE.md)
- [Publishing Guide](PUBLISHING.md)
- [GitHub Marketplace Documentation](https://docs.github.com/en/actions/creating-actions/publishing-actions-in-github-marketplace)


