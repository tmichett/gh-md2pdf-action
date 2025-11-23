# Quick Start Guide

## For Users (Using the Published Action)

### 1. Add to Your Workflow

```yaml
name: Generate PDFs

on:
  push:
    branches: [ main ]

jobs:
  build-pdfs:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Convert Markdown to PDF
        uses: tmichett/gh-md2pdf-action@v1
        with:
          files: README.md
          output_dir: Docs
      
      - name: Upload PDFs
        uses: actions/upload-artifact@v4
        with:
          name: pdfs
          path: Docs/*.pdf
```

### 2. That's It!

The action will:
- Pull the container image from GHCR
- Convert your markdown files to PDF
- Output PDFs to the specified directory

## For Maintainers (Publishing the Action)

### Initial Setup

1. **Push your code to GitHub**
   ```bash
   git add .
   git commit -m "Initial action setup"
   git push origin main
   ```

2. **The container will auto-build**
   - The `publish-container.yml` workflow runs automatically
   - Container is built and pushed to `ghcr.io/tmichett/md2pdf:latest`

3. **Make container public**
   - Go to: https://github.com/tmichett?tab=packages
   - Find `md2pdf` package
   - Settings → Change visibility → Public

4. **Create first release**
   ```bash
   git tag -a v1.0.0 -m "Initial release"
   git push origin v1.0.0
   ```

### Updating the Action

1. Make your changes
2. Commit and push
3. Container auto-updates on push to `main`
4. Create new release tag for versioned releases:
   ```bash
   git tag -a v1.1.0 -m "Add new feature"
   git push origin v1.1.0
   ```

## Common Use Cases

### Convert Single File
```yaml
- uses: tmichett/gh-md2pdf-action@v1
  with:
    files: README.md
```

### Convert Multiple Files
```yaml
- uses: tmichett/gh-md2pdf-action@v1
  with:
    files: README.md,CHANGELOG.md,docs/guide.md
```

### Use Config File
```yaml
- uses: tmichett/gh-md2pdf-action@v1
  with:
    config_file: config.yaml
```

### Custom Output Directory
```yaml
- uses: tmichett/gh-md2pdf-action@v1
  with:
    files: README.md
    output_dir: pdfs
```

## Publishing to Marketplace

To publish to GitHub Marketplace:

1. **Accept Developer Agreement**: Settings → Actions → GitHub Marketplace
2. **Create Release**: Tag v1.0.0 and check "Publish to Marketplace"
3. **Select Categories**: Documentation/Utilities
4. **Publish**: Click "Publish release"

See [MARKETPLACE.md](MARKETPLACE.md) for detailed instructions.

## Need Help?

- 📖 Full documentation: [README.md](README.md)
- 🚀 Publishing guide: [PUBLISHING.md](PUBLISHING.md)
- 🏪 Marketplace guide: [MARKETPLACE.md](MARKETPLACE.md)
- ✅ Marketplace checklist: [MARKETPLACE_CHECKLIST.md](MARKETPLACE_CHECKLIST.md)
- 💡 Usage examples: [USAGE.md](USAGE.md)

