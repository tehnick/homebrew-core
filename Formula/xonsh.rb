class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh/"
  url "https://github.com/xonsh/xonsh/archive/0.9.24.tar.gz"
  sha256 "ed981f129f2501b3d7354466b7c85ff58d22750f18df0910d66c8dbe94ec9b3b"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "715d5eeb40ed888f76ab3c0bbb3123d1cccb2ff46ccb9fb7607f6917bf788c70" => :big_sur
    sha256 "f151539d535a20d69d0ae170883f83101a09be772421eb3adcc96e2e92b314b7" => :catalina
    sha256 "2a8897561350ada2eb6c18919c220cf360854db84fa06714483954e67d5a83cc" => :mojave
    sha256 "dc3cfbb0128ee2a6bd1a9f8886a4e96c623302cee7b18394189b162a36a55201" => :high_sierra
  end

  depends_on "python@3.9"

  # Resources based on `pip3 install xonsh[ptk,pygments,proctitle]`
  # See https://xon.sh/osx.html#dependencies

  resource "prompt_toolkit" do
    url "https://files.pythonhosted.org/packages/d4/12/7fe77b49d67845a378cfadb484b64218ed09d0e8bf420c663b4fe28f0631/prompt_toolkit-3.0.8.tar.gz"
    sha256 "25c95d2ac813909f813c93fde734b6e44406d1477a9faef7c915ff37d39c0a8c"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/e2/07/25bd93c9c0175adfa5fb1513a20b25e7dd6c9a67c155e19b11b5f3662104/Pygments-2.7.1.tar.gz"
    sha256 "926c3f319eda178d1bd90851e4317e6d8cdb5e292a3386aac9bd75eca29cf9c7"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/5a/0d/dc0d2234aacba6cf1a729964383e3452c52096dc695581248b548786f2b3/setproctitle-1.1.10.tar.gz"
    sha256 "6283b7a58477dd8478fbb9e76defb37968ee4ba47b05ec1c053cb39638bd7398"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
