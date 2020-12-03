class Rebar < Formula
  desc "Erlang build tool"
  homepage "https://github.com/rebar/rebar"
  url "https://github.com/rebar/rebar/archive/2.6.4.tar.gz"
  sha256 "577246bafa2eb2b2c3f1d0c157408650446884555bf87901508ce71d5cc0bd07"
  license "Apache-2.0"
  head "https://github.com/rebar/rebar.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "17b587b45197068cb021a40a4b8a82c69aac233a5f259986d7ad6bc8c41244b8" => :big_sur
    sha256 "1dca4b3d2760f3806569c7a455beb73508409177fd9a6f22816653f14e80fdee" => :catalina
    sha256 "265cfa8851de8a55ff46346167f8670df48d8a731c427d51fe0da16cf2ee8b78" => :mojave
  end

  deprecate! because: :repo_archived

  depends_on "erlang"

  def install
    system "./bootstrap"
    bin.install "rebar"

    bash_completion.install "priv/shell-completion/bash/rebar"
    zsh_completion.install "priv/shell-completion/zsh/_rebar" => "_rebar"
    fish_completion.install "priv/shell-completion/fish/rebar.fish"
  end

  test do
    system bin/"rebar", "--version"
  end
end
