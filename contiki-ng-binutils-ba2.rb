require 'formula'

class ContikiNgBinutilsBa2 < Formula
  desc "GNU binary tools for BA2"
  url "https://raw.githubusercontent.com/Yagoor/homebrew-contiki-ng/main/resources/binutils-2.22-ba-r33675.tar.xz"
  sha256 "5d974fa86b83f0b00eea5301c1126f8a6aa98015b8b1db62966a672df332f9e0"

  def install

    target = "ba-elf"

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


  end
  
end