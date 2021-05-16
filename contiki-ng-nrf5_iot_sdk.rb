require 'formula'

class ContikiNgNrf5IotSdk < Formula

  homepage 'https://developer.nordicsemi.com/'
  url 'https://developer.nordicsemi.com/nRF5_IoT_SDK/nRF5_IoT_SDK_v0.9.x/nrf5_iot_sdk_3288530.zip'
  sha256 'd9c3787d523072c944e6d54b7e262e3884eb7e0d540762ce02a943c52d07fe85'
  version '3288530'

  def install
    libexec.install Dir["*"]
  end

  def caveats
    <<~EOS
      You must add the following to your .bash_profile:
        export NRF52_SDK_ROOT=#{opt_libexec}
    EOS
  end    
end