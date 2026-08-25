class RevaultApi < Formula
  desc "Stable native API for reVault lockboxes and vaults"
  homepage "https://github.com/onepub-dev/reVault"
  version "0.3.11"
  license :cannot_represent

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.3.11/revault-api-native-0.3.11-macos-aarch64.tar.gz"
      sha256 "b37d52889cb2e46a819fe04354c41d88e866b0b8271eed7309a4e0f2adac981e"
    else
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.3.11/revault-api-native-0.3.11-macos-x86_64.tar.gz"
      sha256 "319a72ddc38a6814867f2f8cd0fa4749ad0c696ddb7bfe04d281aec50463cb0e"
    end
  end

  on_linux do
    depends_on "dbus"
    if Hardware::CPU.arm?
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.3.11/revault-api-native-0.3.11-linux-aarch64-gnu.tar.gz"
      sha256 "a9278a78ebd2138c31579c433339e66f6eb1fcaedfad7e2444edfdaed9e16332"
    else
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.3.11/revault-api-native-0.3.11-linux-x86_64-gnu.tar.gz"
      sha256 "463447f8ae7648204432cd8b81bb0328ab57ae2a397544a1619a806ae6747a00"
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
