class PostgresqlAT12 < Formula
  desc "Object-relational database system"
  homepage "https://www.postgresql.org/"
  url "https://ftp.postgresql.org/pub/source/v12.5/postgresql-12.5.tar.bz2"
  sha256 "bd0d25341d9578b5473c9506300022de26370879581f5fddd243a886ce79ff95"
  license "PostgreSQL"

  bottle do
    sha256 "6e1717130028267c3f8c3910e10909fde608892da4af2669842da0dca386392a" => :big_sur
    sha256 "197b8aed9485281f776878374357955084177c0a28fd7ddcc8c8f4f24f749c63" => :catalina
    sha256 "b00c52d0070387e5eb4a2057e634ba637cb71eccc97aff7999cb3a8600cba1fe" => :mojave
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "icu4c"

  # GSSAPI provided by Kerberos.framework crashes when forked.
  # See https://github.com/Homebrew/homebrew-core/issues/47494.
  depends_on "krb5"

  depends_on "openssl@1.1"
  depends_on "readline"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "perl"

  on_linux do
    depends_on "util-linux"
  end

  def install
    ENV.prepend "LDFLAGS", "-L#{Formula["openssl@1.1"].opt_lib} -L#{Formula["readline"].opt_lib}"
    ENV.prepend "CPPFLAGS", "-I#{Formula["openssl@1.1"].opt_include} -I#{Formula["readline"].opt_include}"

    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --datadir=#{opt_pkgshare}
      --libdir=#{opt_lib}
      --includedir=#{opt_include}
      --sysconfdir=#{etc}
      --docdir=#{doc}
      --enable-thread-safety
      --with-bonjour
      --with-gssapi
      --with-icu
      --with-ldap
      --with-libxml
      --with-libxslt
      --with-openssl
      --with-pam
      --with-perl
      --with-tcl
      --with-uuid=e2fs
    ]

    # PostgreSQL by default uses xcodebuild internally to determine this,
    # which does not work on CLT-only installs.
    args << "PG_SYSROOT=#{MacOS.sdk_path}" if MacOS.sdk_root_needed?

    system "./configure", *args

    # Work around busted path magic in Makefile.global.in. This can't be specified
    # in ./configure, but needs to be set here otherwise install prefixes containing
    # the string "postgres" will get an incorrect pkglibdir.
    # See https://github.com/Homebrew/homebrew-core/issues/62930#issuecomment-709411789
    system "make", "pkglibdir=#{lib}/postgresql"
    system "make", "install-world", "datadir=#{pkgshare}",
                                    "libdir=#{lib}",
                                    "pkglibdir=#{lib}/postgresql",
                                    "includedir=#{include}",
                                    "pkgincludedir=#{include}/postgresql",
                                    "includedir_server=#{include}/postgresql/server",
                                    "includedir_internal=#{include}/postgresql/internal"
  end

  def post_install
    return if ENV["CI"]

    (var/"log").mkpath
    (var/"postgres").mkpath
    unless File.exist? "#{var}/postgres/PG_VERSION"
      system "#{bin}/initdb", "--locale=C", "-E", "UTF-8", "#{var}/postgres"
    end
  end

  def caveats
    <<~EOS
      To migrate existing data from a previous major version of PostgreSQL run:
        brew postgresql-upgrade-database

      This formula has created a default database cluster with:
        initdb --locale=C -E UTF-8 #{var}/postgres
      For more details, read:
        https://www.postgresql.org/docs/#{version.major}/app-initdb.html
    EOS
  end

  plist_options manual: "pg_ctl -D #{HOMEBREW_PREFIX}/var/postgres@12 start"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/postgres</string>
          <string>-D</string>
          <string>#{var}/postgres</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/postgres.log</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/postgres.log</string>
      </dict>
      </plist>
    EOS
  end

  test do
    system "#{bin}/initdb", testpath/"test" unless ENV["CI"]
    assert_equal opt_pkgshare.to_s, shell_output("#{bin}/pg_config --sharedir").chomp
    assert_equal opt_lib.to_s, shell_output("#{bin}/pg_config --libdir").chomp
    assert_equal "#{lib}/postgresql", shell_output("#{bin}/pg_config --pkglibdir").chomp
  end
end
