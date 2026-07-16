class RevaultApi < Formula
  desc "Stable native API for reVault lockboxes and vaults"
  homepage "https://github.com/onepub-dev/reVault"
  version "0.1.0"
  license :cannot_represent

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.1.0/revault-api-native-0.1.0-macos-aarch64.tar.gz"
      sha256 "58d471baaf0b1439c8f6f4cc7ea893c2b7a67560a6eb2dcf69006fb371b96848"
    else
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.1.0/revault-api-native-0.1.0-macos-x86_64.tar.gz"
      sha256 "fb751879a8efe6775b703b12d1f0078886d56b29d5e70fc4d04fd387371bf056"
    end
  end

  on_linux do
    depends_on "dbus"
    if Hardware::CPU.arm?
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.1.0/revault-api-native-0.1.0-linux-aarch64-gnu.tar.gz"
      sha256 "b24c7d04b7094aa5cc3515bbb9cc8f1cf85360118a0c620a0479884628a95c78"
    else
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.1.0/revault-api-native-0.1.0-linux-x86_64-gnu.tar.gz"
      sha256 "796470482bb0cd1be521bd357c051c8bc2c03dc566a65f9e8e5864a9c2888826"
    end
  end

  def install
    include.install "include/revault_api.h"
    lib.install Dir["lib/*revault_api*"]
  end

  test do
    (testpath/"abi.c").write <<~EOS
      #include <revault_api.h>
      int main(void) { return api_abi_version() == 1 ? 0 : 1; }
    EOS
    system ENV.cc, "abi.c", "-I#{include}", "-L#{lib}", "-lrevault_api", "-o", "abi"
    system "./abi"
  end
end
