class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/v1.0.3.tar.gz"
  sha256 "d79afec4780e6fd9561793a40f5d080d91edf7ea5e3fbeb7c5f8ad6accdd812f"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a405d340893970cf9d9b35e69440fc63f317343b4d4a81a83ca4490630429632" => :big_sur
    sha256 "a56dcb6003dcd52f84f6215689261c900665a421bccade0afac3645b5c4b986e" => :catalina
    sha256 "111fff60ba6bf31d53afc9a2e6571a9d7f4240fbc450da38303f2c092a9b36c4" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "cmd/cfn-format/main.go"
  end

  test do
    (testpath/"test.template").write <<~EOS
      Resources:
        Bucket:
          Type: AWS::S3::Bucket
    EOS
    assert_equal "test.template: formatted OK", shell_output("#{bin}/cfn-format -v test.template").strip
  end
end
