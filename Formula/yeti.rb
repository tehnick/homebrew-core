class Yeti < Formula
  desc "ML-style functional programming language that runs on the JVM"
  homepage "https://mth.github.io/yeti/"
  url "https://github.com/mth/yeti/archive/v1.0.tar.gz"
  sha256 "f1451a7c58cecaee41c46e886eb714a81e0dfe5557c10568421dcbd33ab9357c"
  license "BSD-3-Clause"
  head "https://github.com/mth/yeti.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c352083ddfbf202777d4f8d52895ac2bcb556fd5cc2fc1f820a48bb773b823f" => :catalina
    sha256 "9dffa6798409e7d40acf301547dc8508547331922eaa1b7365a0b04e020ae90f" => :mojave
    sha256 "1c49573337d0ca872a060038e3c7e5496d02b025e442c062314d98a786ab708a" => :high_sierra
  end

  deprecate! because: :does_not_build

  depends_on "ant" => :build
  depends_on "openjdk@8"

  def install
    system "ant", "jar"
    libexec.install "yeti.jar"

    (bin/"yeti").write <<~EOS
      #!/bin/bash
      export JAVA_HOME="#{Language::Java.overridable_java_home_env("1.8")[:JAVA_HOME]}"
      exec "${JAVA_HOME}/bin/java" -server -jar "#{libexec}/yeti.jar" "$@"
    EOS
  end

  test do
    assert_equal "3\n", shell_output("#{bin}/yeti -e 'do x: x+1 done 2'")
  end
end
