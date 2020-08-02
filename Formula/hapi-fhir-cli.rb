class HapiFhirCli < Formula
  desc "Command-line interface for the HAPI FHIR library"
  homepage "https://hapifhir.io/hapi-fhir/docs/tools/hapi_fhir_cli.html"
  url "https://github.com/jamesagnew/hapi-fhir/releases/download/v5.0.0/hapi-fhir-5.0.0-cli.zip"
  sha256 "a08877a6d07cd480cc85966ff66025fe378101fedd3a287f9b29813579929214"
  license "Apache-2.0"

  bottle :unneeded

  depends_on "openjdk"

  resource "test_resource" do
    url "https://github.com/jamesagnew/hapi-fhir/raw/v5.0.0/hapi-fhir-structures-dstu3/src/test/resources/specimen-example.json"
    sha256 "4eacf47eccec800ffd2ca23b704c70d71bc840aeb755912ffb8596562a0a0f5e"
  end

  def install
    inreplace "hapi-fhir-cli", /SCRIPTDIR=(.*)/, "SCRIPTDIR=#{libexec}"
    libexec.install "hapi-fhir-cli.jar"
    bin.install "hapi-fhir-cli"
    bin.env_script_all_files libexec/"bin", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  test do
    testpath.install resource("test_resource")
    system bin/"hapi-fhir-cli", "validate", "--file", "specimen-example.json",
           "--fhir-version", "dstu3"
  end
end
