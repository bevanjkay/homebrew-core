class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.22.3",
      revision: "c92036820499fedefec0f847e2054d824aea6cd1"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c2052d6d52db0f36e09245fdb3bd5be5a32a5c505fa7c7c43e83e0d0d659f22"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "172cf98338a33a49f1526596df4c7edbad42ef4a48ae2b3da93902bc6ab06dec"
    sha256 cellar: :any_skip_relocation, monterey:       "30fc88c550453c984201a0cec2c6d1f5c0761ea0815be0504a0f74e88d90322d"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c7bf6d0518f32822dabfe86c0c7a6fd54130024c2e632a0182e70ca4b3d1ab9"
    sha256 cellar: :any_skip_relocation, catalina:       "531bce5f3d91144060aad50b10db2742e40dc93db084d6dbfd4b4bb0a27788ab"
    sha256 cellar: :any_skip_relocation, mojave:         "5a36702c6abeb05683b5c0dc57255c7dfcc49191c0bae0b35b29f62ccb8c71dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "583a1b3a8a0cf82458861dbd683087d58f56fede759db2c34984459388a305d9"
  end

  depends_on "bash" => :build
  depends_on "coreutils" => :build
  depends_on "go@1.16" => :build

  uses_from_macos "rsync" => :build

  def install
    # Don't dirty the git tree
    rm_rf ".brew_home"

    # Make binary
    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin" # needs GNU date
    system "make", "WHAT=cmd/kubectl"
    bin.install "_output/bin/kubectl"

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/kubectl", "completion", "bash")
    (bash_completion/"kubectl").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/kubectl", "completion", "zsh")
    (zsh_completion/"_kubectl").write output

    # Install man pages
    # Leave this step for the end as this dirties the git tree
    system "hack/generate-docs.sh"
    man1.install Dir["docs/man/man1/*.1"]
  end

  test do
    run_output = shell_output("#{bin}/kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", run_output

    version_output = shell_output("#{bin}/kubectl version --client 2>&1")

    assert_match "GitTreeState:\"clean\"", version_output

    if build.stable?
      assert_match stable.instance_variable_get(:@resource)
                         .instance_variable_get(:@specs)[:revision],
                   version_output
    end
  end
end
