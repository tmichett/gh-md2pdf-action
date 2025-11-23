# Quick Usage Guide

## Publishing the Action

To publish this action for reuse:

1. **Tag a release**:
   ```bash
   git tag -a v1.0.0 -m "Initial release"
   git push origin v1.0.0
   ```

2. **Use in other repositories**:
   ```yaml
   - uses: your-username/gh-md2pdf-action@v1.0.0
   ```

## Local Testing

Test the action locally before publishing:

```bash
# Pull the container from registry (recommended)
docker pull ghcr.io/tmichett/md2pdf:latest

# OR build the container locally
docker build -f Containerfile -t ghcr.io/tmichett/md2pdf:latest .

# Test the entrypoint script
export FILES_INPUT="README.md"
export OUTPUT_DIR="Docs"
export CONTAINER_IMAGE="ghcr.io/tmichett/md2pdf:latest"
./action-entrypoint.sh
```

## Action Structure

```
gh-md2pdf-action/
├── action.yml                 # Action definition
├── action-entrypoint.sh       # Main entrypoint script
├── Containerfile              # Docker container definition
├── entrypoint.sh              # Container entrypoint
├── add_pdf_bookmarks.py       # PDF bookmark script
├── pdf-styles.css             # Custom CSS
├── .md-to-pdf.json            # md-to-pdf configuration
├── mermaid-init.js            # Mermaid initialization
└── README.md                  # Documentation
```

## Key Files

- **action.yml**: Defines the GitHub Action interface (inputs, outputs, steps)
- **action-entrypoint.sh**: Processes GitHub Action inputs and orchestrates conversions
- **Containerfile**: Builds the container with all dependencies
- **entrypoint.sh**: Container script that converts a single markdown file to PDF

## Workflow

1. User workflow calls the action with inputs
2. `action.yml` pulls the container from `ghcr.io/tmichett/md2pdf:latest` (or builds locally if not available)
3. `action-entrypoint.sh` processes inputs and converts files
4. For each file, runs the container with `entrypoint.sh`
5. Container converts markdown → PDF and adds bookmarks
6. Action sets outputs and completes

