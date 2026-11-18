#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
# Optional: path to a local railbench checkout (for version + local release ZIPs)
RAILBENCH_DIR="${RAILBENCH_DIR:-$PROJECT_ROOT/../railbench}"
CASK_FILE="$PROJECT_ROOT/Casks/railbench.rb"

cd "$PROJECT_ROOT"

APP_VERSION="${1:-$(node -p "require('$RAILBENCH_DIR/package.json').version" 2>/dev/null || echo "0.6.1")}"
echo "=== Updating Homebrew Cask for RAILbench v${APP_VERSION} ==="

ARM64_ZIP="$RAILBENCH_DIR/release/railbench-${APP_VERSION}-mac-arm64.zip"
X64_ZIP="$RAILBENCH_DIR/release/railbench-${APP_VERSION}-mac-x64.zip"

# Compute SHA256 if local release ZIPs exist, or fetch from GitHub Release if available
if [ -f "$ARM64_ZIP" ]; then
    echo "• Calculating SHA-256 for local arm64 ZIP: $ARM64_ZIP"
    SHA256_ARM64=$(sha256sum "$ARM64_ZIP" | awk '{print $1}')
else
    echo "⚠️  Local $ARM64_ZIP not found. Attempting to download checksum from GitHub..."
    URL_ARM64="https://github.com/Nicolaikurz/railbench/releases/download/v${APP_VERSION}/railbench-${APP_VERSION}-mac-arm64.zip"
    SHA256_ARM64=$(curl -sL "$URL_ARM64" | sha256sum | awk '{print $1}' || echo "__REPLACE_WITH_SHA256_ARM64__")
fi

if [ -f "$X64_ZIP" ]; then
    echo "• Calculating SHA-256 for local x64 ZIP: $X64_ZIP"
    SHA256_X64=$(sha256sum "$X64_ZIP" | awk '{print $1}')
else
    echo "⚠️  Local $X64_ZIP not found. Attempting to download checksum from GitHub..."
    URL_X64="https://github.com/Nicolaikurz/railbench/releases/download/v${APP_VERSION}/railbench-${APP_VERSION}-mac-x64.zip"
    SHA256_X64=$(curl -sL "$URL_X64" | sha256sum | awk '{print $1}' || echo "__REPLACE_WITH_SHA256_X64__")
fi

echo "  arm64 sha256: $SHA256_ARM64"
echo "  x64   sha256: $SHA256_X64"

mkdir -p "$PROJECT_ROOT/Casks"

cat > "$CASK_FILE" <<EOF
cask "railbench" do
  arch arm: "arm64", intel: "x64"

  version "${APP_VERSION}"
  sha256 arm:   "${SHA256_ARM64}",
         intel: "${SHA256_X64}"

  url "https://github.com/Nicolaikurz/railbench/releases/download/v#{version}/railbench-#{version}-mac-#{arch}.zip"
  name "RAILbench"
  desc "Model railway track planning and layout simulation tool"
  homepage "https://github.com/Nicolaikurz/railbench"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates false
  depends_on macos: ">= :catalina"

  app "railbench.app"

  zap trash: [
    "~/Library/Application Support/railbench",
    "~/Library/Preferences/de.railbench.app.plist",
    "~/Library/Saved Application State/de.railbench.app.savedState",
  ]
end
EOF

echo "✓ Updated Cask file: $CASK_FILE"
