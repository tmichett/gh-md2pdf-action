# Immediate Fix for GHCR Permission Error

Based on your workflow run: https://github.com/tmichett/gh-md2pdf-action/actions/runs/19614361152

## The Problem

The error `permission_denied: write_package` occurs because GitHub Actions doesn't have permission to write packages, even though the workflow file specifies `packages: write`.

## Solution 1: Update Repository Settings (REQUIRED)

This is the **most important step** and usually fixes the issue:

1. **Go to repository settings**:
   - Direct link: https://github.com/tmichett/gh-md2pdf-action/settings/actions

2. **Scroll to "Workflow permissions"** section

3. **Select**: ✅ **"Read and write permissions"**

4. **Optional**: Check ✅ "Allow GitHub Actions to create and approve pull requests"

5. **Click "Save"**

6. **Re-run the workflow**:
   - Go to: https://github.com/tmichett/gh-md2pdf-action/actions/runs/19614361152
   - Click "Re-run all jobs"

## Solution 2: Manual Push First (If Solution 1 Doesn't Work)

Sometimes the package needs to exist before the workflow can push to it. Push manually once:

### Step 1: Create Personal Access Token

1. Go to: https://github.com/settings/tokens
2. Click **"Generate new token (classic)"**
3. Name: `GHCR Push Token`
4. Expiration: Choose your preference (90 days recommended)
5. **Scopes**: Check these:
   - ✅ `write:packages`
   - ✅ `read:packages`
   - ✅ `delete:packages` (optional, for cleanup)
6. Click **"Generate token"**
7. **Copy the token immediately** (you won't see it again!)

### Step 2: Push Manually

```bash
# Set your token (replace YOUR_TOKEN with the token you copied)
export GITHUB_TOKEN=YOUR_TOKEN

# Login to GHCR
echo $GITHUB_TOKEN | docker login ghcr.io -u tmichett --password-stdin

# Build the image
docker build -f Containerfile -t ghcr.io/tmichett/md2pdf:latest .

# Push (this creates the package)
docker push ghcr.io/tmichett/md2pdf:latest

# Also push the main tag
docker tag ghcr.io/tmichett/md2pdf:latest ghcr.io/tmichett/md2pdf:main
docker push ghcr.io/tmichett/md2pdf:main
```

### Step 3: Verify Package Exists

1. Go to: https://github.com/tmichett?tab=packages
2. You should see the `md2pdf` package
3. The workflow should now work on next push

## Solution 3: Use PAT in Workflow (Alternative)

If you prefer to use a Personal Access Token in the workflow instead of GITHUB_TOKEN:

### Step 1: Add Secret

1. Go to: https://github.com/tmichett/gh-md2pdf-action/settings/secrets/actions
2. Click **"New repository secret"**
3. Name: `GHCR_TOKEN`
4. Value: Your Personal Access Token (from Solution 2, Step 1)
5. Click **"Add secret"**

### Step 2: Update Workflow

Update `.github/workflows/publish-container.yml`:

```yaml
- name: Log in to GitHub Container Registry
  uses: docker/login-action@v3
  with:
    registry: ${{ env.REGISTRY }}
    username: ${{ github.actor }}
    password: ${{ secrets.GHCR_TOKEN }}  # Changed from GITHUB_TOKEN
```

### Step 3: Commit and Push

```bash
git add .github/workflows/publish-container.yml
git commit -m "Use GHCR_TOKEN for authentication"
git push origin main
```

## Why This Happens

GitHub has two levels of permissions:
1. **Workflow-level permissions** (in the workflow file) - ✅ You have this
2. **Repository-level permissions** (in Settings) - ❌ This needs to be updated

Even if your workflow requests `packages: write`, the repository settings can override it and deny the permission.

## Verification

After applying Solution 1, check:

1. ✅ Repository Settings → Actions → Workflow permissions = "Read and write permissions"
2. ✅ Workflow run succeeds
3. ✅ Package appears at: https://github.com/tmichett?tab=packages

## Still Not Working?

If none of these solutions work:

1. Check if your GitHub account has 2FA enabled (required for packages)
2. Verify the repository is public (if required)
3. Check GitHub status: https://www.githubstatus.com/
4. Review workflow logs for more detailed error messages


