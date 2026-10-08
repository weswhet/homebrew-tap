class Pomme < Formula
  desc "Container-style CLI for headless macOS virtual machines"
  homepage "https://pommevm.dev"
  url "https://github.com/weswhet/pomme/releases/download/v0.1.0/pomme-0.1.0-arm64.tar.gz"
  sha256 "2f3a012945195b9942ef4c78a3504711bcf3a26a9e9aa787490973b44912d943"
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
