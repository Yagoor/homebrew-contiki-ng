require 'formula'

class ContikiNgGccMsp430 < Formula
  desc "GNU binary tools for MSP430"
  url "https://raw.githubusercontent.com/Yagoor/homebrew-contiki-ng/main/resources/gcc-4.7.0.tar.bz2"
  sha256 "a680083e016f656dab7acd45b9729912e70e71bbffcbf0e3e8aa1cccf19dc9a5"

  depends_on "contiki-ng-binutils-msp430"

  resource "msp430mcu-20130321" do
    url "https://raw.githubusercontent.com/Yagoor/homebrew-contiki-ng/main/resources/msp430mcu-20130321.tar.bz2"
    sha256 "01be411f8901362fab32e7e1be044a44e087a98f3bd2346ac167960cfe6fa221"
  end

  resource "msp430-libc-20120716" do
    url "https://raw.githubusercontent.com/Yagoor/homebrew-contiki-ng/main/resources/msp430-libc-20120716.tar.bz2"
    sha256 "cbd78f468e9e3b2df9060f78e8edb1b7bfeb98a9abfa5410d23f63a5dc161c7d"
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
    url "https://raw.githubusercontent.com/Yagoor/homebrew-contiki-ng/main/resources/msp430-gcc-4.7.0-20120911.patch"
    sha256 "db0b6e502c89be4cfee518e772125eaea66cc289d9428c57ddcc187a3be9e77a"
  end

  resource "config" do
    url "https://git.savannah.gnu.org/git/config.git"
  end

  def install

    resource("config").stage do
      buildpath.install "config.guess"
      buildpath.install "config.sub"
    end

    ENV.remove_from_cflags "-Qunused-arguments"
    ENV.remove_from_cflags(/ ?-march=\S*/)
    ENV.remove_from_cflags(/ ?-msse[\d\.]*/)
    ENV.remove_from_cflags(/ ?-mmacosx-version-min=10\.\d+/)

    system "rm -rf gmp"
    resource("gmp-4.3.2").stage { system "cp -vr . #{buildpath}/gmp"}

    system "rm -rf mpfr"
    resource("mpfr-3.1.1").stage { system "cp -vr . #{buildpath}/mpfr"}

    system "rm -rf mpc"
    resource("mpc-1.0.1").stage { system "cp -vr . #{buildpath}/mpc"}

    target = "msp430"
    # languages = "c,c++"
    languages = "c" 
    # gcc must be built outside of the source directory.
    mkdir "build" do
      system "../configure",
        "--target=#{target}",
        "--program-prefix=#{target}-",
        "--prefix=#{prefix}",
        "--enable-languages=#{languages}",
        "--with-as=#{HOMEBREW_PREFIX}/bin/#{target}-as",
        "--with-ld=#{HOMEBREW_PREFIX}/bin/#{target}-ld",
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

    resource("msp430mcu-20130321").stage do
      ENV["MSP430MCU_ROOT"] = Dir.pwd
      system "./scripts/install.sh", "#{prefix}"
    end

    resource("msp430-libc-20120716").stage do
      gccpath = "#{prefix}/bin"
      ENV.prepend_path "PATH", gccpath.to_s

      system "./configure --prefix=#{prefix}"

      Dir.chdir "src" do
        system "make"
        system "make", "install"
      end
    end

  end
  
end