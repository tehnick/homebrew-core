class LibbitcoinClient < Formula
  desc "Bitcoin Client Query Library"
  homepage "https://github.com/libbitcoin/libbitcoin-client"
  url "https://github.com/libbitcoin/libbitcoin-client/archive/v3.6.0.tar.gz"
  sha256 "75969ac0a358458491b101cae784de90452883b5684199d3e3df619707802420"
  license "AGPL-3.0"
  revision 4

  bottle do
    cellar :any
    sha256 "b30c1fd90b3ba80f002950486891a669eaf5418e763cbb15f2d58f406775563d" => :catalina
    sha256 "310d8bb305ce06cde2354fa1b93c89b037ec166892b8386aa9b130a6366e6a46" => :mojave
    sha256 "4a3d2184f8e7b81fb4262b2f3fcae060dc42eabb46b5ea24011be070e65ac2bd" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libbitcoin-protocol"

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libbitcoin"].opt_libexec/"lib/pkgconfig"

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <bitcoin/client.hpp>
      class stream_fixture
        : public libbitcoin::client::stream
      {
      public:
        libbitcoin::data_stack out;

        virtual int32_t refresh() override
        {
          return 0;
        }

        virtual bool read(stream& stream) override
        {
          return false;
        }

        virtual bool write(const libbitcoin::data_stack& data) override
        {
          out = data;
          return true;
        }
      };
      static std::string to_string(libbitcoin::data_slice data)
      {
        return std::string(data.begin(), data.end()) + "\0";
      }
      static void remove_optional_delimiter(libbitcoin::data_stack& stack)
      {
        if (!stack.empty() && stack.front().empty())
          stack.erase(stack.begin());
      }
      static const uint32_t test_height = 0x12345678;
      static const char address_satoshi[] = "1PeChFbhxDD9NLbU21DfD55aQBC4ZTR3tE";
      #define PROXY_TEST_SETUP \
        static const uint32_t retries = 0; \
        static const uint32_t timeout_ms = 2000; \
        static const auto on_error = [](const libbitcoin::code&) {}; \
        static const auto on_unknown = [](const std::string&) {}; \
        stream_fixture capture; \
        libbitcoin::client::proxy proxy(capture, on_unknown, timeout_ms, retries)
      #define HANDLE_ROUTING_FRAMES(stack) \
        remove_optional_delimiter(stack);
      int main() {
        PROXY_TEST_SETUP;

        const auto on_reply = [](const libbitcoin::chain::history::list&) {};
        proxy.blockchain_fetch_history3(on_error, on_reply, libbitcoin::wallet::payment_address(address_satoshi), test_height);

        HANDLE_ROUTING_FRAMES(capture.out);
        assert(capture.out.size() == 3u);
        assert(to_string(capture.out[0]) == "blockchain.fetch_history3");
        assert(libbitcoin::encode_base16(capture.out[2]) == "f85beb6356d0813ddb0dbb14230a249fe931a13578563412");
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test",
                    "-L#{Formula["libbitcoin"].opt_lib}", "-lbitcoin",
                    "-L#{lib}", "-lbitcoin-client",
                    "-L#{Formula["boost"].opt_lib}", "-lboost_system"
    system "./test"
  end
end
