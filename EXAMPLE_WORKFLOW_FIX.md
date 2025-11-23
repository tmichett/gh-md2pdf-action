# Example Workflow Fix

## Problem

The `example.yml` workflow was failing because `config.yaml` contained absolute paths from your local machine:
- `/Users/travis/Github/dle-wstunnel-ole/RHTLC_INSTRUCTOR_GUIDE.md`
- `/Users/travis/Github/MarkdownConverter/example.md`

These files don't exist in the GitHub Actions runner environment.

## Solution

The example workflow has been updated to:

1. **Use files that exist in the repository** (like `README.md`)
2. **Use relative paths** instead of absolute paths
3. **Set `fail_on_error: false`** for the example (so it doesn't fail if files are missing)

## Updated Example Workflow

The example now uses:
```yaml
files: README.md  # File that exists in the repo
```

Instead of:
```yaml
config_file: config.yaml  # Which had absolute paths
```

## For Your Own Workflows

When creating your own workflows:

### ✅ DO: Use Relative Paths

```yaml
files: README.md,docs/guide.md,CHANGELOG.md
```

Or in `config.yaml`:
```yaml
files:
  - path: README.md
  - path: docs/guide.md
  - path: CHANGELOG.md
```

### ❌ DON'T: Use Absolute Paths

```yaml
# This won't work in GitHub Actions!
files:
  - path: /Users/yourname/project/file.md
```

## Why This Matters

- **GitHub Actions runners** have a completely different filesystem
- **Absolute paths** from your local machine don't exist in the runner
- **Relative paths** work because they're relative to the repository root (where `actions/checkout` places your code)

## Testing Locally vs. GitHub Actions

- **Local testing**: You can use absolute paths if the files exist on your machine
- **GitHub Actions**: Must use relative paths to files in the repository

## Updated Files

1. `.github/workflows/example.yml` - Now uses `README.md` directly
2. `.github/workflows/example-config.yaml` - Example config with relative paths
3. Workflow now handles missing files gracefully


