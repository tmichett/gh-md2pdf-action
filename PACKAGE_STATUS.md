# Package Status ✅

## Package Successfully Created

The container package is now available at:
**https://github.com/users/tmichett/packages/container/package/md2pdf**

### Package Details

- **Status**: ✅ Public
- **Latest Tag**: `latest`
- **Published**: 1 day ago
- **Downloads**: 8
- **Digest**: `sha256:a494e436a828b400c229ebb7ba92dd8944de5e6d0fdebe042713261490d0c990`

### Pull Command

```bash
docker pull ghcr.io/tmichett/md2pdf:latest
```

## Workflow Status

Now that the package exists, the automated workflow should work for future pushes. The workflow will:

1. ✅ Build the container on push to `main` or tag push
2. ✅ Push new versions to GHCR
3. ✅ Tag with appropriate versions (latest, v1.0.0, etc.)

## Next Steps

### 1. Test the Workflow

Make a small change and push to verify the workflow works:

```bash
# Make a small change
echo "# Test" >> test.md
git add test.md
git commit -m "Test workflow"
git push origin main
```

Check the workflow run to ensure it succeeds.

### 2. Create First Release

Create your first release tag so users can use versioned releases:

```bash
git tag -a v1.0.0 -m "Initial release"
git push origin v1.0.0
```

This will trigger the workflow to also tag the container as `v1.0.0`.

### 3. Update Documentation

The package is ready to use. Users can now:

```yaml
- uses: tmichett/gh-md2pdf-action@main
  with:
    files: README.md
```

### 4. Make Package Public (If Not Already)

The package appears to be public already. If you need to verify or change visibility:

1. Go to: https://github.com/users/tmichett/packages/container/package/md2pdf
2. Click "Package settings"
3. Check visibility (should be "Public")
4. Change if needed

## Verification Checklist

- [x] Package exists at GHCR
- [x] Package is public
- [x] Latest tag is available
- [ ] Workflow succeeds on next push
- [ ] Release tag created (v1.0.0)
- [ ] Container tagged with version

## Usage

The action is now ready to use! Users can reference it as:

```yaml
# Latest code
- uses: tmichett/gh-md2pdf-action@main

# After creating releases
- uses: tmichett/gh-md2pdf-action@v1.0.0
```

The container image is automatically pulled from:
- `ghcr.io/tmichett/md2pdf:latest`
- `ghcr.io/tmichett/md2pdf:main` (on branch pushes)
- `ghcr.io/tmichett/md2pdf:v1.0.0` (on version tags)

