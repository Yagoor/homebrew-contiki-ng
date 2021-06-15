require 'formula'

class ContikiNgBinutilsMsp430 < Formula
  desc "GNU assembler, linker, and binaru utilities for MSP430 MCUs"
  homepage "https://sourceforge.net/projects/mspgcc/"
  url "https://raw.githubusercontent.com/Yagoor/homebrew-contiki-ng/main/resources/binutils-2.22.tar.gz"
  sha256 "12c26349fc7bb738f84b9826c61e103203187ca2d46f08b82e61e21fcbc6e3e6"

  patch do
    url "https://raw.githubusercontent.com/Yagoor/homebrew-contiki-ng/main/resources/msp430-binutils-2.22-20120911.patch"
    sha256 "1dc3cfb0eac093b5f016f4264b811b4352515e8a3519c91240c73bacd256a667"
  end

  def install

    target = "msp430"
    mkdir "build" do
      system "../configure",
        "--target=#{target}",
        "--program-prefix=#{target}-",
        "--prefix=#{prefix}",
        "--disable-static",
        "--disable-nls",
        "--disable-werror"
      system "make"
      system "make", "install"
    end

    (lib/"libiberty.a").delete
    info.rmtree

    # # Create symlinks to no-prefix binaries as bin/target.
    # bin.install_symlink prefix/target/"bin" => target

    # # Create empty place holders for gcc-msp430 and libc-msp430
    # target_lib = HOMEBREW_PREFIX/"lib/#{target}/lib"
    # target_include = HOMEBREW_PREFIX/"include/#{target}/include"
    # target_lib.mkpath
    # target_include.mkpath
    # # Move target/lib to lib/target/lib
    # (lib/target).install prefix/target/"lib"
    # # Create symlink for msp430-ld to see linker scripts from
    # # headers-msp430.
    # (prefix/target).install_symlink target_lib
  end
end