class CloudformationCli < Formula
  include Language::Python::Virtualenv

  desc "CloudFormation Provider Development Toolkit"
  homepage "https://github.com/aws-cloudformation/cloudformation-cli/"
  url "https://files.pythonhosted.org/packages/e9/87/b83a65ada8cd1ff9e4dfc32ede7e352bd3f81d6bbfbfdd99d3abc9e37467/cloudformation-cli-0.1.14.tar.gz"
  sha256 "66579a36b4d70740408f6019bdb122f610160ab720b0d6bb49cd50e78a7c834a"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "2a2e1f54887c31331dfc7ed1f496db8be7bbe5ca597fdb9374348df63981cf76" => :big_sur
    sha256 "aa6ab9218fbfba3c3855958c684da7813f5ac2b16ad3e7ec22670ebdb1f0f46b" => :catalina
    sha256 "73dc08baa1b68f8db15ebb2f6e9ae83768719f68cf89dbe30dec803b33e27f41" => :mojave
  end

  depends_on "go" => :test
  depends_on "python@3.9"

  uses_from_macos "expect" => :test

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/f0/cb/80a4a274df7da7b8baf083249b0890a0579374c3d74b5ac0ee9291f912dc/attrs-20.3.0.tar.gz"
    sha256 "832aa3cde19744e49938b91fea06d69ecb9e649c93ba974535d08ad92164f700"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/1a/ec/b970ae04958b51dab82b848ede21bbf98ef927a158aa968f6d082f18bd6c/boto3-1.16.20.tar.gz"
    sha256 "6c5d952f97e13997b1c7463038d96469355595cd37f87b43451759cc03756322"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/63/64/83904cc34441fc59d493923a6a9595a87a58c40ae36e25cd447ce6b83cee/botocore-1.19.20.tar.gz"
    sha256 "00a69a507e8b817d0703c612131e6cb3a3260579d0353c56d005bd9effd92ec0"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/e6/de/879cf857ae6f890dfa23c3d6239814c5471936b618c8fb0c8732ad5da885/certifi-2020.11.8.tar.gz"
    sha256 "f05def092c44fbf25834a51509ef6e631dc19765ab8a57b4e7ab85531f0a9cf4"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "cloudformation-cli-go-plugin" do
    url "https://files.pythonhosted.org/packages/3e/b3/6ff86d7ff82e5fa1419209ddb4e0225fd47ba21c3efc480259d8c3501c46/cloudformation-cli-go-plugin-2.0.3.tar.gz"
    sha256 "c621f0c9f85e830b5a6de02a82fad3088923e7237a50c4c982531ed4943da15f"
  end

  resource "cloudformation-cli-java-plugin" do
    url "https://files.pythonhosted.org/packages/42/0d/b114a517b42a4c0dc8771720075f6524e2ba2195a936dd9e888947fe5634/cloudformation-cli-java-plugin-2.0.2.tar.gz"
    sha256 "90f72cf405d6f484a34a7a6027137e5f91ecce01adb380f3acb960265c5dacc3"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/b3/48/014af5285463adb8079f32f603c0d6d19c16d92a113ebacc6b07522dcff5/docker-4.3.1.tar.gz"
    sha256 "bad94b8dd001a8a4af19ce4becc17f41b09f228173ffe6a4e0355389eef142f2"
  end

  resource "hypothesis" do
    url "https://files.pythonhosted.org/packages/59/5e/b12e12ce567ca4d1983d621cd8d49d7747785ea13bbf7de33ca34bcb438d/hypothesis-5.41.2.tar.gz"
    sha256 "f8c281355aaba1da696e40f1488c2bb47c42660424f5750daea45a85e2d047b3"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/23/a2/97899f6bd0e873fed3a7e67ae8d3a08b21799430fb4da15cfedf10d6e2c2/iniconfig-1.1.1.tar.gz"
    sha256 "bc3af051d7d14b2ee5ef9969666def0cd1a000e121eaea580d4a313df4b37f32"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/64/a7/45e11eebf2f15bf987c3bc11d37dcc838d9dc81250e67e4c5968f6008b6c/Jinja2-2.11.2.tar.gz"
    sha256 "89aab215427ef59c34ad58735269eb58b1a5808103067f7bb9d5836c651b3bb0"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/69/11/a69e2a3c01b324a77d3a7c0570faa372e8448b666300c4117a516f8b1212/jsonschema-3.2.0.tar.gz"
    sha256 "c8a85b28d377cc7737e46e2d9f2b4f44ee3c0e1deac6bf46ddefc7187d30797a"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/b9/2e/64db92e53b86efccfaea71321f597fa2e1b2bd3853d8ce658568f7a13094/MarkupSafe-1.1.1.tar.gz"
    sha256 "29872e92839765e546828bb7754a68c418d927cd064fd4708fab9fe9c8bb116b"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/55/fd/fc1aca9cf51ed2f2c11748fa797370027babd82f87829c7a8e6dbe720145/packaging-20.4.tar.gz"
    sha256 "4357f74f47b9c12db93624a82154e9b120fa8293699949152b22065d556079f8"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f8/04/7a8542bed4b16a65c2714bf76cf5a0b026157da7f75e87cc88774aa10b14/pluggy-0.13.1.tar.gz"
    sha256 "15b2acde666561e1298d71b523007ed7364de07029219b604cf808bfa1c765b0"
  end

  resource "py" do
    url "https://files.pythonhosted.org/packages/97/a6/ab9183fe08f69a53d06ac0ee8432bc0ffbb3989c575cc69b73a0229a9a99/py-1.9.0.tar.gz"
    sha256 "9ca6883ce56b4e8da7e79ac18787889fa5206c79dcc67fb065376cd2fe03f342"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/4d/70/fd441df751ba8b620e03fd2d2d9ca902103119616f0f6cc42e6405035062/pyrsistent-0.17.3.tar.gz"
    sha256 "2e636185d9eb976a18a8a8e96efce62f2905fea90041958d8cc2a189756ebf3e"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/d4/df/bd7c25c4fe809a17315b3fc9878edf48d31dde7b431b6836848b063c0428/pytest-6.1.2.tar.gz"
    sha256 "c0a7e94a8cdbc5422a51ccdad8e6f1024795939cc89159a0ae7f0b316ad3823e"
  end

  resource "pytest-localserver" do
    url "https://files.pythonhosted.org/packages/6c/b3/db8f8700718fbefaa2e8b2ef690fec147e560ce92e2300cdb3ff462d313c/pytest-localserver-0.5.0.tar.gz"
    sha256 "3a5427909d1dfda10772c1bae4b9803679c0a8f04adb66c338ac607773bfefc2"
  end

  resource "pytest-random-order" do
    url "https://files.pythonhosted.org/packages/f4/70/e9f80dcbddfc131704d381fd3dc7822a1652765a1b88326a8d84bdc44738/pytest-random-order-1.0.4.tar.gz"
    sha256 "6b2159342a4c8c10855bc4fc6d65ee890fc614cb2b4ff688979b008a82a0ff52"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz"
    sha256 "b8eac752c5e14d3eca0e6dd9199cd627518cb5ec06add0de9d32baeee6fe645d"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9f/14/4a6542a078773957aa83101336375c9597e6fe5889d20abda9c38f9f3ff2/requests-2.25.0.tar.gz"
    sha256 "7f1a0b932f4a60a1a65caa4263921bb7d9ee911957e0ae4a23a6dd08185ad5f8"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/50/de/2b688c062107942486c81a739383b1432a72717d9a85a6a1a692f003c70c/s3transfer-0.3.3.tar.gz"
    sha256 "921a37e2aefc64145e7b73d50c71bb4f26f46e4c9f414dc648c6245ff92cf7db"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/31/a9/b61190916030ee9af83de342e101f192bbb436c59be20a4cb0cdb7256ece/semver-2.13.0.tar.gz"
    sha256 "fa0fe2722ee1c3f57eac478820c3a5ae2f624af8264cbdf9000c980ff7f75e3f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/14/10/6a9481890bae97da9edd6e737c9c3dec6aea3fc2fa53b0934037b35c89ea/sortedcontainers-2.3.0.tar.gz"
    sha256 "59cc937650cf60d677c16775597c89a960658a09cf7c1a668f86e1e4464b10a1"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/29/e6/d1a1d78c439cad688757b70f26c50a53332167c364edb0134cadd280e234/urllib3-1.26.2.tar.gz"
    sha256 "19188f96923873c92ccb987120ec4acaa12f0461fa9ce5d3d0772bc965a39e08"
  end

  resource "websocket_client" do
    url "https://files.pythonhosted.org/packages/8b/0f/52de51b9b450ed52694208ab952d5af6ebbcbce7f166a48784095d930d8c/websocket_client-0.57.0.tar.gz"
    sha256 "d735b91d6d1692a6a181f2a8c9e0238e5f6373356f561bb9dc4c7af36f452010"
  end

  resource "Werkzeug" do
    url "https://files.pythonhosted.org/packages/10/27/a33329150147594eff0ea4c33c2036c0eadd933141055be0ff911f7f8d04/Werkzeug-1.0.1.tar.gz"
    sha256 "6c80b1e5ad3665290ea39320b91e1be1e0d5f60652b964a3070216de83d2e47c"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/cfn"
  end

  def caveats
    <<~EOS
      cloudformation java and go plugins are installed, but the Go and Java are not bundled with the installation.
    EOS
  end

  test do
    script = (testpath/"test.sh")
    script.write <<~EOS
      #!/usr/bin/env expect -f
      set timeout -1

      spawn #{bin}/cfn init

      expect -exact "What's the name of your resource type?"
      send -- "brew::formula::test\r"

      expect -exact "Select a language for code generation:"
      send -- "1\r"

      expect -exact "Enter the GO Import path"
      send -- "\r"

      expect -exact "Initialized a new project in"
      expect eof
    EOS

    script.chmod 0700
    system "./test.sh"

    rpdk_config = JSON.parse(File.read(testpath/".rpdk-config"))
    assert_equal "brew::formula::test", rpdk_config["typeName"]
    assert_equal "go", rpdk_config["language"]
  end
end
