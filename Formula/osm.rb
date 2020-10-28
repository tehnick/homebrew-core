class Osm < Formula
  desc "Open Service Mesh (OSM)"
  homepage "https://openservicemesh.io/"
  url "https://github.com/openservicemesh/osm/archive/v0.4.2.tar.gz"
  sha256 "46fc0ab6b0c057fc61572777ba9807d7d57605ec987e686d057a16ffe4488ad7"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "93b4303c9b2772f4a6d846d813d6c3d64916cd4b6638647312a88c4f05e9a6fb" => :catalina
    sha256 "961123aa215829184855835ea2f13f4f73b4bdddc63be516287a2dac8388431c" => :mojave
    sha256 "2d9be0cb5f1696902925c963e480475e74a48e61dc8d05f6588ce65438514ba8" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build-osm"
    bin.install "bin/osm"
  end

  test do
    assert_match "Error: Could not list namespaces related to osm", shell_output("#{bin}/osm namespace list 2>&1", 1)
  end
end
