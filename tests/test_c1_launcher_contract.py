"""Guard the C1 launch boundary against the direct-exec regression."""

from pathlib import Path
import re
import unittest


LAUNCHER = (
    Path(__file__).resolve().parents[1]
    / "scripts"
    / "launch-codex-business-desktop.sh"
)


class C1LauncherContractTests(unittest.TestCase):
    def test_shared_binary_is_detached_with_separate_runtime_identity(self):
        source = LAUNCHER.read_text()
        self.assertIn('export __CFBundleIdentifier="com.folderdesk.codex.c1-business.runtime"', source)
        self.assertIn('nohup "$BIN" --user-data-dir="$USER_DATA_DIR" "$@"', source)
        self.assertNotRegex(source, re.compile(r'^\s*exec\s+"\$BIN"', re.MULTILINE))

    def test_reopen_and_dead_lock_recovery_remain_c1_scoped(self):
        source = LAUNCHER.read_text()
        self.assertIn("reopen_existing_c1", source)
        self.assertIn("cleanup_dead_c1_singleton", source)
        self.assertIn('c1_pid_is_live "$lock_pid"', source)
        self.assertIn('"$USER_DATA_DIR/SingletonLock"', source)
        self.assertNotIn("killall ControlCenter", source)


if __name__ == "__main__":
    unittest.main()
