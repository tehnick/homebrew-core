require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.54.tgz"
  sha256 "8be1856783613251c90b2025b4d7bc0f5970c483ed83cbc0484f79b1647ef0b8"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "5b23eeacb772b093b241f8ec677add5fd0861310be4fc78f579ba8617fea9cd6" => :big_sur
    sha256 "f5c145c4ec1678f210a915074e38eb5d1c7a327d14a1b12ca1ca7933fa32cd5a" => :catalina
    sha256 "bc4bb76c0f90e575342e75ca0d840c69eb8f53eb7a72c630756c517f1e35ffb5" => :mojave
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
