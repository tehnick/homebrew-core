class Earthly < Formula
  desc "Build automation tool for the post-container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.3.16.tar.gz"
  sha256 "3950985308acacd20abb81403d7de9a4d3fa99ff36ec48f6f6cbbba33b1a6291"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d25fe8b51480b38c749d86ad00ab06a75fce69149a4f022670cdd17436acd66d" => :big_sur
    sha256 "36738afbd838b9871266cc63cf6f0fdb47d0160c3cfea47fbf8d40b3f4ee9576" => :catalina
    sha256 "b0c36f95bfd7d241df6d9370e1386e67dab5569bd8652f1b09917e968cdd43a6" => :mojave
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.DefaultBuildkitdImage=earthly/buildkitd:v#{version} -X main.Version=v#{version} " \
              "-X main.GitSha=0dd480b951ce169382bad95b9c1d50cfbe36ed12 "
    tags = "dfrunmount dfrunsecurity dfsecrets dfssh dfrunnetwork"
    system "go", "build",
        "-tags", tags,
        "-ldflags", ldflags,
        *std_go_args,
        "-o", bin/"earth",
        "./cmd/earth/main.go"
    bash_output = Utils.safe_popen_read("#{bin}/earth", "bootstrap", "--source", "bash")
    (bash_completion/"earth").write bash_output
    zsh_output = Utils.safe_popen_read("#{bin}/earth", "bootstrap", "--source", "zsh")
    (zsh_completion/"_earth").write zsh_output
  end

  test do
    (testpath/"build.earth").write <<~EOS

      default:
      \tRUN echo Homebrew
    EOS

    output = shell_output("#{bin}/earth --buildkit-host 127.0.0.1 +default 2>&1", 1).strip
    assert_match "Error while dialing invalid address 127.0.0.1", output
  end
end
