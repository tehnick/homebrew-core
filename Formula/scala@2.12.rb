class ScalaAT212 < Formula
  desc "JVM-based programming language"
  homepage "https://www.scala-lang.org/"
  url "https://downloads.lightbend.com/scala/2.12.11/scala-2.12.11.tgz"
  mirror "https://www.scala-lang.org/files/archive/scala-2.12.11.tgz"
  mirror "https://downloads.typesafe.com/scala/2.12.11/scala-2.12.11.tgz"
  sha256 "25afefb0f1a8c2cdc2a35eb7166de2276a4a1f95986d9bfbe18c60183ab36b85"

  bottle :unneeded

  keg_only :versioned_formula

  depends_on "openjdk"

  def install
    rm_f Dir["bin/*.bat"]
    doc.install Dir["doc/*"]
    share.install "man"
    libexec.install "bin", "lib"
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", JAVA_HOME: "${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"

    # Set up an IntelliJ compatible symlink farm in 'idea'
    idea = prefix/"idea"
    idea.install_symlink libexec/"src", libexec/"lib"
    idea.install_symlink doc => "doc"
  end

  def caveats
    <<~EOS
      To use with IntelliJ, set the Scala home to:
        #{opt_prefix}/idea
    EOS
  end

  test do
    file = testpath/"Test.scala"
    file.write <<~EOS
      object Test {
        def main(args: Array[String]) {
          println(s"${2 + 2}")
        }
      }
    EOS

    out = shell_output("#{bin}/scala -nc #{file}").strip

    assert_equal "4", out
  end
end
