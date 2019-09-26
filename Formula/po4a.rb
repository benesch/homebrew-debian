class Po4a < Formula
  desc "Maintain the translations of your documentation with ease"
  homepage "https://po4a.org"
  url "https://github.com/mquinson/po4a/archive/v0.56.tar.gz"
  sha256 "f5a4fbf17a98a72d0490e004ba373ea2825091c65748f32425413dee6dfe0ea2"

  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
  depends_on "gettext" => :build

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    ENV.prepend_path "PERL5LIB", libexec/"lib"

    system "perl", "Build.PL", "--install_base", libexec
    system "./Build"
    system "./Build", "install"

    man1.install Dir["#{libexec}/man/man1/*"]
    man3.install Dir["#{libexec}/man/man3/*"]
    man7.install Dir["#{libexec}/man/man7/*"]

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    system bin/"po4a", "--version"
    system bin/"po4a-build", "--version"
    system bin/"po4a-gettextize", "--version"
    system bin/"po4a-normalize", "--version"
    system bin/"po4a-translate", "--version"
    system bin/"po4a-updatepo", "--version"
    system bin/"po4aman-display-po", "-h"
    system bin/"po4apod-display-po", "-h"
  end
end
