class Rgrc < Formula
  desc "Rusty Generic Colouriser - just like grc but fast"
  homepage "https://github.com/lazywalker/rgrc"
  version "0.6.3"
  license "MIT"

  on_arm do
    url "https://github.com/lazywalker/rgrc/releases/download/v#{version}/rgrc-aarch64-apple-darwin.tar.gz"
    sha256 "3d18317eb48435dd85efd7fc98f2c8f53e9e806141998347573a9cbdf3716210"
  end

  on_intel do
    url "https://github.com/lazywalker/rgrc/releases/download/v#{version}/rgrc-x86_64-apple-darwin.tar.gz"
    sha256 "a867d0499bf75ee02c1bce203c4d307176ddf5d3d105cee4be62f84f8ad58f37"
  end

  on_linux do
    url "https://github.com/lazywalker/rgrc/releases/download/v#{version}/rgrc-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "a85dc2d93460027f1fd7b5f88a82b66a8e19a2f234266c4c036b871eea280f5c"
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
