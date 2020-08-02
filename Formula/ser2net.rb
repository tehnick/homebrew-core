class Ser2net < Formula
  desc "Allow network connections to serial ports"
  homepage "https://ser2net.sourceforge.io"
  url "https://downloads.sourceforge.net/project/ser2net/ser2net/ser2net-4.2.0.tar.gz"
  sha256 "1d895f005896e8c5bcff4fe573e2fec3611bf4feee1247857e476b74323d916c"
  license "GPL-2.0"
  revision 1

  bottle do
    cellar :any
    sha256 "1f72aa5bda0313aab823ee8afbb91ea46a39d021b5e38872864481e2b5555a7a" => :catalina
    sha256 "33e6a1c897ab0af156af1554be2391fdfbb3a9bd3cc29fc8be34ab44e2de8595" => :mojave
    sha256 "217b9ded1b3e0a8566db9cf67e15112f5aebffbe74b429f75b22581f19046fa8" => :high_sierra
  end

  depends_on "libyaml"
  depends_on macos: :sierra # needs clock_gettime

  resource "gensio" do
    url "https://downloads.sourceforge.net/project/ser2net/ser2net/gensio-2.1.2.tar.gz"
    sha256 "4b84c81376bcc557818d771a995fc0dddf77f146365a836c70c3d4c55f503dbc"
  end

  def install
    resource("gensio").stage do
      system "./configure", "--with-python=no",
                            "--disable-dependency-tracking",
                            "--prefix=#{libexec}/gensio"
      system "make", "install"
    end

    ENV.append_path "PKG_CONFIG_PATH", "#{libexec}/gensio/lib/pkgconfig"
    ENV.append_path "CFLAGS", "-I#{libexec}/gensio/include"
    ENV.append_path "LDFLAGS", "-L#{libexec}/gensio/lib"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"

    system "make", "install"

    (etc/"ser2net").install "ser2net.yaml"
  end

  def caveats
    <<~EOS
      To configure ser2net, edit the example configuration in #{etc}/ser2net/ser2net.yaml
    EOS
  end

  plist_options manual: "ser2net -p 12345"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <true/>
          <key>ProgramArguments</key>
          <array>
              <string>#{opt_sbin}/ser2net</string>
              <string>-p</string>
              <string>12345</string>
          </array>
          <key>WorkingDirectory</key>
          <string>#{HOMEBREW_PREFIX}</string>
        </dict>
      </plist>
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/ser2net -v")
  end
end
