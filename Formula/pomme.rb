class Pomme < Formula
  desc "Container-style CLI for headless macOS virtual machines"
  homepage "https://pommevm.dev"
  url "https://github.com/weswhet/pomme/releases/download/v0.3.0/pomme-0.3.0-arm64.tar.gz"
  sha256 "69977dda74aa930bd3dc73143dccafe54ada09939fad1ba72733367da438046d"
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
