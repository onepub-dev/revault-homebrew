class RevaultApi < Formula
  desc "Stable native API for reVault lockboxes and vaults"
  homepage "https://github.com/onepub-dev/reVault"
  version "0.6.2"
  license :cannot_represent

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.6.2/revault-api-native-0.6.2-macos-aarch64.tar.gz"
      sha256 "0e25b53ec596cdca24b1042e0fd16133a27e09dda2e5160e889493c72068a527"
    else
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.6.2/revault-api-native-0.6.2-macos-x86_64.tar.gz"
      sha256 "a3a08694cc68ad0f1ad7e06e8f7fc5ce8e6b11c5674e1ba626b9f5268b9ff506"
    end
  end

  on_linux do
    depends_on "dbus"
    if Hardware::CPU.arm?
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.6.2/revault-api-native-0.6.2-linux-aarch64-gnu.tar.gz"
      sha256 "1177a624657650c16a5bb41432007c423a539c4c4a827e7f415ccaa2e5f837e8"
    else
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.6.2/revault-api-native-0.6.2-linux-x86_64-gnu.tar.gz"
      sha256 "028fc5d2f6b6b40e98f38a96cc6479d7e85c03fb44b801bebbe8d000cde9ea3f"
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
