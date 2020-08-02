class Dhall < Formula
  desc "Interpreter for the Dhall language"
  homepage "https://dhall-lang.org/"
  url "https://hackage.haskell.org/package/dhall-1.33.1/dhall-1.33.1.tar.gz"
  sha256 "53c0c3af567769286c31d13b9a8e98af3600ac6164970e78b70f78f80bc4869e"

  bottle do
    cellar :any_skip_relocation
    sha256 "6c818ff6e93b23d1720dc8e39890f4e2f69b01b1504f2e762bee3b6272c9d60d" => :catalina
    sha256 "3cade6cd99f4fa441f28ae68072c6e57161be89134310a904669aa6c2333d83d" => :mojave
    sha256 "2fadeaf96c94094f29ba6cd5272b596cb78ce62a3590bcf27100ea61b6a59374" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match "{=}", pipe_output("#{bin}/dhall format", "{ = }", 0)
    assert_match "8", pipe_output("#{bin}/dhall normalize", "(\\(x : Natural) -> x + 3) 5", 0)
    assert_match "∀(x : Natural) → Natural", pipe_output("#{bin}/dhall type", "\\(x: Natural) -> x + 3", 0)
  end
end
