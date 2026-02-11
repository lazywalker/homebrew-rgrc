class Rgrc < Formula
  desc "Rusty Generic Colouriser - just like grc but fast"
  homepage "https://github.com/lazywalker/rgrc"
  version "0.6.9"
  license "MIT"

  on_arm do
    url "https://github.com/lazywalker/rgrc/releases/download/v#{version}/rgrc-aarch64-apple-darwin.tar.gz"
    sha256 "f139d262b79dd2eda56cc77bbe40bab4ee8c1c0bce543d87101822a01a1cc599"
  end

  on_intel do
    url "https://github.com/lazywalker/rgrc/releases/download/v#{version}/rgrc-x86_64-apple-darwin.tar.gz"
    sha256 "7eafaca5dd2d0f41c884c35b6ce2491beb200d47db16c79190aef84b17c3862f"
  end

  on_linux do
    url "https://github.com/lazywalker/rgrc/releases/download/v#{version}/rgrc-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "84937b7a2c90f87b7ff10b0874993f3b79cf4ddfbcad8c45b25aae7033da4ba3"
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
