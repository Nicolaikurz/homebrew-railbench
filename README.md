# homebrew-railbench

Homebrew tap for [RAILbench](https://github.com/Nicolaikurz/railbench).

## Install

```bash
brew tap Nicolaikurz/railbench
brew install --cask railbench
# or: brew install --cask Nicolaikurz/railbench/railbench
```

Upgrade: `brew upgrade --cask railbench` · Uninstall: `brew uninstall --cask railbench` (`--zap` removes app data).

## Releasing a new version

1. Publish the macOS ZIPs on the railbench GitHub release (`v<version>`).
2. In this repo run:
   ```bash
   ./scripts/update-homebrew-cask.sh [version]
   ```
   Version defaults to `../railbench/package.json` (override the checkout path with `RAILBENCH_DIR`).
   Local ZIPs in `$RAILBENCH_DIR/release/` are used for SHA-256, otherwise they are downloaded from GitHub.
3. Commit and push `Casks/railbench.rb`.

## Gatekeeper

For unsigned builds: `xattr -cr /Applications/railbench.app` or right-click → Open.
