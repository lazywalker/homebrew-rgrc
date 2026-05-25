class Rgrc < Formula
  desc "Rusty Generic Colouriser - just like grc but fast"
  homepage "https://github.com/lazywalker/rgrc"
  version "0.6.13"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/lazywalker/rgrc/releases/download/v#{version}/rgrc-aarch64-apple-darwin.tar.gz"
      sha256 "14c0d2c4762bf79094f89da83bcd51f846d5f493ddd65cdb50788b6c00ae69a6"
    end

    on_intel do
      url "https://github.com/lazywalker/rgrc/releases/download/v#{version}/rgrc-x86_64-apple-darwin.tar.gz"
      sha256 "8975c89e13f3ad4c5f55aed61641dafe41fbdf1db2cbd61fe427aae947ff30c9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/lazywalker/rgrc/releases/download/v#{version}/rgrc-aarch64-unknown-linux-musl.tar.gz"
      sha256 "31a1811d3b4897dff9fcf49ecdfbb85b62a5c044aeb1ca5c2bcf0ea1f763599f"
    end

    on_intel do
      url "https://github.com/lazywalker/rgrc/releases/download/v#{version}/rgrc-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5d9cfaba0a37e2e32972128c1f182b59a166116c789e70a7c03f89edff7cb28a"
    end
  end

  def install
    bin.install "rgrc"
    generate_completions_from_executable(bin/"rgrc", "--completions")
  end

  def caveats
    <<~EOS
      To enable rgrc aliases, add the following to your ~/.bashrc or ~/.zshrc:

        eval $(rgrc --aliases)
    EOS
  end

  test do
    assert_match "rgrc #{version}", shell_output("#{bin}/rgrc --version")
  end
end
