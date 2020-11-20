class Lab < Formula
  desc "Git wrapper for GitLab"
  homepage "https://zaquestion.github.io/lab"
  url "https://github.com/zaquestion/lab/archive/v0.17.2.tar.gz"
  sha256 "467cb35793c4129e7da68e4c63ef5ee96e9ca43f933c88758e90850f0d6c77b9"
  license "CC0-1.0"
  head "https://github.com/zaquestion/lab.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "23d80095f9432435323f48a778cdd0c9a318afd2bacad9556ac6763be5d31ee8" => :big_sur
    sha256 "15c50154f5322e57c48f0242cb5d234922d5dced1eae5b1aed6071c1133a203e" => :catalina
    sha256 "11715b31f5ed38d3e84af0530b354ac86027b08bf89f8f0ec27509b0a1f7c408" => :mojave
    sha256 "08c8bc4ad5de8a819b4d9741bb9c94a923b5373d834d9d88b044053aa5596b24" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -s -w"
    system "go", "build", *std_go_args, "-ldflags=#{ldflags}"
    output = Utils.safe_popen_read("#{bin}/lab", "completion", "bash")
    (bash_completion/"lab").write output
    output = Utils.safe_popen_read("#{bin}/lab", "completion", "zsh")
    (zsh_completion/"_lab").write output
    output = Utils.safe_popen_read("#{bin}/lab", "completion", "fish")
    (fish_completion/"lab.fish").write output
  end

  test do
    ENV["LAB_CORE_USER"] = "test_user"
    ENV["LAB_CORE_HOST"] = "https://gitlab.com"
    ENV["LAB_CORE_TOKEN"] = "dummy"

    ENV["GIT_AUTHOR_NAME"] = "test user"
    ENV["GIT_AUTHOR_EMAIL"] = "test@example.com"
    ENV["GIT_COMMITTER_NAME"] = "test user"
    ENV["GIT_COMMITTER_EMAIL"] = "test@example.com"

    system "git", "init"
    %w[haunted house].each { |f| touch testpath/f }
    system "git", "add", "haunted", "house"
    system "git", "commit", "-a", "-m", "Initial Commit"
    assert_equal "haunted\nhouse", shell_output("#{bin}/lab ls-files").strip
  end
end
