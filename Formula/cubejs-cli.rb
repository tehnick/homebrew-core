require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.23.12.tgz"
  sha256 "caad7b3e0aa33d0dfe3cc5487fd0737e8240c7d9c13c5dc024375a770f5d07c2"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "0be080014477ede4484f1d6b61e4ec2f24df5acc4845645709bffa4fafd278c0" => :big_sur
    sha256 "19d98911bc4169dfe458ab1740844e7a886574f4716e07aa906866bcbfb5d740" => :catalina
    sha256 "91cbc4d957fe4f0850378dba0c121041dac927919379722f6fcbbfe6cc77ec51" => :mojave
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system "cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
