cask "railbench" do
  arch arm: "arm64", intel: "x64"

  version "0.6.1"
  sha256 arm:   "3fffd53aecf263800850dd5065750943313d3589f2178ba0ff421ca6169780c5",
         intel: "211398af8b63e7b65728bda038a033e9dd41e09f84b6bf595af158c1613a9a32"

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
