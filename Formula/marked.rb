require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-1.2.0.tgz"
  sha256 "829b625b352e4e6624135be69873be0e198108b6f75693b8c70de44fe5a5a848"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d3a6810e261aa7bd3545d4bdd20929e91dea8032c488872a31c3c469196d3506" => :catalina
    sha256 "3a71aa89794f719c5e39ee0784cb786eaf6de137bd9b007116bc5954268f67d6" => :mojave
    sha256 "ddbffdc93e817d1cb8a9337f5be049423931084ef4bcd9f9d1866f226c0dd228" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", pipe_output("#{bin}/marked", "hello *world*").strip
  end
end
