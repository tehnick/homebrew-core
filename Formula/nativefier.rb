require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-9.1.0.tgz"
  sha256 "1614ff9c955c6687f813884b795051e9ffccdbfb8248a0ebf1b6b74cd2b39b35"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "31fe1e9e28f7d558b7da6a49a8e43511dc13cd93dd062503ce62e85ae777e438" => :catalina
    sha256 "65079bebe1c8b2095b9c9e6274a24ad25dc90a891cd9d57c6201928035f8d7eb" => :mojave
    sha256 "63d3c91e07a6141d213f57f4b4143ed994a62b628999eeee5bce68615ec81718" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"nativefier", "--version"
  end
end
