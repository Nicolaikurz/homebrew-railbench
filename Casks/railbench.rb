cask "railbench" do
  arch arm: "arm64", intel: "x64"

  version "0.6.1"
  sha256 arm:   "d9d0eb033a6177ba868b518532fc1c751811b03528674b047fc6cecb8bde6ee8",
         intel: "0e4899dd2cb17f498c0dbddf1bd0cb5e84f3a98a9920d3a01c90119dde654c34"

  url "https://github.com/Nicolaikurz/railbench/releases/download/v#{version}/railbench-#{version}-mac-#{arch}.zip"
  name "RAILbench"
  desc "Model railway track planning and layout simulation tool"
  homepage "https://github.com/Nicolaikurz/railbench"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates false

  app "railbench.app"

  # Runs on the staged app (before it is moved to /Applications),
  # so no appdir lookup is needed. chdir "." resolves to the staged path.
  preflight_steps do
    run "/usr/bin/xattr",
        args:  ["-cr", "railbench.app"],
        chdir: "."
  end

  on_arm do
    preflight_steps do
      run "/usr/bin/codesign",
          args:  ["--force", "--deep", "--sign", "-", "railbench.app"],
          chdir: "."
    end
  end

  zap trash: [
    "~/Library/Application Support/railbench",
    "~/Library/Preferences/de.railbench.app.plist",
    "~/Library/Saved Application State/de.railbench.app.savedState",
  ]
end
