# Setup Personal Access Token for GHCR

The workflow has been updated to use a Personal Access Token (PAT) as a fallback if `GITHUB_TOKEN` doesn't have sufficient permissions.

## Quick Setup

### Step 1: Create Personal Access Token

1. Go to: https://github.com/settings/tokens
2. Click **"Generate new token (classic)"**
3. Configure the token:
   - **Note**: `GHCR Push Token for gh-md2pdf-action`
   - **Expiration**: Choose your preference (90 days recommended, or "No expiration" for long-term)
   - **Scopes**: Check these:
     - ✅ `write:packages` (required)
     - ✅ `read:packages` (required)
     - ✅ `delete:packages` (optional, for cleanup)
4. Click **"Generate token"**
5. **Copy the token immediately** - you won't be able to see it again!

### Step 2: Add Token as Repository Secret

1. Go to: https://github.com/tmichett/gh-md2pdf-action/settings/secrets/actions
2. Click **"New repository secret"**
3. Configure the secret:
   - **Name**: `GHCR_TOKEN`
   - **Secret**: Paste the token you copied
4. Click **"Add secret"**

### Step 3: Verify Workflow

The workflow will now:
1. First try to use `GHCR_TOKEN` (if it exists)
2. Fall back to `GITHUB_TOKEN` (if `GHCR_TOKEN` doesn't exist)

This means:
- ✅ If you add `GHCR_TOKEN`, it will use the PAT
- ✅ If you don't add it, it will still try `GITHUB_TOKEN`
- ✅ No workflow changes needed after adding the secret

## How It Works

The workflow uses this logic:
```yaml
password: ${{ secrets.GHCR_TOKEN || secrets.GITHUB_TOKEN }}
```

This means:
- If `GHCR_TOKEN` secret exists → use it
- If `GHCR_TOKEN` doesn't exist → use `GITHUB_TOKEN`

## Security Notes

- ✅ PATs are stored securely as GitHub Secrets
- ✅ Secrets are encrypted and never exposed in logs
- ✅ You can revoke the token at any time
- ✅ Consider setting an expiration date

## Troubleshooting

### Token Not Working

1. **Verify token has correct scopes**:
   - Must have `write:packages`
   - Must have `read:packages`

2. **Check token hasn't expired**:
   - Go to: https://github.com/settings/tokens
   - Verify token is still active

3. **Verify secret name is correct**:
   - Must be exactly: `GHCR_TOKEN`
   - Case-sensitive

4. **Re-run workflow** after adding the secret

### Still Getting Permission Errors

1. Check the token has `write:packages` scope
2. Verify the secret was added correctly
3. Check workflow logs for authentication errors
4. Try regenerating the token

## Alternative: Use GITHUB_TOKEN Only

If you prefer to use only `GITHUB_TOKEN`:
1. Don't add `GHCR_TOKEN` secret
2. Ensure repository settings allow "Read and write permissions"
3. The workflow will use `GITHUB_TOKEN` automatically

## Revoking Access

To revoke the token:
1. Go to: https://github.com/settings/tokens
2. Find your token
3. Click "Revoke"
4. The workflow will fall back to `GITHUB_TOKEN`


