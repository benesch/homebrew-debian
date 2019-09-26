class DctrlTools < Formula
  desc "Command-line tools to process Debian package information"
  homepage "https://github.com/ajkaijanaho/dctrl-tools"
  url "https://github.com/ajkaijanaho/dctrl-tools/archive/2.24.tar.gz"
  sha256 "949653246a777e5e5835dd490003c72573cee45184e82369fba2fdd037af15d1"

  depends_on "argp-standalone" => :build
  depends_on "gettext" => :build
  depends_on "po4a" => :build

  patch :DATA

  def install
    system "make", "LDLIBS=-largp -lintl"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    Pathname.new("Packages").write <<~EOF
    Package: zip
    Architecture: amd64
    Version: 3.0-11build1
    Multi-Arch: foreign
    Priority: optional
    Section: utils
    Origin: Ubuntu
    Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
    Original-Maintainer: Santiago Vila <sanvila@debian.org>
    Bugs: https://bugs.launchpad.net/ubuntu/+filebug
    Installed-Size: 623
    Depends: libbz2-1.0, libc6 (>= 2.14)
    Recommends: unzip
    Filename: pool/main/z/zip/zip_3.0-11build1_amd64.deb
    Size: 167182
    MD5sum: 59d9a848586c8be70c266b3eeadda32f
    SHA1: dd7dfe29684c353736a386813cfe1196712d1bdc
    SHA256: 800a02ee081bc8cedafe6b0a3da1193de3e0c281ae1e7a04b091db01cd301d92
    Homepage: http://www.info-zip.org/Zip.html
    Description: Archiver for .zip files
    Task: ubuntu-desktop, kubuntu-desktop, xubuntu-core, xubuntu-desktop, lubuntu-desktop-share, lubuntu-gtk-desktop, lubuntu-desktop, lubuntu-qt-desktop, ubuntustudio-desktop-core, ubuntustudio-desktop, ubuntukylin-desktop, ubuntu-mate-core, ubuntu-mate-desktop, ubuntu-budgie-desktop
    Description-md5: 581928d34d669e63c353cd694bd040b0
    Supported: 5y

    Package: zlib1g
    Architecture: amd64
    Version: 1:1.2.11.dfsg-0ubuntu2
    Multi-Arch: same
    Priority: required
    Section: libs
    Source: zlib
    Origin: Ubuntu
    Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
    Original-Maintainer: Mark Brown <broonie@debian.org>
    Bugs: https://bugs.launchpad.net/ubuntu/+filebug
    Installed-Size: 169
    Provides: libz1
    Depends: libc6 (>= 2.14)
    Conflicts: zlib1 (<= 1:1.0.4-7)
    Breaks: libxml2 (<< 2.7.6.dfsg-2), texlive-binaries (<< 2009-12)
    Filename: pool/main/z/zlib/zlib1g_1.2.11.dfsg-0ubuntu2_amd64.deb
    Size: 56550
    MD5sum: 816cd10960f62571551ede3f45b03d83
    SHA1: 4cd56533ab35cc19f0472c17d719dd30df7de1d9
    SHA256: 2e6dafb986ee8ebbc4e1c344fab090a41710cab878fc9cd89336cdd1740518c5
    Homepage: http://zlib.net/
    Description: compression library - runtime
    Task: minimal
    Description-md5: 567f396aeeb2b2b63295099aed237057
    Supported: 5y
    EOF

    output = shell_output("#{bin}/grep-dctrl -nsFilename zlib Packages")
    assert_equal("pool/main/z/zlib/zlib1g_1.2.11.dfsg-0ubuntu2_amd64.deb\n", output)
  end
end

__END__
diff --git a/lib/fnutil.c b/lib/fnutil.c
index d767680..0fb8564 100644
--- a/lib/fnutil.c
+++ b/lib/fnutil.c
@@ -68,7 +68,7 @@ char * fnqualify(char const * path)

 	/* Do we just need to prepend the current directory? */
 	if (path[0] != '~') {
-		char * cwd = get_current_dir_name();
+		char * cwd = getcwd(NULL, 0);
 		if (cwd == 0) return 0;
 		len = strlen(cwd);
 		size = len + 1 + strlen(path) + 1; /* +2 for '/' and '\0' */
