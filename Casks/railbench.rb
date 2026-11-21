cask "railbench" do
  arch arm: "arm64", intel: "x64"

  version "0.6.1"
  sha256 arm:   "7f68eec57dcd1b438351483f75e853b3608b88f98cacdefe79ed34f7a1e17992",
         intel: "159007f12ef11636be705f1c9f499048f26495d5c112b49af10df40a1754717a"

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
