class Bandwhich < Formula
  desc "Terminal bandwidth utilization tool"
  homepage "https://github.com/imsnif/bandwhich"
  url "https://github.com/imsnif/bandwhich/archive/0.19.0.tar.gz"
  sha256 "82ad604e2b80d4434633860dd81a1d73cd59d54bde7241f4e86c95900912befc"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "5e2e63384d3ef476fcbfb0f3d292a5192cb85182a35391e95951e2ac75f2130e" => :catalina
    sha256 "e810bdedf226da5643d3bb09eb76f7d2234635d6d0a703550afe4e5d7359fb1e" => :mojave
    sha256 "345584396daed50379aced942c393102cb8c6262564eda99e18159a3f5136bf1" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output "#{bin}/bandwhich --interface bandwhich", 2
    assert_match output, "Error: Cannot find interface bandwhich"
  end
end
