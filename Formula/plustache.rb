class Plustache < Formula
  desc "C++ port of Mustache templating system"
  homepage "https://github.com/mrtazz/plustache"
  url "https://github.com/mrtazz/plustache/archive/0.4.0.tar.gz"
  sha256 "83960c412a7c176664c48ba4d718e72b5d39935b24dc13d7b0f0840b98b06824"
  license "MIT"

  bottle do
    cellar :any
    rebuild 1
    sha256 "7a9331bddff426646291a13c0cde40ecc1399acc8a44db3073d6756d56ca5621" => :big_sur
    sha256 "c851f4db6bd4095dd61c1f4a2b192f39b21f05aa8c6e994b9f75d6f183e0bbb8" => :catalina
    sha256 "e6edf87d690e5c17b32a04d0da7ffe6cdf185cb6273a23058c56373b62bd554d" => :mojave
    sha256 "046e756acf6694ae9b8768c62981f807a93aaef52d175bbff7005a29bb23aa00" => :high_sierra
  end

  deprecate! because: :repo_archived

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "boost"

  def install
    system "autoreconf", "--force", "--install"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
