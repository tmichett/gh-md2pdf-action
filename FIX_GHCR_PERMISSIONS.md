# Quick Fix: GHCR Permission Denied

## Immediate Fix (Most Common Solution)

The error `permission_denied: write_package` is usually caused by repository workflow permissions.

### Step 1: Update Repository Settings

1. Go to: https://github.com/tmichett/gh-md2pdf-action/settings/actions
2. Scroll to **"Workflow permissions"**
3. Select: **"Read and write permissions"**
4. ✅ Check: **"Allow GitHub Actions to create and approve pull requests"** (if you want)
5. Click **"Save"**

### Step 2: Re-run the Workflow

1. Go to: https://github.com/tmichett/gh-md2pdf-action/actions
2. Find the failed workflow run
3. Click **"Re-run all jobs"**

This should fix the issue in most cases.

## Alternative: Manual Push (If Workflow Still Fails)

If the workflow still fails, push manually to create the package first:

```bash
# 1. Create a Personal Access Token
# Go to: https://github.com/settings/tokens
# Generate token with: write:packages, read:packages

# 2. Login
export GITHUB_TOKEN=your-token-here
echo $GITHUB_TOKEN | docker login ghcr.io -u tmichett --password-stdin

# 3. Build
docker build -f Containerfile -t ghcr.io/tmichett/md2pdf:latest .

# 4. Push (this creates the package)
docker push ghcr.io/tmichett/md2pdf:latest

# 5. After this, the workflow should work
```

## Verify It Worked

After fixing, check:
- Go to: https://github.com/tmichett?tab=packages
- You should see the `md2pdf` package
- The workflow should succeed on next run

## Still Not Working?

See [TROUBLESHOOTING_GHCR.md](TROUBLESHOOTING_GHCR.md) for more detailed solutions.


