class RevaultApi < Formula
  desc "Stable native API for reVault lockboxes and vaults"
  homepage "https://github.com/onepub-dev/reVault"
  version "0.5.0"
  license :cannot_represent

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.5.0/revault-api-native-0.5.0-macos-aarch64.tar.gz"
      sha256 "d95a1b747d60312120df70334ff76961f94200fed95df9f4413ed5639a69a90d"
    else
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.5.0/revault-api-native-0.5.0-macos-x86_64.tar.gz"
      sha256 "b21bb7b0fc7077db89721339da447d2bea7b5e414ed17ec9a5063632db60633a"
    end
  end

  on_linux do
    depends_on "dbus"
    if Hardware::CPU.arm?
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.5.0/revault-api-native-0.5.0-linux-aarch64-gnu.tar.gz"
      sha256 "3a6c5ac9b98f6d3b931f6c066a7ceb036d1ad4025a9603033182673a4b5117ea"
    else
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.5.0/revault-api-native-0.5.0-linux-x86_64-gnu.tar.gz"
      sha256 "3936bc0726bd5c8b6d5b143a7d974f2fe08f24ea5df514e6c6bb70e0b560d174"
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
