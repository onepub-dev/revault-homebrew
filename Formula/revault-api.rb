class RevaultApi < Formula
  desc "Stable native API for reVault lockboxes and vaults"
  homepage "https://github.com/onepub-dev/reVault"
  version "0.6.0"
  license :cannot_represent

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.6.0/revault-api-native-0.6.0-macos-aarch64.tar.gz"
      sha256 "ecba8997b88dea2c877a5f7c246c2cb49ae3b799a2c2afc64620bf49c52aa5f7"
    else
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.6.0/revault-api-native-0.6.0-macos-x86_64.tar.gz"
      sha256 "51ffd5ef382768c98329bf9ea8e7c0dc0d76525cf1fb41d98afc3bf28a043b36"
    end
  end

  on_linux do
    depends_on "dbus"
    if Hardware::CPU.arm?
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.6.0/revault-api-native-0.6.0-linux-aarch64-gnu.tar.gz"
      sha256 "2d3678fdf536df8c4f41f6f46494d7a1b6134f5e9954d3d3ce354b6a0cd884f4"
    else
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.6.0/revault-api-native-0.6.0-linux-x86_64-gnu.tar.gz"
      sha256 "fe1ae368c382d345a3ee9d2103a6654b7bbf59b2a7a63c7e243269fcae698829"
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
