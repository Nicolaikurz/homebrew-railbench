cask "railbench" do
  arch arm: "arm64", intel: "x64"

  version "0.6.1"
  sha256 arm:   "23dccb0cccc67081bd8cf9931d460cca76b9f6d7cb757c44699e83b3d9147efd",
         intel: "8585379a8b42a2223ac80bf930bd2136b6225d243593b3487fa3808e60e56e40"

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
