class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https://pre-commit.com/"
  url "https://files.pythonhosted.org/packages/68/48/a9e83e69632ef71ba108b96252f415cf248fb189563b61df528838e41ae5/pre_commit-2.9.2.tar.gz"
  sha256 "e31c04bc23741194a7c0b983fe512801e151a0638c6001c49f2bd034f8a664a1"
  license "MIT"

  bottle do
    cellar :any
    sha256 "0a29e802042256d365d346c24e11a8077e2589e512ced7c6c78ba91025f4798a" => :big_sur
    sha256 "1f5b8f36ad2e4b17968280dd0eaf2010e476d28bf99d8dce42905c48a123926d" => :catalina
    sha256 "e0ac4ae7653109be1d2a5a2cbdddca683105967eff598e0a9d009ad6bf3aa318" => :mojave
  end

  depends_on "libyaml"
  depends_on "python@3.9"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "cfgv" do
    url "https://files.pythonhosted.org/packages/63/75/c80804e4a5eccc9acf767faf4591bb7ab289485ba236dfee542467dc7c9b/cfgv-3.2.0.tar.gz"
    sha256 "cf22deb93d4bcf92f345a5c3cd39d3d41d6340adc60c78bbbd6588c384fda6a1"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/2f/83/1eba07997b8ba58d92b3e51445d5bf36f9fba9cb8166bcae99b9c3464841/distlib-0.3.1.zip"
    sha256 "edf6116872c863e1aa9d5bb7cb5e05a022c519a4594dc703843343a9ddd9bff1"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/14/ec/6ee2168387ce0154632f856d5cc5592328e9cf93127c5c9aeca92c8c16cb/filelock-3.0.12.tar.gz"
    sha256 "18d82244ee114f543149c66a6e0c14e9c4f8a1044b5cdaadd0f82159d6a6ff59"
  end

  resource "identify" do
    url "https://files.pythonhosted.org/packages/81/2d/e9ca41910763d4c9f3fd6773baafb513f14b3f1281723eed924847ea1f47/identify-1.5.10.tar.gz"
    sha256 "943cd299ac7f5715fcb3f684e2fc1594c1e0f22a90d15398e5888143bd4144b5"
  end

  resource "nodeenv" do
    url "https://files.pythonhosted.org/packages/2f/15/d1eb0d2664e57da61622a815efe7a88db68c7a593fb86bd7cc629fc31c76/nodeenv-1.5.0.tar.gz"
    sha256 "ab45090ae383b716c4ef89e690c41ff8c2b257b85b309f01f3654df3d084bd7c"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz"
    sha256 "b8eac752c5e14d3eca0e6dd9199cd627518cb5ec06add0de9d32baeee6fe645d"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/49/63/8e16d7f59ec7be34fbf57f9935e3ce1ab8b96cb6f1609ff30f16bbe7cf0d/virtualenv-20.2.1.tar.gz"
    sha256 "e0aac7525e880a429764cefd3aaaff54afb5d9f25c82627563603f5d7de5a6e5"
  end

  def install
    # Point hook shebang to virtualenv Python.
    # The global one also works - but may be keg-only.
    # A full path can also move around if we use versioned formulae.
    # Git hooks should only have to be installed once and never need changing.
    inreplace "pre_commit/commands/install_uninstall.py",
              "f'#!/usr/bin/env {py}'",
              "'#!#{opt_libexec}/bin/python3'"

    # Avoid Cellar path reference, which is only good for one version.
    inreplace "pre_commit/commands/install_uninstall.py",
              "'INSTALL_PYTHON': sys.executable",
              "'INSTALL_PYTHON': '#{opt_libexec}/bin/python3'"

    virtualenv_install_with_resources
  end

  # Avoid relative paths
  def post_install
    lib_python_path = Pathname.glob(libexec/"lib/python*").first
    lib_python_path.each_child do |f|
      next unless f.symlink?

      realpath = f.realpath
      rm f
      ln_s realpath, f
    end
  end

  test do
    system "git", "init"
    (testpath/".pre-commit-config.yaml").write <<~EOS
      -   repo: https://github.com/pre-commit/pre-commit-hooks
          sha: v0.9.1
          hooks:
          -   id: trailing-whitespace
    EOS
    system bin/"pre-commit", "install"
    (testpath/"f").write "hi\n"
    system "git", "add", "f"

    ENV["GIT_AUTHOR_NAME"] = "test user"
    ENV["GIT_AUTHOR_EMAIL"] = "test@example.com"
    ENV["GIT_COMMITTER_NAME"] = "test user"
    ENV["GIT_COMMITTER_EMAIL"] = "test@example.com"
    git_exe = which("git")
    ENV["PATH"] = "/usr/bin:/bin"
    system git_exe, "commit", "-m", "test"
  end
end
