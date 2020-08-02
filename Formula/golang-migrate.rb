class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://github.com/golang-migrate/migrate/archive/v4.12.1.tar.gz"
  sha256 "df216d3df6461a6cfacf465296b3289db247b685b474296666d58555cf8e4752"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "62cf713c758f56e8735a21086f1c540c0849fb77fda388ca460595e24db74ff2" => :catalina
    sha256 "408dedb80f6d48d5475e330afaa2d86602ddeed27ab96ae52d24cc726130534c" => :mojave
    sha256 "66fc81f0cda23240ef32151033d4b2081ac402f6883fe0e55663403bafc52157" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "VERSION=v#{version}"
    bin.install "migrate"
  end

  test do
    touch "0001_migtest.up.sql"
    output = shell_output("#{bin}/migrate -database stub: -path . up 2>&1")
    assert_match "1/u migtest", output
  end
end
