# homebrew-railbench

Homebrew tap for [RAILbench](https://github.com/Nicolaikurz/railbench), a model railway track planning and layout simulation tool.

## Install

```bash
brew tap Nicolaikurz/railbench
brew install --cask railbench
# or in one step: brew install --cask Nicolaikurz/railbench/railbench
```

Supports Apple Silicon (arm64) and Intel (x64) Macs.

| Action    | Command                                                    |
| --------- | ---------------------------------------------------------- |
| Upgrade   | `brew update && brew upgrade --cask railbench`             |
| Uninstall | `brew uninstall --cask railbench`                          |
| Full wipe | `brew uninstall --cask --zap railbench` (removes app data) |

## Gatekeeper / code signing

RAILbench builds are not notarized. The cask handles this automatically during install, before the app is moved to `/Applications`:

- removes the quarantine attributes (`xattr -cr`)
- on Apple Silicon, re-applies an ad-hoc signature (`codesign --force --deep --sign -`)

If macOS still refuses to open the app, run this manually:

```bash
xattr -cr /Applications/railbench.app
codesign --force --deep --sign - /Applications/railbench.app   # Apple Silicon only
```

Or right-click the app → **Open**.

## Releasing a new version

1. Publish the macOS ZIPs on the railbench GitHub release `v<version>`:
   - `railbench-<version>-mac-arm64.zip`
   - `railbench-<version>-mac-x64.zip`
2. In this repo, run:
   ```bash
   ./scripts/update-homebrew-cask.sh [version]
   ```
   - The version defaults to the one in `../railbench/package.json`. Set `RAILBENCH_DIR` to use a different checkout path.
   - SHA-256 checksums come from the local ZIPs in `$RAILBENCH_DIR/release/` if they exist. Otherwise the ZIPs are downloaded from the GitHub release.
3. Check the result:
   ```bash
   git diff Casks/railbench.rb
   brew audit --cask --strict Nicolaikurz/railbench/railbench   # optional, on macOS
   ```
4. Commit and push `Casks/railbench.rb`.

## Troubleshooting

- **`Cask 'railbench' is unreadable`** (Homebrew then suggests similarly named casks instead): your local copy of the tap is outdated. Run `brew update`. If that doesn't help, run `brew untap Nicolaikurz/railbench` and tap it again.
- **`No Cask with this name exists`**: the tap isn't installed. Run `brew tap Nicolaikurz/railbench` first, or use the fully qualified name.

## License

See [LICENSE](LICENSE).
