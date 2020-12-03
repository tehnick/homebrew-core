class Luarocks < Formula
  desc "Package manager for the Lua programming language"
  homepage "https://luarocks.org/"
  url "https://luarocks.org/releases/luarocks-3.4.0.tar.gz"
  sha256 "62ce5826f0eeeb760d884ea8330cd1552b5d432138b8bade0fa72f35badd02d0"
  license "MIT"
  revision 1
  head "https://github.com/luarocks/luarocks.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "db3a461587f6a854b66176526ce60cfed456b502f88854e5632ed0a4f89087dd" => :big_sur
    sha256 "3bd30c08dafcabee9db8fbe701cde57f5ae11d333254394dc8d7852766ea6ac0" => :catalina
    sha256 "75b43ab5ea3a697bbc9782f1e2c21cc6ae2c7bfdd9acfedb7b7ad0e5ed5e6e74" => :mojave
  end

  depends_on "lua@5.1" => :test
  depends_on "lua"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--rocks-tree=#{HOMEBREW_PREFIX}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      LuaRocks supports multiple versions of Lua. By default it is configured
      to use Lua#{Formula["lua"].version.major_minor}, but you can require it to use another version at runtime
      with the `--lua-dir` flag, like this:

        luarocks --lua-dir=#{Formula["lua@5.1"].opt_prefix} install say
    EOS
  end

  test do
    ENV["LUA_PATH"] = "#{testpath}/share/lua/5.4/?.lua"
    ENV["LUA_CPATH"] = "#{testpath}/lib/lua/5.4/?.so"

    (testpath/"lfs_54test.lua").write <<~EOS
      require("lfs")
      print(lfs.currentdir())
    EOS

    system "#{bin}/luarocks", "--tree=#{testpath}", "install", "luafilesystem"
    system "lua", "-e", "require('lfs')"
    assert_match testpath.to_s, shell_output("lua lfs_54test.lua")

    ENV["LUA_PATH"] = "#{testpath}/share/lua/5.1/?.lua"
    ENV["LUA_CPATH"] = "#{testpath}/lib/lua/5.1/?.so"

    (testpath/"lfs_51test.lua").write <<~EOS
      require("lfs")
      lfs.mkdir("blank_space")
    EOS

    system "#{bin}/luarocks", "--tree=#{testpath}",
                              "--lua-dir=#{Formula["lua@5.1"].opt_prefix}",
                              "install", "luafilesystem"
    system "lua5.1", "-e", "require('lfs')"
    system "lua5.1", "lfs_51test.lua"
    assert_predicate testpath/"blank_space", :directory?,
      "Luafilesystem failed to create the expected directory"
  end
end
