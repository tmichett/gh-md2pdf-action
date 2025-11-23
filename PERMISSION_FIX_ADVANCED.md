# Advanced Permission Fix

Even with "Read and write permissions" selected, you might still get `permission_denied: write_package`. Here are additional solutions:

## Issue: Settings Look Correct But Still Failing

If your repository settings show "Read and write permissions" is selected but you still get errors, try these:

### Solution 1: Re-run Workflow After Settings Change

1. **Save the settings** (if you just changed them)
2. **Wait 30-60 seconds** for changes to propagate
3. **Re-run the failed workflow**:
   - Go to the workflow run
   - Click "Re-run all jobs"

### Solution 2: Check Organization/Enterprise Policies

If this is an organization repository:
1. Check if there are organization-level policies restricting package writes
2. Go to: Organization Settings → Actions → General
3. Check "Workflow permissions" - might override repository settings

### Solution 3: Verify Package Ownership

The package might be owned by your user account, not the repository:
1. Go to: https://github.com/users/tmichett/packages/container/package/md2pdf
2. Check "Package settings" → "Manage access"
3. Ensure the repository has write access

### Solution 4: Use Explicit Token Scopes

Sometimes GITHUB_TOKEN needs explicit scopes. Try updating the workflow to be more explicit:

```yaml
permissions:
  contents: write  # Changed from read
  packages: write
  attestations: write
  id-token: write
```

### Solution 5: Check if Package Needs to be Linked

1. Go to package settings: https://github.com/users/tmichett/packages/container/package/md2pdf/settings
2. Check "Manage access" or "Connect repository"
3. Ensure the repository `tmichett/gh-md2pdf-action` is connected

### Solution 6: Use Personal Access Token (Workaround)

If nothing else works, use a PAT:

1. Create PAT with `write:packages` scope
2. Add as secret: `GHCR_TOKEN`
3. Update workflow to use the secret instead of GITHUB_TOKEN

## Debugging Steps

1. **Check workflow logs** for more detailed error messages
2. **Verify token has correct scopes**:
   ```bash
   # In workflow, add debug step:
   - name: Debug permissions
     run: |
       echo "Actor: ${{ github.actor }}"
       echo "Repository: ${{ github.repository }}"
   ```

3. **Test with manual push**:
   ```bash
   docker login ghcr.io -u tmichett -p $GITHUB_TOKEN
   docker push ghcr.io/tmichett/md2pdf:test
   ```

## Most Likely Fix

Even with correct settings, try:
1. **Re-run the workflow** (settings might not have propagated)
2. **Check package access settings** (package might need repository connection)
3. **Wait a few minutes** after changing settings


