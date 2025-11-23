# Troubleshooting GHCR Permission Issues

## Error: `permission_denied: write_package`

This error occurs when the workflow doesn't have permission to push to GitHub Container Registry.

## Solutions

### Solution 1: Check Repository Settings

1. Go to your repository: `https://github.com/tmichett/gh-md2pdf-action`
2. Click **Settings** → **Actions** → **General**
3. Scroll to **Workflow permissions**
4. Ensure it's set to:
   - ✅ **Read and write permissions** (recommended)
   - OR
   - ✅ **Read repository contents and packages permissions** (minimum)

5. If using "Read repository contents and packages permissions", make sure:
   - ✅ **Allow GitHub Actions to create and approve pull requests** is checked (if needed)

### Solution 2: Verify Workflow Permissions

The workflow should have these permissions in `.github/workflows/publish-container.yml`:

```yaml
permissions:
  contents: read
  packages: write
  attestations: write
  id-token: write
```

### Solution 3: Check Package Doesn't Exist Yet

If the package doesn't exist, you might need to create it first:

1. **Manually create the package** (one-time):
   ```bash
   # Login locally
   echo $GITHUB_TOKEN | docker login ghcr.io -u tmichett --password-stdin
   
   # Build and push manually once
   docker build -f Containerfile -t ghcr.io/tmichett/md2pdf:latest .
   docker push ghcr.io/tmichett/md2pdf:latest
   ```

2. **Then the workflow should work** for subsequent pushes

### Solution 4: Use Personal Access Token (Alternative)

If `GITHUB_TOKEN` doesn't work, you can use a Personal Access Token:

1. **Create a PAT**:
   - Go to: https://github.com/settings/tokens
   - Click "Generate new token (classic)"
   - Name: `GHCR Push Token`
   - Scopes: Check `write:packages` and `read:packages`
   - Generate token and copy it

2. **Add as Secret**:
   - Go to: Repository → Settings → Secrets and variables → Actions
   - Click "New repository secret"
   - Name: `GHCR_TOKEN`
   - Value: Your PAT
   - Add secret

3. **Update workflow** to use the secret:
   ```yaml
   - name: Log in to GitHub Container Registry
     uses: docker/login-action@v3
     with:
       registry: ${{ env.REGISTRY }}
       username: ${{ github.actor }}
       password: ${{ secrets.GHCR_TOKEN }}  # Changed from GITHUB_TOKEN
   ```

### Solution 5: Verify Package Visibility

The package might exist but be private. Check:

1. Go to: https://github.com/tmichett?tab=packages
2. Find `md2pdf` package
3. Check if it's private or public
4. If private, you can make it public (Settings → Change visibility)

## Quick Fix Checklist

- [ ] Repository Settings → Actions → Workflow permissions → "Read and write permissions"
- [ ] Workflow has `packages: write` permission
- [ ] Package exists (or create it manually first)
- [ ] GITHUB_TOKEN is being used correctly
- [ ] Repository is public (if needed)

## Manual Push (If Workflow Fails)

If the workflow continues to fail, you can push manually:

```bash
# 1. Create Personal Access Token with write:packages permission
# 2. Login
echo $GITHUB_TOKEN | docker login ghcr.io -u tmichett --password-stdin

# 3. Build
docker build -f Containerfile -t ghcr.io/tmichett/md2pdf:latest .

# 4. Tag versions
docker tag ghcr.io/tmichett/md2pdf:latest ghcr.io/tmichett/md2pdf:v1.0.0

# 5. Push
docker push ghcr.io/tmichett/md2pdf:latest
docker push ghcr.io/tmichett/md2pdf:v1.0.0
```

## Common Issues

### Issue: "Resource not accessible by integration"

**Cause**: GITHUB_TOKEN doesn't have the right permissions

**Fix**: 
- Check repository settings (Solution 1)
- Or use Personal Access Token (Solution 4)

### Issue: "Package not found"

**Cause**: Package doesn't exist yet

**Fix**: Create it manually first (Solution 3)

### Issue: "Authentication failed"

**Cause**: Token is invalid or expired

**Fix**: 
- Regenerate GITHUB_TOKEN (automatic in workflows)
- Or create new PAT

## Still Having Issues?

1. Check workflow logs for detailed error messages
2. Verify repository is public (if required)
3. Check GitHub status page for service issues
4. Try manual push to verify credentials work
5. Review GitHub Actions documentation: https://docs.github.com/en/actions/publishing-packages/publishing-docker-images


