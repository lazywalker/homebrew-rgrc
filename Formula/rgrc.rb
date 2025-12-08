class Rgrc < Formula
  desc "Rusty Generic Colouriser - just like grc but fast"
  homepage "https://github.com/lazywalker/rgrc"
  version "0.6.2"
  license "MIT"

  on_arm do
    url "https://github.com/lazywalker/rgrc/releases/download/v#{version}/rgrc-aarch64-apple-darwin.tar.gz"
    sha256 "98ab6b477cffabfc0e814b660cf2df052e681cdb67cca6860ee685c371097583"
  end

  on_intel do
    url "https://github.com/lazywalker/rgrc/releases/download/v#{version}/rgrc-x86_64-apple-darwin.tar.gz"
    sha256 "fb100b25f6415f922d297c0f6bd1674975d9790a9e63937948d8015e7b39aa60"
  end

  on_linux do
    url "https://github.com/lazywalker/rgrc/releases/download/v#{version}/rgrc-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "071b1b9d148f872faaa8d0c4d4fd2c8548070e9da1f89fe0ff4b2c455b92a824"
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
