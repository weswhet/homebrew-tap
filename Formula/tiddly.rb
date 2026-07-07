class Tiddly < Formula
  desc "Headless macOS VM CLI built with Virtualization.framework"
  homepage "https://github.com/weswhet/tiddlyVM"
  license "NOASSERTION"
  head "https://github.com/weswhet/tiddlyVM.git", branch: "main"

  depends_on xcode: ["16.0", :build]
  depends_on arch: :arm64

  def install
    build_dir = buildpath/"build"
    product_dir = build_dir/"Release"

    xcodebuild \
      "-project", "tiddlyVM.xcodeproj",
      "-scheme", "tiddly",
      "-configuration", "Release",
      "-arch", "arm64",
      "SYMROOT=#{build_dir}",
      "build"

    system ENV.cc,
      "-arch", "arm64",
      "-mmacosx-version-min=15.0",
      "-fobjc-arc",
      "-O2",
      "-Wall",
      "-Wextra",
      "-Wno-deprecated-declarations",
      "-framework", "Foundation",
      "-framework", "Security",
      "-o", product_dir/"tiddly-mdm-private-xpc",
      "Sources/TiddlyMDMPrivateXPC/tiddly_mdm_private_xpc.m"

    system "/usr/bin/codesign",
      "--force",
      "--sign", "-",
      "--timestamp=none",
      "--entitlements", "Config/tiddly-mdm-private-xpc.entitlements",
      product_dir/"tiddly-mdm-private-xpc"

    bin.install product_dir/"tiddly"
    bin.install product_dir/"tiddly-csrutil-pty-helper"
    bin.install product_dir/"tiddly-mdm-private-xpc"
  end

  test do
    assert_match "tiddlyVM CLI", shell_output("#{bin}/tiddly --help")
  end
end
