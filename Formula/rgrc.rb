class Rgrc < Formula
  desc "Rusty Generic Colouriser - just like grc but fast"
  homepage "https://github.com/lazywalker/rgrc"
  version "0.5.1"
  license "MIT"

  on_arm do
    url "https://github.com/lazywalker/rgrc/releases/download/v#{version}/rgrc-aarch64-apple-darwin.tar.gz"
    sha256 "a7038405e6e5ace5f8e8f15c140baa7a17ff20cec44de2b1de2fd08ac4596c0b"
  end

  on_intel do
    url "https://github.com/lazywalker/rgrc/releases/download/v#{version}/rgrc-x86_64-apple-darwin.tar.gz"
    sha256 "7b5a29842e6c6dc77162b89470a4c6997663277409ed0a8f2dede50b96a37744"
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
