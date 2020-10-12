class V8 < Formula
  desc "Google's JavaScript engine"
  homepage "https://github.com/v8/v8/wiki"
  # Track V8 version from Chrome stable: https://omahaproxy.appspot.com
  url "https://github.com/v8/v8/archive/8.5.210.26.tar.gz"
  sha256 "da33d3f6b08a721677d0218fa5d2120182ed68d0c80ba64c04f0ea54f803d371"
  license "BSD-3-Clause"

  livecheck do
    url "https://omahaproxy.appspot.com/all.json?os=mac&channel=stable"
    regex(/"v8_version": "v?(\d+(?:\.\d+)+)"/i)
  end

  bottle do
    cellar :any
    sha256 "e498d612cfedf5ef8bdf472233d1be24c172a934fb2f52bdf68aff7d3d7204a6" => :catalina
    sha256 "ca26e8afaebc8ca27ef16a623b88fbd8ddee0728b06d602691f8ad89730e9ce3" => :mojave
    sha256 "4297909a066df47db302b79206fb71430271f29e5eb6cb68e1662f2a30b0ac32" => :high_sierra
  end

  depends_on "llvm" => :build
  depends_on "ninja" => :build

  depends_on xcode: ["10.0", :build] # required by v8

  # Look up the correct resource revisions in the DEP file of the specific releases tag
  # e.g. for CIPD dependency gn: https://github.com/v8/v8/blob/7.6.303.27/DEPS#L15
  resource "gn" do
    url "https://gn.googlesource.com/gn.git",
      revision: "7d7e8deea36d126397bda2cf924682504271f0e1"
  end

  # e.g.: https://github.com/v8/v8/blob/7.6.303.27/DEPS#L60 for the revision of build for v8 7.6.303.27
  resource "v8/build" do
    url "https://chromium.googlesource.com/chromium/src/build.git",
      revision: "2dc7c7abc04253e340b60fa339151a92519f93d1"

    # revert usage of unsuported libtool option -D (fixes High Sierra support)
    patch do
      url "https://github.com/denoland/chromium_build/commit/56551e71dc0281cc1d9471caf6a02d02f18c830e.patch?full_index=1"
      sha256 "46fea09483c8b5699f47ae5886d933b61bed11bb3cda88212a7467767db0be3c"
    end
  end

  resource "v8/third_party/icu" do
    url "https://chromium.googlesource.com/chromium/deps/icu.git",
      revision: "79326efe26e5440f530963704c3c0ff965b3a4ac"
  end

  resource "v8/base/trace_event/common" do
    url "https://chromium.googlesource.com/chromium/src/base/trace_event/common.git",
      revision: "ef3586804494b7e402b6c1791d5dccdf2971afff"
  end

  resource "v8/third_party/googletest/src" do
    url "https://chromium.googlesource.com/external/github.com/google/googletest.git",
      revision: "4fe018038f87675c083d0cfb6a6b57c274fb1753"
  end

  resource "v8/third_party/jinja2" do
    url "https://chromium.googlesource.com/chromium/src/third_party/jinja2.git",
      revision: "3f90fa05c85718505e28c9c3426c1ba52843b9b7"
  end

  resource "v8/third_party/markupsafe" do
    url "https://chromium.googlesource.com/chromium/src/third_party/markupsafe.git",
      revision: "8f45f5cfa0009d2a70589bcda0349b8cb2b72783"
  end

  resource "v8/third_party/zlib" do
    url "https://chromium.googlesource.com/chromium/src/third_party/zlib.git",
      revision: "02daed1bb93a34cf89d68913f88708228e12a0ab"
  end

  def install
    (buildpath/"build").install resource("v8/build")
    (buildpath/"third_party/jinja2").install resource("v8/third_party/jinja2")
    (buildpath/"third_party/markupsafe").install resource("v8/third_party/markupsafe")
    (buildpath/"third_party/googletest/src").install resource("v8/third_party/googletest/src")
    (buildpath/"base/trace_event/common").install resource("v8/base/trace_event/common")
    (buildpath/"third_party/icu").install resource("v8/third_party/icu")
    (buildpath/"third_party/zlib").install resource("v8/third_party/zlib")

    # Build gn from source and add it to the PATH
    (buildpath/"gn").install resource("gn")
    cd "gn" do
      system "python", "build/gen.py"
      system "ninja", "-C", "out/", "gn"
    end
    ENV.prepend_path "PATH", buildpath/"gn/out"

    # Enter the v8 checkout
    gn_args = {
      is_debug:                     false,
      is_component_build:           true,
      v8_use_external_startup_data: false,
      v8_enable_i18n_support:       true, # enables i18n support with icu
      # uses homebrew llvm clang instead of Google's custom one
      clang_base_path:              "\"#{Formula["llvm"].prefix}\"",
      clang_use_chrome_plugins:     false, # disable the usage of Google's custom clang plugins
      use_custom_libcxx:            false, # uses system libc++ instead of Google's custom one
      treat_warnings_as_errors:     false,
    }

    # overwrite Chromium minimum sdk version of 10.15
    ENV["FORCE_MAC_SDK_MIN"] = "10.13"
    # link against system libc++ instead of llvm provided libc++
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib

    # Transform to args string
    gn_args_string = gn_args.map { |k, v| "#{k}=#{v}" }.join(" ")

    # Build with gn + ninja
    system "gn", "gen", "--args=#{gn_args_string}", "out.gn"
    system "ninja", "-j", ENV.make_jobs, "-C", "out.gn", "-v", "d8"

    # Install all the things
    (libexec/"include").install Dir["include/*"]
    libexec.install Dir["out.gn/lib*.dylib", "out.gn/d8", "out.gn/icudtl.dat"]
    bin.write_exec_script libexec/"d8"
  end

  test do
    assert_equal "Hello World!", shell_output("#{bin}/d8 -e 'print(\"Hello World!\");'").chomp
    t = "#{bin}/d8 -e 'print(new Intl.DateTimeFormat(\"en-US\").format(new Date(\"2012-12-20T03:00:00\")));'"
    assert_match %r{12/\d{2}/2012}, shell_output(t).chomp

    (testpath/"test.cpp").write <<~'EOS'
      #include <libplatform/libplatform.h>
      #include <v8.h>
      int main(){
        static std::unique_ptr<v8::Platform> platform = v8::platform::NewDefaultPlatform();
        v8::V8::InitializePlatform(platform.get());
        v8::V8::Initialize();
        return 0;
      }
    EOS

    # link against installed libc++
    system ENV.cxx, "-std=c++11", "test.cpp",
      "-I#{libexec}/include",
      "-L#{libexec}", "-lv8", "-lv8_libplatform"
  end
end
