class Cppman < Formula
  include Language::Python::Virtualenv

  desc "C++ 98/11/14/17/20 manual pages from cplusplus.com and cppreference.com"
  homepage "https://github.com/aitjcize/cppman"
  url "https://files.pythonhosted.org/packages/e4/a0/6c8af0f95dc7fe418f2cf812a8704780f83295235c7f32b12e87e77a79e4/cppman-0.5.1.tar.gz"
  sha256 "a34261da3186d4f13836fec72e32258b82b6fad7d25f353d54ca54e831dd8589"
  license "GPL-3.0"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "003314ab635e36347d9933dede15116782f315be4a9b01fd9d8c9dcae38ce6be" => :big_sur
    sha256 "4b80eea61f0f7c9050c52a076f297a591f3482513350532f00c039a4cba58860" => :catalina
    sha256 "70c43842a449dd2fc325c188a79d48e0465bca0fa3909d92807d4860cb71898b" => :mojave
    sha256 "c8fd2f679703f64dfe3f2cb8a073c10fff3b5db4325291643e07c4c13dc37211" => :high_sierra
  end

  depends_on "python@3.9"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/c6/62/8a2bef01214eeaa5a4489eca7104e152968729512ee33cb5fbbc37a896b7/beautifulsoup4-4.9.1.tar.gz"
    sha256 "73cc4d115b96f79c7d77c1c7f7a0a8d4c57860d1041df407dd1aae7f07a77fd7"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/85/3e/cf449cf1b5004e87510b9368e7a5f1acd8831c2d6691edd3c62a0823f98f/html5lib-1.0.1.tar.gz"
    sha256 "66cb0dcfdbbc4f9c3ba1a63fdb511ffdbd4f513b2b6d81b80cd26ce6b3fb3736"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/3e/db/5ba900920642414333bdc3cb397075381d63eafc7e75c2373bbc560a9fa1/soupsieve-2.0.1.tar.gz"
    sha256 "a59dc181727e95d25f781f0eb4fd1825ff45590ec8ff49eadfd7f1a537cc0232"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "std::extent", shell_output("#{bin}/cppman -f :extent")
  end
end
