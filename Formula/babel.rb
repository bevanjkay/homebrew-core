require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.21.0.tgz"
  sha256 "d06d6317571bd6560daecd5dedfbfb919e0737fec84e2e14f12878f1fb6d857c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b4e286e27b7c6c5ee747b229d23a5f6976a7d30b080997a7003d6eeafebd226b"
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.21.0.tgz"
    sha256 "40d4cc27188a2f9968ed8292eb4a965a460b7386719cf0e5260a82500ef777a6"
  end

  def install
    (buildpath/"node_modules/@babel/core").install Dir["*"]
    buildpath.install resource("babel-cli")

    cd buildpath/"node_modules/@babel/core" do
      system "npm", "install", *Language::Node.local_npm_install_args, "--production"
    end

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"script.js").write <<~EOS
      [1,2,3].map(n => n + 1);
    EOS

    system bin/"babel", "script.js", "--out-file", "script-compiled.js"
    assert_predicate testpath/"script-compiled.js", :exist?, "script-compiled.js was not generated"
  end
end
