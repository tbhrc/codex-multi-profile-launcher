import json
import subprocess
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BRIDGECTL = ROOT / "tools" / "aosctl.py"
ACTIVE_WORKER = ROOT / "runtime" / "active_worker.json"


class PackageTests(unittest.TestCase):
    def setUp(self):
        self.active_worker_before = ACTIVE_WORKER.read_text(encoding="utf-8")

    def tearDown(self):
        ACTIVE_WORKER.write_text(self.active_worker_before, encoding="utf-8")

    def run_cmd(self, *args, expect=0):
        result = subprocess.run(["python3", str(BRIDGECTL), *args], cwd=ROOT, text=True, capture_output=True)
        self.assertEqual(result.returncode, expect, msg=result.stdout + result.stderr)
        return result

    def test_validate(self):
        self.run_cmd("validate")

    def test_invalid_worker_is_rejected(self):
        result = subprocess.run(
            ["python3", str(BRIDGECTL), "activate-worker", "invalid", "--codex-home", "/tmp/nope"],
            cwd=ROOT,
            text=True,
            capture_output=True,
        )
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("Invalid executable worker", result.stderr + result.stdout)

    def test_c1_and_c2_can_activate(self):
        for worker in ("C1", "C2"):
            result = self.run_cmd("activate-worker", worker, "--codex-home", f"/tmp/{worker}")
            self.assertIn(worker, result.stdout)

    def test_result_schema_is_json(self):
        data = json.loads((ROOT / "schemas" / "result.schema.json").read_text(encoding="utf-8"))
        self.assertEqual(data["type"], "object")


if __name__ == "__main__":
    unittest.main()
