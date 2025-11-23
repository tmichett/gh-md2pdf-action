# Tag Versioning Guide

## Valid Tag Formats

The workflow supports multiple tag formats:

### Semantic Versioning (Recommended)

Use full semantic versions:
- ✅ `v1.0.0` - Major.Minor.Patch
- ✅ `v1.1.0` - Major.Minor.Patch
- ✅ `v2.0.0` - Major.Minor.Patch

These will generate multiple tags:
- `v1.0.0` (exact version)
- `v1.0` (major.minor)
- `v1` (major)
- `latest` (if on default branch)

### Simple Tags

For simple tags like `v1`, `v2`, etc.:
- ✅ `v1` - Will be used as-is
- ✅ `v2` - Will be used as-is
- ✅ `main` - Branch name tags

These tags are used directly without semver parsing.

## Creating Tags

### Create a Semantic Version Tag (Recommended)

```bash
# Create annotated tag
git tag -a v1.0.0 -m "Initial release"

# Push tag
git push origin v1.0.0
```

### Create a Simple Tag

```bash
# Create lightweight tag
git tag v1

# Push tag
git push origin v1
```

## Workflow Behavior

The workflow triggers on:
- Push to `main` branch → Tags as `main` and `latest`
- Push of tag matching `v*` → Tags with version

### For Semantic Versions (v1.0.0)

When you push `v1.0.0`, the workflow creates:
- `ghcr.io/tmichett/md2pdf:v1.0.0`
- `ghcr.io/tmichett/md2pdf:v1.0`
- `ghcr.io/tmichett/md2pdf:v1`
- `ghcr.io/tmichett/md2pdf:latest` (if on default branch)

### For Simple Tags (v1)

When you push `v1`, the workflow creates:
- `ghcr.io/tmichett/md2pdf:v1`

## Best Practices

1. **Use semantic versioning**: `v1.0.0` instead of `v1`
2. **Create annotated tags**: `git tag -a v1.0.0 -m "Message"`
3. **Follow semver rules**: Major.Minor.Patch format
4. **Tag releases**: Create tags for each release

## Troubleshooting

### Error: "v1 is not a valid semver"

**Cause**: Tag `v1` doesn't match semantic version format

**Solution**: 
- Use `v1.0.0` instead of `v1`
- Or the workflow will now handle it as a raw tag

### Error: "No Docker tag has been generated"

**Cause**: Tag format doesn't match any pattern

**Solution**: 
- Use `v1.0.0` format for semantic versions
- Or use simple tags like `v1` (now supported)

## Examples

### Example 1: Initial Release

```bash
git tag -a v1.0.0 -m "Initial release"
git push origin v1.0.0
```

Creates: `v1.0.0`, `v1.0`, `v1`, `latest`

### Example 2: Patch Release

```bash
git tag -a v1.0.1 -m "Bug fixes"
git push origin v1.0.1
```

Creates: `v1.0.1`, `v1.0`, `v1`, `latest`

### Example 3: Minor Release

```bash
git tag -a v1.1.0 -m "New features"
git push origin v1.1.0
```

Creates: `v1.1.0`, `v1.1`, `v1`, `latest`

### Example 4: Major Release

```bash
git tag -a v2.0.0 -m "Breaking changes"
git push origin v2.0.0
```

Creates: `v2.0.0`, `v2.0`, `v2`, `latest`

