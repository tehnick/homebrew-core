class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/archive/v0.4.1488.tar.gz"
  sha256 "ac486cc3aeadd38b49114705d83f15b35dba6886d73ff446e292ba9e791b8330"
  license "MIT"
  head "https://github.com/soimort/you-get.git", branch: "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "75cec9d34b80971178480e7f70b22b649352d447ed638cbadd82019302e8a860" => :big_sur
    sha256 "f51c08fdc10e1606ea6bd6f4f250f9c37369cf67ba87ce3ed04033af51994802" => :catalina
    sha256 "e42333fd481b4199d39e5f613da991506ec14f3f23ef97b8695fa1060626adba" => :mojave
  end

  depends_on "python@3.9"
  depends_on "rtmpdump"

  resource "PySocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    "To use post-processing options, run `brew install ffmpeg` or `brew install libav`."
  end

  test do
    system bin/"you-get", "--info", "https://youtu.be/he2a4xK8ctk"
  end
end
