class RevaultApi < Formula
  desc "Stable native API for reVault lockboxes and vaults"
  homepage "https://github.com/onepub-dev/reVault"
  version "0.3.14"
  license :cannot_represent

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.3.14/revault-api-native-0.3.14-macos-aarch64.tar.gz"
      sha256 "d766471178e7314cf72de8e75c619bcdaf2b7f2eecca6718f0248763e392fa13"
    else
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.3.14/revault-api-native-0.3.14-macos-x86_64.tar.gz"
      sha256 "dd8405a0913069fa12534fa70765dcd29f39731750519962830fd6bf0669dad0"
    end
  end

  on_linux do
    depends_on "dbus"
    if Hardware::CPU.arm?
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.3.14/revault-api-native-0.3.14-linux-aarch64-gnu.tar.gz"
      sha256 "cdc8dc1527f5ede46cedb9b02f3bab007961bfbfff9620392fc0057965fafe41"
    else
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.3.14/revault-api-native-0.3.14-linux-x86_64-gnu.tar.gz"
      sha256 "274e042bd788eac8a741250768f6825458ccee42d4d5fb4159e875e71a6d8226"
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
