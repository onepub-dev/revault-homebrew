class RevaultApi < Formula
  desc "Stable native API for reVault lockboxes and vaults"
  homepage "https://github.com/onepub-dev/reVault"
  version "0.3.12"
  license :cannot_represent

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.3.12/revault-api-native-0.3.12-macos-aarch64.tar.gz"
      sha256 "dc441f3f5418909cc93453965ec84660b3cdad97a4eba4b67cddfa90fe5eddf5"
    else
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.3.12/revault-api-native-0.3.12-macos-x86_64.tar.gz"
      sha256 "9f8c3c9bd21b9a162eac80f910d8abe53f013a88fd80d4f9c245d29a36798d13"
    end
  end

  on_linux do
    depends_on "dbus"
    if Hardware::CPU.arm?
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.3.12/revault-api-native-0.3.12-linux-aarch64-gnu.tar.gz"
      sha256 "eed5293fdd9893be324f273e789d446e007c1bedd85ad3032e4f13ece9b7be4e"
    else
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.3.12/revault-api-native-0.3.12-linux-x86_64-gnu.tar.gz"
      sha256 "3f5a2fc1f168fbee77f983ebe1c5b61feceb575c2f007f7f143df322052ab322"
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
