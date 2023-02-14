require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.23.1.tgz"
  sha256 "a59199a16f1a9465484bd7cf30e21790154829c023337632a5ebbf87d79114c1"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "ebc036965fe0528e816ba5fe7dc40757dd69aef902cea068f9516fb2482534c3"
    sha256                               arm64_monterey: "1fc8c7805b318435413e00dbd81915bf8d0139d0139a05601f8d0019a37b6054"
    sha256                               arm64_big_sur:  "bb768a9fd1a578bc4f63d2a134d0b5a2ab10e1d01d29f7f24c05e890e8fa4605"
    sha256 cellar: :any_skip_relocation, ventura:        "1a470b849908ce4808d60cc898482beae8e7461e89ad15299f3a7061eef5a4e9"
    sha256 cellar: :any_skip_relocation, monterey:       "1a470b849908ce4808d60cc898482beae8e7461e89ad15299f3a7061eef5a4e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a470b849908ce4808d60cc898482beae8e7461e89ad15299f3a7061eef5a4e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5963abd224fe83e206f4c00092ba214593d78949755d800f0a560a49339cc02a"
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/firebase login:ci --no-localhost
      expect "Paste"
    EOS
    assert_match "authorization code", shell_output("expect -f test.exp")
  end
end
