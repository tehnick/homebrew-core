class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38.git",
    tag:      "1.22.2",
    revision: "5b77c446a767c290d189291ab01aee9685082bc3"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "18e4001cf07554ae26d5d420cd3890b3b6d8b3d74b9cd52cfa252ef2c49c748d" => :catalina
    sha256 "c8a0ffb58b27b60a261cd7312e3660d46e37ff72c45ea8de572489041a7492cf" => :mojave
    sha256 "5f2b08857ba21d9cdc29d44a448d0c4064365dd8063d6f643e065ec68efad458" => :high_sierra
  end

  depends_on "go" => :build

  def datadir
    var/"tile38/data"
  end

  def install
    commit = Utils.safe_popen_read("git", "rev-parse", "--short", "HEAD").chomp

    ldflags = %W[
      -s -w
      -X github.com/tidwall/tile38/core.Version=#{version}
      -X github.com/tidwall/tile38/core.GitSHA=#{commit}
    ]

    system "go", "build", "-o", bin/"tile38-server", "-ldflags", ldflags.join(" "), "./cmd/tile38-server"
    system "go", "build", "-o", bin/"tile38-cli", "-ldflags", ldflags.join(" "), "./cmd/tile38-cli"
  end

  def post_install
    # Make sure the data directory exists
    datadir.mkpath
  end

  def caveats
    <<~EOS
      To connect: tile38-cli
    EOS
  end

  plist_options manual: "tile38-server -d #{HOMEBREW_PREFIX}/var/tile38/data"

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
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/tile38-server</string>
            <string>-d</string>
            <string>#{datadir}</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/tile38.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/tile38.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    pid = fork do
      exec "#{bin}/tile38-server", "-q"
    end
    sleep 2
    # remove `$408` in the first line output
    json_output = shell_output("#{bin}/tile38-cli server").lines[1]
    tile38_server = JSON.parse(json_output)
    assert_equal tile38_server["ok"], true
  ensure
    Process.kill("HUP", pid)
  end
end
