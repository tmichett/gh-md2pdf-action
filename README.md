# gh-md2pdf-action

[![GitHub release](https://img.shields.io/github/v/release/tmichett/gh-md2pdf-action)](https://github.com/tmichett/gh-md2pdf-action/releases)
[![GitHub Marketplace](https://img.shields.io/badge/marketplace-gh--md2pdf--action-blue?logo=github)](https://github.com/marketplace/actions/markdown-to-pdf-converter)
[![GitHub Actions](https://img.shields.io/github/actions/workflow/status/tmichett/gh-md2pdf-action/publish-container.yml?label=build)](https://github.com/tmichett/gh-md2pdf-action/actions)

A GitHub Action to convert Markdown files to PDF with support for Mermaid diagrams, GitHub-style markdown rendering, and automatic PDF bookmarks.

## Quick Start

```yaml
- name: Convert Markdown to PDF
  uses: tmichett/gh-md2pdf-action@v1
  with:
    files: README.md
    output_dir: Docs
```

See [PUBLISHING.md](PUBLISHING.md) for instructions on publishing this action.

**Want to publish to GitHub Marketplace?** See [MARKETPLACE.md](MARKETPLACE.md) for step-by-step instructions.

## Features

- ✅ **Mermaid Diagram Support** - Renders Mermaid code blocks as diagrams in PDFs
- ✅ **GitHub Markdown Styling** - Uses GitHub's markdown CSS for consistent styling
- ✅ **PDF Bookmarks** - Automatically generates navigation bookmarks from markdown headings
- ✅ **Emoji Support** - Renders emojis using Noto Color Emoji fonts
- ✅ **Custom Pagination** - CSS rules to prevent awkward page breaks
- ✅ **Batch Processing** - Convert multiple files at once
- ✅ **Flexible Configuration** - Use file lists or YAML config files

## Usage

### Basic Usage

Convert a single markdown file:

```yaml
name: Generate PDFs

on:
  push:
    branches: [ main ]
  workflow_dispatch:

jobs:
  build-pdfs:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Convert Markdown to PDF
        uses: tmichett/gh-md2pdf-action@v1  # Use published action
        with:
          files: README.md
          output_dir: Docs
      
      - name: Upload PDFs
        uses: actions/upload-artifact@v4
        with:
          name: documentation-pdfs
          path: Docs/*.pdf
```

### Multiple Files

Convert multiple files using a comma-separated list:

```yaml
      - name: Convert Markdown to PDF
        uses: tmichett/gh-md2pdf-action@v1
        with:
          files: README.md,CHANGELOG.md,docs/guide.md
          output_dir: Docs
```

### Using Config File

Use a YAML configuration file to specify files:

```yaml
- name: Convert Markdown to PDF
  uses: tmichett/gh-md2pdf-action@v1
  with:
    config_file: config.yaml
    output_dir: Docs
```

Example `config.yaml`:

```yaml
files:
  - path: README.md
  - path: docs/user-guide.md
  - path: docs/developer-guide.md
```

### Complete Example Workflow

```yaml
name: Build PDF Documentation

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
  workflow_dispatch:

jobs:
  build-pdfs:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Convert Markdown to PDF
        id: convert
        uses: tmichett/gh-md2pdf-action@v1
        with:
          config_file: config.yaml
          output_dir: Docs
          fail_on_error: true
      
      - name: Upload PDFs as artifacts
        uses: actions/upload-artifact@v4
        with:
          name: documentation-pdfs
          path: Docs/*.pdf
          if-no-files-found: error
          retention-days: 30
      
      - name: Commit PDFs to repository
        if: github.event_name == 'push' && github.ref == 'refs/heads/main'
        run: |
          git config --local user.email "action@github.com"
          git config --local user.name "GitHub Action"
          git add Docs/*.pdf
          git diff --staged --quiet || git commit -m "docs: Update PDF documentation [skip ci]"
          git push
```

## Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `files` | Comma-separated list of markdown files to convert | No | - |
| `config_file` | Path to config.yaml file listing markdown files | No | - |
| `output_dir` | Directory to output PDF files | No | `Docs` |
| `working_directory` | Working directory for file paths | No | `.` |
| `fail_on_error` | Fail the action if any PDF conversion fails | No | `true` |
| `container_image` | Container image name to use | No | `ghcr.io/tmichett/md2pdf:latest` |
| `build_container` | Build the container if it does not exist | No | `true` |

**Note:** You must provide either `files` or `config_file` (or both).

## Outputs

| Output | Description |
|--------|-------------|
| `pdfs` | Comma-separated list of generated PDF files |
| `pdf_count` | Number of PDFs successfully generated |

Example usage of outputs:

```yaml
- name: Convert Markdown to PDF
  id: convert
  uses: ./  # or your-username/gh-md2pdf-action@v1
  with:
    files: README.md

- name: Display results
  run: |
    echo "Generated ${{ steps.convert.outputs.pdf_count }} PDF(s)"
    echo "PDFs: ${{ steps.convert.outputs.pdfs }}"
```

## Requirements

- **Docker** must be available in the GitHub Actions runner (default Ubuntu runners have Docker pre-installed)
- Markdown files must exist in the repository
- The action will automatically pull the container image from `ghcr.io/tmichett/md2pdf:latest` or build it locally if not available

## How It Works

1. **Container Build**: The action builds a Docker container with all necessary tools (md-to-pdf, Python, Chromium dependencies)
2. **File Processing**: For each markdown file:
   - Converts markdown to HTML with GitHub styling
   - Renders Mermaid diagrams
   - Generates PDF using headless Chromium
   - Adds PDF bookmarks from markdown headings
3. **Output**: PDFs are saved to the specified output directory

## Container Details

The action uses a containerized environment that includes:

- **md-to-pdf** - Markdown to PDF converter
- **Python 3** - For PDF bookmark generation
- **Chromium dependencies** - For headless browser rendering
- **Mermaid.js** - For diagram rendering
- **Custom CSS** - For better PDF pagination

See [CONTAINER_DOCUMENTATION.md](CONTAINER_DOCUMENTATION.md) for detailed container information.

## Local Development

You can also use this tool locally with Docker/Podman:

```bash
# Pull the container from registry (recommended)
docker pull ghcr.io/tmichett/md2pdf:latest

# Or build the container locally
docker build -f Containerfile -t ghcr.io/tmichett/md2pdf:latest .

# Convert a file
docker run --rm \
  -v $(pwd):/workspace:rw \
  ghcr.io/tmichett/md2pdf:latest \
  /workspace/README.md \
  /workspace/README.pdf
```

Or use the provided scripts:

```bash
# Build container
./build.sh

# Run conversion (requires config.yaml)
./run.sh
```

## Troubleshooting

### Container Build Fails

- Ensure Docker is available in the runner
- Check that the Containerfile is present in the action directory

### PDFs Not Generated

- Verify markdown files exist at specified paths
- Check file permissions
- Review action logs for specific error messages

### Mermaid Diagrams Not Rendering

- Ensure Mermaid code blocks use correct syntax: ` ```mermaid `
- Check that network access is available (Mermaid.js loads from CDN)
- Review container logs for Mermaid initialization errors

### Permission Errors

- Ensure the action has write permissions to the output directory
- Check that Docker has proper permissions in the runner

## Publishing This Action

To publish this action for others to use:

1. **Publish the container image** to GitHub Container Registry (GHCR)
2. **Create releases** with version tags (e.g., `v1.0.0`)
3. **Make the container public** in GHCR package settings
4. **Publish to GitHub Marketplace** (optional but recommended)

See [PUBLISHING.md](PUBLISHING.md) for detailed instructions.

### Publishing to GitHub Marketplace

To make your action discoverable in the GitHub Marketplace:

1. Accept the Marketplace Developer Agreement (Settings → Actions → GitHub Marketplace)
2. Create a release and check "Publish this Action to the GitHub Marketplace"
3. Select appropriate categories (Documentation/Utilities)

See [MARKETPLACE.md](MARKETPLACE.md) for complete marketplace publishing instructions.

### Quick Publish Steps

1. Push your code to GitHub
2. The `publish-container.yml` workflow will automatically build and push the container
3. Make the container public in GHCR settings
4. Create a release tag: `git tag v1.0.0 && git push origin v1.0.0`

### Using the Published Action

Once published, others can use your action:

```yaml
- uses: tmichett/gh-md2pdf-action@v1.0.0
  with:
    files: README.md
```

Or use the latest version from a branch:

```yaml
- uses: tmichett/gh-md2pdf-action@main
  with:
    files: README.md
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

See LICENSE file for details.
