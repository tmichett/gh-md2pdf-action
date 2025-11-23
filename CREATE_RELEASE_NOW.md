# Quick Fix: Create Your First Release

You're getting the error because no release tag exists yet. Here's how to fix it:

## Immediate Solution

### Option 1: Use @main (Quick Fix)

Update your workflow to use `@main` instead of `@v1`:

```yaml
- uses: tmichett/gh-md2pdf-action@main
  with:
    files: README.md
```

This will work immediately but uses the latest code from the main branch.

### Option 2: Create First Release (Recommended)

Create your first release tag:

```bash
# 1. Make sure everything is committed and pushed
git add .
git commit -m "Prepare for v1.0.0 release"
git push origin main

# 2. Create and push the release tag
git tag -a v1.0.0 -m "Initial release"
git push origin v1.0.0
```

Then users can use:
```yaml
- uses: tmichett/gh-md2pdf-action@v1.0.0
```

## After Creating the Tag

1. **Wait 1-2 minutes** for GitHub to process the tag
2. **Test the action** with the new tag
3. **Create a GitHub Release** (optional but recommended):
   - Go to: https://github.com/tmichett/gh-md2pdf-action/releases
   - Click "Draft a new release"
   - Select tag: `v1.0.0`
   - Add release notes
   - Publish

## Version Options

After creating the release, users can use:

- `@v1.0.0` - Specific version (most stable)
- `@v1` - Latest v1.x.x version
- `@main` - Latest code (development)

See [FIRST_RELEASE.md](FIRST_RELEASE.md) for detailed instructions.


