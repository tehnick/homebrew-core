class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.26.7.tar.gz"
  sha256 "4188a625c7029c340ee3b5cb224c6573f95dc01e8db42b6ff456abd0087336df"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "4742ccca9d8643fd3f4817916bd611b4a13b74bab89ee821a61a4bbad03a8eb1" => :big_sur
    sha256 "9998ede08576a706d03b081d341f63a6fead85ac48ba4c86741205089ba001d7" => :catalina
    sha256 "d76416e9f4267a21b6d81982e40d51c6cf734840de5918e8394704bd4c0cc411" => :mojave
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", "-ldflags", "-X main.VERSION=v#{version}", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
