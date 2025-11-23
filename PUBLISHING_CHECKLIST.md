# Publishing Checklist

Follow these steps to publish `gh-md2pdf-action` for public use.

## ✅ Pre-Publishing Checklist

- [ ] Repository is public (or you're okay with it being public)
- [ ] All code is committed and pushed
- [ ] README.md is complete and accurate
- [ ] Action works locally (tested with Docker)
- [ ] Containerfile builds successfully

## 📦 Step 1: Initial Setup

1. **Push your code to GitHub**
   ```bash
   git add .
   git commit -m "Initial GitHub Action setup"
   git push origin main
   ```

2. **Verify workflows are set up**
   - Check that `.github/workflows/publish-container.yml` exists
   - Check that `.github/workflows/release.yml` exists

## 🐳 Step 2: Publish Container Image

The container image will be automatically built and published when you push to `main`.

1. **Push to trigger build**
   ```bash
   git push origin main
   ```

2. **Check workflow status**
   - Go to: `https://github.com/tmichett/gh-md2pdf-action/actions`
   - Verify "Build and Publish Container" workflow completes successfully

3. **Verify container was published**
   - Go to: `https://github.com/tmichett?tab=packages`
   - You should see `md2pdf` package

## 🔓 Step 3: Make Container Public

The container is private by default. Make it public:

**Option A: Via GitHub UI**
1. Go to: `https://github.com/tmichett?tab=packages`
2. Click on `md2pdf` package
3. Click "Package settings" (gear icon)
4. Scroll to "Danger Zone"
5. Click "Change visibility"
6. Select "Public"
7. Confirm

**Option B: Via GitHub CLI**
```bash
gh api \
  -X PATCH \
  -H "Accept: application/vnd.github+json" \
  /user/packages/container/md2pdf \
  -f visibility=public
```

## 🏷️ Step 4: Create First Release

1. **Create and push a release tag**
   ```bash
   git tag -a v1.0.0 -m "Initial release of gh-md2pdf-action"
   git push origin v1.0.0
   ```

2. **Verify release was created**
   - Go to: `https://github.com/tmichett/gh-md2pdf-action/releases`
   - You should see v1.0.0 release

3. **Verify container tag was created**
   - The `publish-container.yml` workflow should have created `v1.0.0` tag
   - Check: `https://github.com/tmichett?tab=packages&repo_name=gh-md2pdf-action`

## ✅ Step 5: Test the Published Action

Test that others can use your action:

1. **Create a test repository** (or use an existing one)

2. **Add workflow file** (`.github/workflows/test.yml`):
   ```yaml
   name: Test Published Action
   
   on: [workflow_dispatch]
   
   jobs:
     test:
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v4
         
         - name: Convert Markdown to PDF
           uses: tmichett/gh-md2pdf-action@v1.0.0
           with:
             files: README.md
             output_dir: Docs
         
         - name: List generated PDFs
           run: ls -lh Docs/
   ```

3. **Run the workflow** and verify it works

## 📝 Step 6: Update Documentation

- [ ] Update README.md with your actual username/repo
- [ ] Add any additional usage examples
- [ ] Verify all links work
- [ ] Add badges (optional):
  ```markdown
  ![GitHub release](https://img.shields.io/github/v/release/tmichett/gh-md2pdf-action)
  ![GitHub Actions](https://img.shields.io/github/actions/workflow/status/tmichett/gh-md2pdf-action/publish-container.yml)
  ```

## 🚀 Step 7: Publish to GitHub Marketplace

1. **Accept Marketplace Developer Agreement**
   - Go to: Repository → Settings → Actions
   - Scroll to "GitHub Marketplace" section
   - Click "Accept the GitHub Marketplace Developer Agreement"

2. **Publish Release to Marketplace**
   - When creating a release, check "Publish this Action to the GitHub Marketplace"
   - Select categories: Primary (Documentation/Utilities), Secondary (optional)
   - See [MARKETPLACE.md](MARKETPLACE.md) for detailed instructions

3. **Add topics to repository** (helps discoverability):
   - `github-action`
   - `markdown`
   - `pdf`
   - `mermaid`
   - `documentation`
   - `marketplace`

4. **Share on social media / communities** (optional):
   - GitHub Discussions
   - Reddit (r/github, r/devops)
   - Twitter/X
   - Dev.to / Medium

5. **Add to Awesome Actions** (optional):
   - Submit to: https://github.com/sdras/awesome-actions

## 🔄 Ongoing Maintenance

### For New Releases

1. **Make changes and commit**
   ```bash
   git add .
   git commit -m "Add new feature"
   git push origin main
   ```

2. **Create new release tag**
   ```bash
   git tag -a v1.1.0 -m "Add new feature"
   git push origin v1.1.0
   ```

3. **Container auto-updates** on push to `main`

### For Updates

- Monitor issues and pull requests
- Keep dependencies updated
- Update container image regularly
- Update documentation as needed

## 🐛 Troubleshooting

### Container build fails
- Check workflow logs
- Verify Containerfile is correct
- Ensure all dependencies are available

### Container not found when using action
- Verify container is public
- Check container name matches: `ghcr.io/tmichett/md2pdf:latest`
- Wait a few minutes after publishing (propagation delay)

### Action not found
- Verify repository is public
- Check tag/release exists
- Use full path: `tmichett/gh-md2pdf-action@v1.0.0`

## 📚 Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GitHub Container Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)
- [Creating Releases](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository)

