class Rgrc < Formula
  desc "Rusty Generic Colouriser - just like grc but fast"
  homepage "https://github.com/lazywalker/rgrc"
  version "0.6.5"
  license "MIT"

  on_arm do
    url "https://github.com/lazywalker/rgrc/releases/download/v#{version}/rgrc-aarch64-apple-darwin.tar.gz"
    sha256 "72584e3ce763f776cda171b6c8ec5ed22bcc428687a6d65c9cf8ec54d47f6b61"
  end

  on_intel do
    url "https://github.com/lazywalker/rgrc/releases/download/v#{version}/rgrc-x86_64-apple-darwin.tar.gz"
    sha256 "cc1ba96925297d721f6fa126441f5817b6d394317fa4a69ce36a0ca50bdfe4a3"
  end

  on_linux do
    url "https://github.com/lazywalker/rgrc/releases/download/v#{version}/rgrc-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "c53e6718d2c7ecef5caa5b79004e5dfb334089b55911bbacc667686f5df8096d"
  end

  def install
    bin.install "rgrc"
    bin.install "rgrv"
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
