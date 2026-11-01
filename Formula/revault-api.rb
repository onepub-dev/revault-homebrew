class RevaultApi < Formula
  desc "Stable native API for reVault lockboxes and vaults"
  homepage "https://github.com/onepub-dev/reVault"
  version "0.6.1"
  license :cannot_represent

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.6.1/revault-api-native-0.6.1-macos-aarch64.tar.gz"
      sha256 "1f680cd0e9758287620dd4ce11352d9a53b7fdd2c50586c69bf2bfd7540e5abe"
    else
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.6.1/revault-api-native-0.6.1-macos-x86_64.tar.gz"
      sha256 "af51245640a41503e98ab48ccb4c612e2cf97a4c405bf9eb77e4be800ee89ee4"
    end
  end

  on_linux do
    depends_on "dbus"
    if Hardware::CPU.arm?
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.6.1/revault-api-native-0.6.1-linux-aarch64-gnu.tar.gz"
      sha256 "3cef8fa813ec48fe1c20e9df831a49b45d79b55b5175cd67e92cd1a3c2606e21"
    else
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.6.1/revault-api-native-0.6.1-linux-x86_64-gnu.tar.gz"
      sha256 "76ff5182cda45074b5ab2b1d9670245a654ecd5d2d2c5bff71f3756df63a8d67"
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
