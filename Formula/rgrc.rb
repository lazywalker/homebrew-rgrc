class Rgrc < Formula
  desc "Rusty Generic Colouriser - just like grc but fast"
  homepage "https://github.com/lazywalker/rgrc"
  version "0.5.1"
  license "MIT"

  on_arm do
    url "https://github.com/lazywalker/rgrc/releases/download/v#{version}/rgrc-aarch64-apple-darwin.tar.gz"
    sha256 "61064bf9b3f3c3409a8426b33ef87a94d64502057bfd43ca8a1af8e7dc401833"
  end

  on_intel do
    url "https://github.com/lazywalker/rgrc/releases/download/v#{version}/rgrc-x86_64-apple-darwin.tar.gz"
    sha256 "c51fb4b9754459610490ec8c36c1de87641b43bf42b1a1d097237ba1347fece2"
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
