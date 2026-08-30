class RevaultApi < Formula
  desc "Stable native API for reVault lockboxes and vaults"
  homepage "https://github.com/onepub-dev/reVault"
  version "0.3.13"
  license :cannot_represent

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.3.13/revault-api-native-0.3.13-macos-aarch64.tar.gz"
      sha256 "fe3a491ca1565249665ff62608f16758b9b14c85ab9c87a8287c29bafb9ea288"
    else
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.3.13/revault-api-native-0.3.13-macos-x86_64.tar.gz"
      sha256 "392a3c0055d3e03fc66837771acffb765175c1ba92bb94319af6d850b4646e0c"
    end
  end

  on_linux do
    depends_on "dbus"
    if Hardware::CPU.arm?
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.3.13/revault-api-native-0.3.13-linux-aarch64-gnu.tar.gz"
      sha256 "791af87d1b116e50106763664be9f96fddb1142b89c76f4c23e7c0a6a3e84550"
    else
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.3.13/revault-api-native-0.3.13-linux-x86_64-gnu.tar.gz"
      sha256 "8cba3b2eb309734ac6422d4d2834e8881242016ea0a1aa44ccde0a464d7e81a9"
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
