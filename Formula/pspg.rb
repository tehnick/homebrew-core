class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/3.1.4.tar.gz"
  sha256 "a3a8e906aef3d8d9b92d290bb819a1232f6850c9933591cc8d35cca7fcdae2ec"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "f34e38bfca35c87d0123abf9c8e5918e798b138e599ff04f0460b9f268856673" => :catalina
    sha256 "1cccf7bdc7938ec157d88c2dd0d5b692905cd6b89aae11c06419ddc086f6ac89" => :mojave
    sha256 "a12012984efe2e0783cf08986837b09c393bcabd4eb800fe1286e4e4ad458210" => :high_sierra
  end

  depends_on "libpq"
  depends_on "ncurses"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      Add the following line to your psql profile (e.g. ~/.psqlrc)
        \\setenv PAGER pspg
        \\pset border 2
        \\pset linestyle unicode
    EOS
  end

  test do
    assert_match "pspg-#{version.to_f}", shell_output("#{bin}/pspg --version", 1)
  end
end
