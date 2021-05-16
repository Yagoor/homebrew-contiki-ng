require 'formula'

class ContikiNgJn516xSdk < Formula

  homepage 'https://www.nxp.com/products/wireless/zigbee/ieee-802-15-4-for-jn516x-7x:IEEE802.15.4'
  url 'https://raw.githubusercontent.com/Yagoor/homebrew-contiki-ng/main/resources/jn516x-sdk-4163-1416.tar.bz2'
  sha256 'b1283b629577c4d62b2ff6723ecdc6bf3ce774fcec9340ec46f07568d76f8360'

  depends_on "contiki-ng-gcc-ba2"

  def install
    libexec.install Dir["*"]
  end

  def caveats
    <<~EOS
      You must add the following to your .bash_profile:
        export SDK_BASE_DIR=#{opt_libexec}
    EOS
  end    
end