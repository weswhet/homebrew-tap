class Pomme < Formula
  desc "Container-style CLI for headless macOS virtual machines"
  homepage "https://pommevm.dev"
  url "https://github.com/weswhet/pomme/releases/download/v0.2.0/pomme-0.2.0-arm64.tar.gz"
  sha256 "629a87fc1bb30f535cf53fdf83c3b9af3c6c17022b6d57e6e33b8ec442a6cae5"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :sequoia

  # A formula, unlike a cask, doesn't quarantine its download, so macOS runs
  # the Developer ID-signed executable without notarization. Homebrew
  # installs the signed bytes unchanged.
  def install
    bin.install "pomme"
    generate_completions_from_executable(bin/"pomme", "--generate-completion-script")
  end

  test do
    assert_match "pomme #{version} (", shell_output("#{bin}/pomme --version")
  end
end
