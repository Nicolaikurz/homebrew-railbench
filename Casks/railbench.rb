cask "railbench" do
  arch arm: "arm64", intel: "x64"

  version "0.6.1"
  sha256 arm:   "10f90871016b5eee5b8997b20f5fd441a41314d70465597b236e2469f07ea513",
         intel: "d4012e223e4bd86ec7654866f326317f4292ddcf1593c8bfa7a9f3332d85fde2"

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

  zap trash: [
    "~/Library/Application Support/railbench",
    "~/Library/Preferences/de.railbench.app.plist",
    "~/Library/Saved Application State/de.railbench.app.savedState",
  ]
end
