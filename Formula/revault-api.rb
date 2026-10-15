class RevaultApi < Formula
  desc "Stable native API for reVault lockboxes and vaults"
  homepage "https://github.com/onepub-dev/reVault"
  version "0.5.1"
  license :cannot_represent

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.5.1/revault-api-native-0.5.1-macos-aarch64.tar.gz"
      sha256 "b2f6371f94b466a562e6cc4f2c7e0a3f1d0b1b9e7b9d4c45ff6ebbdd8c1a6858"
    else
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.5.1/revault-api-native-0.5.1-macos-x86_64.tar.gz"
      sha256 "1568c1d8d46e54f84dc19353e3266acf83215c710641d0a546fef1b4d1464964"
    end
  end

  on_linux do
    depends_on "dbus"
    if Hardware::CPU.arm?
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.5.1/revault-api-native-0.5.1-linux-aarch64-gnu.tar.gz"
      sha256 "86a6ddfe95829b1e736b83864acb9bd472351160eda4ce8336b2a1a5a5914b42"
    else
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.5.1/revault-api-native-0.5.1-linux-x86_64-gnu.tar.gz"
      sha256 "974831877f51e3ddb76d5eb691a6f1ea33fbd5e13225843ff4e8a8a64492884a"
    end
  end

  def install
    include.install "include/revault_api.h"
    lib.install Dir["lib/*revault_api*"]
  end

  test do
    (testpath/"abi.c").write <<~EOS
      #include <revault_api.h>
      int main(void) { return api_abi_version() == 3 ? 0 : 1; }
    EOS
    system ENV.cc, "abi.c", "-I#{include}", "-L#{lib}", "-lrevault_api", "-o", "abi"
    system "./abi"
  end
end
