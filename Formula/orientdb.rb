class Orientdb < Formula
  desc "Graph database"
  homepage "https://orientdb.com/"
  url "https://s3.us-east-2.amazonaws.com/orientdb3/releases/3.1.1/orientdb-3.1.1.zip"
  sha256 "1538bfcc5d1a83e8a686be37950a69a2466d19eb824f754367a7b254c56b748f"

  bottle do
    cellar :any_skip_relocation
    sha256 "4dd8ac529ac0d88ebe0924e4c67ab6ec12e516286a503997061586e1c4a19164" => :catalina
    sha256 "4dd8ac529ac0d88ebe0924e4c67ab6ec12e516286a503997061586e1c4a19164" => :mojave
    sha256 "4dd8ac529ac0d88ebe0924e4c67ab6ec12e516286a503997061586e1c4a19164" => :high_sierra
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    rm_rf Dir["bin/*.bat"]

    chmod 0755, Dir["bin/*"]
    libexec.install Dir["*"]

    inreplace "#{libexec}/config/orientdb-server-config.xml", "</properties>",
       <<~EOS
         <entry name="server.database.path" value="#{var}/db/orientdb" />
         </properties>
       EOS
    inreplace "#{libexec}/config/orientdb-server-log.properties", "../log", "#{var}/log/orientdb"
    inreplace "#{libexec}/bin/orientdb.sh", "../log", "#{var}/log/orientdb"
    inreplace "#{libexec}/bin/server.sh", "ORIENTDB_PID=$ORIENTDB_HOME/bin", "ORIENTDB_PID=#{var}/run/orientdb"
    inreplace "#{libexec}/bin/shutdown.sh", "ORIENTDB_PID=$ORIENTDB_HOME/bin", "ORIENTDB_PID=#{var}/run/orientdb"
    inreplace "#{libexec}/bin/orientdb.sh", '"YOUR_ORIENTDB_INSTALLATION_PATH"', libexec
    inreplace "#{libexec}/bin/orientdb.sh", 'su $ORIENTDB_USER -c "cd \"$ORIENTDB_DIR/bin\";', ""
    inreplace "#{libexec}/bin/orientdb.sh", '&"', "&"

    (bin/"orientdb").write_env_script "#{libexec}/bin/orientdb.sh", JAVA_HOME: Formula["openjdk"].opt_prefix
    (bin/"orientdb-console").write_env_script "#{libexec}/bin/console.sh", JAVA_HOME: Formula["openjdk"].opt_prefix
    (bin/"orientdb-gremlin").write_env_script "#{libexec}/bin/gremlin.sh", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  def post_install
    (var/"db/orientdb").mkpath
    (var/"run/orientdb").mkpath
    (var/"log/orientdb").mkpath
    touch "#{var}/log/orientdb/orientdb.err"
    touch "#{var}/log/orientdb/orientdb.log"

    ENV["ORIENTDB_ROOT_PASSWORD"] = "orientdb"
    system "#{bin}/orientdb", "stop"
    sleep 3
    system "#{bin}/orientdb", "start"
    sleep 3
  ensure
    system "#{bin}/orientdb", "stop"
  end

  def caveats
    <<~EOS
      The OrientDB root password was set to 'orientdb'. To reset it:
        https://orientdb.com/docs/last/security/Server-Security.html#restoring-the-servers-user-root
    EOS
  end

  plist_options manual: "orientdb start"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>KeepAlive</key>
            <dict>
              <key>SuccessfulExit</key>
              <false/>
            </dict>
          <key>Label</key>
          <string>homebrew.mxcl.orientdb</string>
          <key>ProgramArguments</key>
          <array>
            <string>/usr/local/opt/orientdb/libexec/bin/server.sh</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>/usr/local/var</string>
          <key>StandardErrorPath</key>
          <string>/usr/local/var/log/orientdb/serror.log</string>
          <key>StandardOutPath</key>
          <string>/usr/local/var/log/orientdb/sout.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    ENV["CONFIG_FILE"] = "#{testpath}/orientdb-server-config.xml"
    ENV["ORIENTDB_ROOT_PASSWORD"] = "orientdb"

    cp "#{libexec}/config/orientdb-server-config.xml", testpath
    inreplace "#{testpath}/orientdb-server-config.xml", "</properties>",
      "  <entry name=\"server.database.path\" value=\"#{testpath}\" />\n    </properties>"

    begin
      assert_match "OrientDB console v.#{version}", pipe_output("#{bin}/orientdb-console \"exit;\"")
    end
  end
end
