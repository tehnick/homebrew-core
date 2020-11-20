class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/archive/OTP-23.1.3.tar.gz"
  sha256 "291e0852b71ca593f4015417f6e44c08638633c5af6648bd26582c8590390433"
  license "Apache-2.0"
  head "https://github.com/erlang/otp.git"

  livecheck do
    url :head
    regex(/OTP[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "98d8d1f6afedc3b680ffeb39abd157bca3965caeb4d7c0b2700908215f19864e" => :big_sur
    sha256 "be15e140eaf0cb4f42e37feedb8ba69e05fb0849e3bedc48f1da09581a1bb3d0" => :catalina
    sha256 "a972a8db84e577a77c0b6da689830ca753c2f5f4352f0b70ded496df02d947cf" => :mojave
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@1.1"
  depends_on "wxmac" # for GUI apps like observer

  uses_from_macos "m4" => :build

  resource "html" do
    url "https://www.erlang.org/download/otp_doc_html_23.1.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_23.1.tar.gz"
    sha256 "0e0075f174db2f9b5a0f861263062942e5a721c40ec747356e482e3be2fb8931"
  end

  # Fix for Big Sur, remove in next version
  # https://github.com/erlang/otp/pull/2865
  patch :DATA

  def install
    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligable error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

    # Do this if building from a checkout to generate configure
    system "./otp_build", "autoconf" if File.exist? "otp_build"

    args = %W[
      --disable-debug
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-dynamic-ssl-lib
      --enable-hipe
      --enable-sctp
      --enable-shared-zlib
      --enable-smp-support
      --enable-threads
      --enable-wx
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
      --without-javac
    ]

    on_macos do
      args << "--enable-darwin-64bit"
      args << "--enable-kernel-poll" if MacOS.version > :el_capitan
      args << "--with-dynamic-trace=dtrace" if MacOS::CLT.installed?
    end

    system "./configure", *args
    system "make"
    system "make", "install"

    # Build the doc chunks (manpages are also built by default)
    system "make", "docs", "DOC_TARGETS=chunks"
    system "make", "install-docs"

    doc.install resource("html")
  end

  def caveats
    <<~EOS
      Man pages can be found in:
        #{opt_lib}/erlang/man

      Access them with `erl -man`, or add this directory to MANPATH.
    EOS
  end

  test do
    system "#{bin}/erl", "-noshell", "-eval", "crypto:start().", "-s", "init", "stop"
    (testpath/"factorial").write <<~EOS
      #!#{bin}/escript
      %% -*- erlang -*-
      %%! -smp enable -sname factorial -mnesia debug verbose
      main([String]) ->
          try
              N = list_to_integer(String),
              F = fac(N),
              io:format("factorial ~w = ~w\n", [N,F])
          catch
              _:_ ->
                  usage()
          end;
      main(_) ->
          usage().

      usage() ->
          io:format("usage: factorial integer\n").

      fac(0) -> 1;
      fac(N) -> N * fac(N-1).
    EOS
    chmod 0755, "factorial"
    assert_match "usage: factorial integer", shell_output("./factorial")
    assert_match "factorial 42 = 1405006117752879898543142606244511569936384000000000", shell_output("./factorial 42")
  end
end
__END__
diff --git a/make/configure.in b/make/configure.in
index bf6ee284343..898aa40c4a0 100644
--- a/make/configure.in
+++ b/make/configure.in
@@ -398,7 +398,7 @@ if test $CROSS_COMPILING = no; then
 	       [1-9][0-9].[0-9])
 	          int_macosx_version=`echo $macosx_version | sed 's|\([^\.]*\)\.\([^\.]*\)|\10\200|'`;;
 	       [1-9][0-9].[0-9].[0-9])
-	          int_macosx_version=`echo $macosx_version | sed 's|\([^\.]*\)\.\([^\.]*\)\.\([^\.]*\)|\1\2\3|'`;;
+	          int_macosx_version=`echo $macosx_version | sed 's|\([^\.]*\)\.\([^\.]*\)\.\([^\.]*\)|\10\20\3|'`;;
 	       [1-9][0-9].[1-9][0-9])
 	          int_macosx_version=`echo $macosx_version | sed 's|\([^\.]*\)\.\([^\.]*\)|\1\200|'`;;
 	       [1-9][0-9].[1-9][0-9].[0-9])
