class Cutter < Formula
  desc "Unit Testing Framework for C and C++"
  homepage "https://cutter.osdn.jp/"
  url "https://osdn.mirror.constant.com/cutter/71616/cutter-1.2.7.tar.gz"
  sha256 "4d80feb16f8f4d8eed62bca40194f8896e70bdac06305bf612b41601e659cae6"
  head "https://github.com/clear-code/cutter.git"

  bottle do
    sha256 "e191446f46122b517cf4b4d5f473ea4bc0f9e048d685af851ad64949612ba313" => :catalina
    sha256 "2c69a7d83b9776729939f829fc7b025eb44a012e41643cd9a7a8cbde9d274d09" => :mojave
    sha256 "560d2c76c2603bb947095653e6f13db90cf9fe2b09f44cafdf063244fe4c4ec4" => :high_sierra
    sha256 "3226b680ed29260aa73024751635b45cf9bb9baa4f7e5e50b379591e837a0b8a" => :sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-glibtest",
                          "--disable-goffice",
                          "--disable-gstreamer",
                          "--disable-libsoup"
    system "make"
    system "make", "install"
  end

  test do
    touch "1.txt"
    touch "2.txt"
    system bin/"cut-diff", "1.txt", "2.txt"
  end
end
