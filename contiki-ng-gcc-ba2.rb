require 'formula'

class ContikiNgGccBa2 < Formula
  desc "GNU binary tools for BA2"
  url "https://raw.githubusercontent.com/Yagoor/homebrew-contiki-ng/main/resources/gcc-4.7.4-ba-r36379.tar.xz"
  sha256 "8823b9976dcd589e5ed77a5572424a637d1bfee20a47f3ad96f665fb66571b19"

  depends_on "contiki-ng-binutils-ba2"

  resource "newlib-2.0.0-ba-r33675" do
    url "https://raw.githubusercontent.com/Yagoor/homebrew-contiki-ng/main/resources/newlib-2.0.0-ba-r33675.tar.xz"
    sha256 "5e2a3fa6021592cc802960e5bc82c048cafee5e817e4e4f336cb032f5653ba2e"
  end

  resource "gmp-4.3.2" do
    url "https://raw.githubusercontent.com/Yagoor/homebrew-contiki-ng/main/resources/gmp-4.3.2.tar.xz"
    sha256 "f69eff1bc3d15d4e59011d587c57462a8d3d32cf2378d32d30d008a42a863325"
  end

  resource "mpfr-3.1.1" do
    url "https://raw.githubusercontent.com/Yagoor/homebrew-contiki-ng/main/resources/mpfr-3.1.1.tar.xz"
    sha256 "49d5acc32dbeec30a8e26af9c19845763d63feacb8bf97b12876008419f5a17a"
  end

  resource "mpc-1.0.1" do
    url "https://raw.githubusercontent.com/Yagoor/homebrew-contiki-ng/main/resources/mpc-1.0.1.tar.gz"
    sha256 "ed5a815cfea525dc778df0cb37468b9c1b554aaf30d9328b1431ca705b7400ff"
  end

  patch do
    url "https://raw.githubusercontent.com/Yagoor/homebrew-contiki-ng/main/patches/gcc-4.7.4-ba-r36379/jn51xx-multilib.patch"
    sha256 "180e639edc507af1e45a33f0b582e82ffb3c357919f38cd7cfa6be44fdad2826"
  end
 
  resource "config" do
    url "https://git.savannah.gnu.org/git/config.git"
  end

  def install
    # Update config.guess and config.sub to be able to handle newer
    # architechture such as aarch64.
    resource("config").stage do
      buildpath.install "config.guess"
      buildpath.install "config.sub"
    end

    ENV.remove_from_cflags "-Qunused-arguments"
    ENV.remove_from_cflags(/ ?-march=\S*/)
    ENV.remove_from_cflags(/ ?-msse[\d\.]*/)
    ENV.remove_from_cflags(/ ?-mmacosx-version-min=10\.\d+/)

    system "rm -rf newlib"
    resource("newlib-2.0.0-ba-r33675").stage { system "cp -vr newlib #{buildpath}/" }

    system "rm -rf libgloss"
    resource("newlib-2.0.0-ba-r33675").stage { system "cp -vr libgloss #{buildpath}/" }

    system "rm -rf gmp"
    resource("gmp-4.3.2").stage { system "cp -vr . #{buildpath}/gmp"}

    system "rm -rf mpfr"
    resource("mpfr-3.1.1").stage { system "cp -vr . #{buildpath}/mpfr"}

    system "rm -rf mpc"
    resource("mpc-1.0.1").stage { system "cp -vr . #{buildpath}/mpc"}

    target = "ba-elf"
    languages = "c" 

    mkdir "build" do
      system "../configure",
        "--target=#{target}",
        "--program-prefix=#{target}-",
        "--prefix=#{prefix}",
        "--enable-languages=#{languages}",
        "--with-as=#{HOMEBREW_PREFIX}/bin/#{target}-as",
        "--with-ld=#{HOMEBREW_PREFIX}/bin/#{target}-ld",
        "--with-newlib",
        "--with-system-zlib",
        "--disable-nls",
        "--disable-werror",
        "--with-mpfr-include=#{buildpath}/mpfr/src",
        "--with-mpfr-lib=#{buildpath}/build/mpfr/src/.libs"

      system "make"
      system "make", "install"
    end

    (lib/"libiberty.a").delete
    info.rmtree
    man7.rmtree

  end
  
end