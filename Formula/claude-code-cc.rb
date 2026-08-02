class ClaudeCodeCc < Formula
  desc "Switch between multiple authenticated Claude Code accounts"
  homepage "https://github.com/stevearagonsite/claude-code-cc"
  url "https://github.com/stevearagonsite/claude-code-cc/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "4945e729e32cd33af3f39abf0fb8ae5091fd8ccc86dd3cd5ff98b7f36a0c959a"
  license "MIT"

  # Credentials are read from and written to the macOS Keychain via `security`.
  depends_on :macos
  depends_on "python@3.13"

  def install
    # Only cc-profiles goes on the PATH. `cc` itself is a zsh function, sourced
    # by the user — installing a binary named `cc` would shadow the C compiler.
    inreplace "bin/cc-profiles", "#!/usr/bin/env python3",
              "#!#{formula_opt_bin("python@3.13")}/python3.13"
    bin.install "bin/cc-profiles"
    pkgshare.install "cc.zsh"
    pkgshare.install "skills"
  end

  def caveats
    <<~EOS
      Add this line to your ~/.zshrc:
        source "#{opt_pkgshare}/cc.zsh"

      Then open a new shell and run:
        cc add work    # create a profile by cloning your current session
        cc use work    # switch to it, then run /login with the other account
        cc list        # see what's left on each account

      Optional Claude Code skill:
        ln -s "#{opt_pkgshare}/skills/claude-profiles" ~/.claude/skills/claude-profiles
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cc-profiles --version")
  end
end
