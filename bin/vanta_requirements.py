from datetime import datetime
import os
import subprocess
import time


def get_window_geometry(window_name: str) -> list[str] | None:
    try:
        window_ids = (
            subprocess.check_output(
                ["xdotool", "search", "--name", window_name],
            )
            .decode()
            .strip()
            .split("\n")
        )
        geometries: list[str] = []
        for window_id in window_ids:
            geometry = subprocess.check_output(
                ["xdotool", "getwindowgeometry", window_id]
            ).decode()
            geometries.append(geometry.strip())
        return geometries
    except Exception as e:
        print(f"Error: {e}")
        return None


def kill_window(window_name: str):
    try:
        _ = subprocess.run(
            ["xdotool", "search", "--name", window_name, "windowkill"],
            check=True,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
    except subprocess.CalledProcessError as e:
        print(f"Error killing window '{window_name}': {e}")


def parse_geometry(geometries: list[str]) -> tuple[int, ...] | None:
    parsed: list[tuple[int, ...]] = []
    for geometry in geometries:
        lines = geometry.splitlines()

        pos_str = lines[1].split(":")[1].strip().split(" ")[0]
        pos = tuple(map(int, pos_str.split(",")))

        size_str = lines[2].split(":")[1].strip()
        size = tuple(map(int, size_str.split("x")))
        parsed.append((pos[0], pos[1], size[0], size[1]))

    if len(parsed) == 0:
        return None

    return max(parsed, key=lambda x: x[2] * x[3])


def check_flameshot():
    try:
        _ = subprocess.run(
            ["flameshot", "--version"],
            check=True,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
    except Exception:
        print("❌ Flameshot not found or not installed.")
        exit(1)


def capture_with_flameshot(region: tuple[int, ...], requirement: str) -> str | None:
    timestamp = datetime.now().strftime("%Y%m%d")
    directory = os.path.expanduser(f"~/Pictures/vanta/{timestamp}")
    os.makedirs(directory, exist_ok=True)
    filename = f"{requirement}.png"
    filepath = os.path.join(directory, filename)

    x, y, w, h = region
    region_str = f"{w}x{h}+{x}+{y}"

    cmd = ["flameshot", "full", "--region", region_str, "-p", filepath]

    try:
        _ = subprocess.run(
            cmd, check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
        )
        return filepath
    except subprocess.CalledProcessError as e:
        print(f"Flameshot error: {e}")
        return None


def launch_and_capture(window_title: str, launch_command: list[str]):
    print(f"Launching '{window_title}'")
    _ = subprocess.Popen(
        launch_command, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
    )
    time.sleep(1.2)
    print(f"\tLaunched '{window_title}' successfully.")

    geometries = get_window_geometry(window_title)
    if not geometries:
        print(f"Could not find window with title: {window_title}")
        return

    region = parse_geometry(geometries)
    if not region:
        print(f"\tCould not parse geometry for window: {window_title}")
        return
    screenshot = capture_with_flameshot(region, window_title)
    if screenshot:
        print(f"\tSaved screenshot for '{window_title}' to: {screenshot}")

    kill_window(window_title)
    print(f"\tClosed window: {window_title}")
    print()


def main():
    check_flameshot()

    # Lock Screen requirements
    launch_and_capture(
        "Screensaver",
        ["cinnamon-settings", "screensaver"],
    )
    launch_and_capture(
        "Power Management",
        ["cinnamon-settings", "power"],
    )

    # Password Manager
    launch_and_capture(
        "KeePassXC",
        ["keepassxc", "--allow-screencapture"],
    )


if __name__ == "__main__":
    import sys

    sys.exit(main())
