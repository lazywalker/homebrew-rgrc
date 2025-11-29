class Rgrc < Formula
  desc "Rusty Generic Colouriser - just like grc but fast"
  homepage "https://github.com/lazywalker/rgrc"
  version "0.4.3"
  license "MIT"

  on_arm do
    url "https://github.com/lazywalker/rgrc/releases/download/v#{version}/rgrc-aarch64-apple-darwin.zip"
    sha256 "ec4797adae1657dce4e96683275503971035aeeedd9c258db785027a54264702"
  end

  on_intel do
    url "https://github.com/lazywalker/rgrc/releases/download/v#{version}/rgrc-x86_64-apple-darwin.zip"
    sha256 "5b260feb880eb2dd45e62df8cb620f78e2be1a207fb2138d3de144a872ab4950"
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
