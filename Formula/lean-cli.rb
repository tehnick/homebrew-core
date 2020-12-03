class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps"
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.24.1.tar.gz"
  sha256 "776e27a24154df1d76e02f4616679fa60574b348b5ad4ce0529ed94d8e95fb84"
  license "Apache-2.0"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "37307a9c7b19652f01f6bcfde9761a10a6a58d64bee4572a8d4c052d9e9f43b3" => :big_sur
    sha256 "4011a3d09cb6e9aa4eaa820ad405475736b9d3640b0ae83d6eb6072ed06b5dc3" => :catalina
    sha256 "79c4108925461654d12481c9e8249ee8e4d3c964781dc95275fbf45251f75418" => :mojave
  end

  depends_on "go" => :build

  def install
    build_from = build.head? ? "homebrew-head" : "homebrew"
    system "go", "build",
            "-ldflags", "-X main.pkgType=#{build_from}",
            *std_go_args,
            "-o", bin/"lean",
            "./lean"

    bash_completion.install "misc/lean-bash-completion" => "lean"
    zsh_completion.install "misc/lean-zsh-completion" => "_lean"
  end

  test do
    assert_match "lean version #{version}", shell_output("#{bin}/lean --version")
    assert_match "Please login first.", shell_output("#{bin}/lean init 2>&1", 1)
  end
end
