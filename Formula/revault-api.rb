class RevaultApi < Formula
  desc "Stable native API for reVault lockboxes and vaults"
  homepage "https://github.com/onepub-dev/reVault"
  version "0.3.15"
  license :cannot_represent

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.3.15/revault-api-native-0.3.15-macos-aarch64.tar.gz"
      sha256 "fe75e02578e0bdbc79206212993f4ef7792b868a5be32146df989cf517899493"
    else
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.3.15/revault-api-native-0.3.15-macos-x86_64.tar.gz"
      sha256 "1b9d6cfa2f33429069e6123c4e381f78f447e6950fdf0125eb25034ed63bed3a"
    end
  end

  on_linux do
    depends_on "dbus"
    if Hardware::CPU.arm?
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.3.15/revault-api-native-0.3.15-linux-aarch64-gnu.tar.gz"
      sha256 "d08ab2fb1844e753fc50dda70d287c8642f468c7703c6bfe34bf3a88436a3df5"
    else
      url "https://github.com/onepub-dev/reVault/releases/download/revault-api-v0.3.15/revault-api-native-0.3.15-linux-x86_64-gnu.tar.gz"
      sha256 "7b1b912767738928687c8bee15b40b50304f8dcf5a116b1acf0dff4b75677c49"
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
