class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.30.1.tar.gz"
  sha256 "95c0b856c95185315cdad4b8442b65cd8178664ed36d776813230d2fb15c43ac"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "c690a49f89af1a4adcfec4d4efc804b64113f4c4ef826af828349eeeadf10ce4" => :catalina
    sha256 "bd6c1ad822401704511bb4141bd2b7435e4bb571d4d191fcc16dc4b35e0a085d" => :mojave
    sha256 "e625749b036d7cff56090b1138ce19eabcc70888ce405ea52f193f08a0575794" => :high_sierra
  end

  depends_on "go" => :build

  resource "testfile" do
    url "https://raw.githubusercontent.com/tfsec/tfsec/master/example/brew-validate.tf"
    sha256 "9267e6cac1277992ac521f417c6d552eff3c4606520f584bd8c1ea67ae0880d2"
  end

  def install
    system "scripts/install.sh", "v#{version}"
    bin.install "tfsec"
  end

  test do
    resource("testfile").stage do
      assert_match "No problems detected!", shell_output("#{bin}/tfsec .")
    end
  end
end
