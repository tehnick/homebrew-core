class Kubeaudit < Formula
  desc "Helps audit your Kubernetes clusters against common security controls"
  homepage "https://github.com/Shopify/kubeaudit"
  url "https://github.com/Shopify/kubeaudit/archive/v0.11.6.tar.gz"
  sha256 "12d948da1789087286219b40e439f9688ed37918150e78381b2e1d820512b036"
  license "MIT"
  head "https://github.com/Shopify/kubeaudit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dd32165aba7df729e178e435113fa25b0252913bce4388b3c435c1f2ea1d77af" => :big_sur
    sha256 "253c78f4db9497e15f90cf3ba3ca4a5578a05264c4fbebb59bf82b51bc48d016" => :catalina
    sha256 "af1c1b0dd2b999356ac5a66fb331f17bf54098e0627eb36d7526655a5407a40e" => :mojave
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Shopify/kubeaudit/cmd.Version=#{version}
      -X github.com/Shopify/kubeaudit/cmd.BuildDate=#{Date.today}
    ]

    system "go", "build", "-ldflags", ldflags.join(" "), *std_go_args, "./cmd"
  end

  test do
    output = shell_output(bin/"kubeaudit -c /some-file-that-does-not-exist all 2>&1", 1).chomp
    assert_match "failed to open kubeconfig file /some-file-that-does-not-exist", output
  end
end
