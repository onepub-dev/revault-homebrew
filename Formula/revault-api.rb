class RevaultApi < Formula
  desc "Stable native API for reVault lockboxes and vaults"
  homepage "https://github.com/onepub-dev/reVault"
  version "0.4.1"
  license :cannot_represent

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.4.1/revault-api-native-0.4.1-macos-aarch64.tar.gz"
      sha256 "50362ee23d806d855ca4ce2bd4e86dabe0489482b451e179e19568f625afb49c"
    else
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.4.1/revault-api-native-0.4.1-macos-x86_64.tar.gz"
      sha256 "36fbec020c3bade657454ca71ffc305b29d191e78497fda1886b9bf2e9134456"
    end
  end

  on_linux do
    depends_on "dbus"
    if Hardware::CPU.arm?
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.4.1/revault-api-native-0.4.1-linux-aarch64-gnu.tar.gz"
      sha256 "8be99e05f6c31786ef05fa1d57e02594bf29bcc739c0d6d2275861e729b5f28a"
    else
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.4.1/revault-api-native-0.4.1-linux-x86_64-gnu.tar.gz"
      sha256 "2165628190e5b3c47ffdd93ccdb4a3168f2ff47376f9799d7e85efcec5e64508"
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
