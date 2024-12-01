import subprocess
import sys
import json


def get_focused_window():
    return json.loads(
        subprocess.check_output(
            ["aerospace", "list-windows", "--focused", "--json"]
        ).decode("utf-8")
    )[0]


def get_all_windows_in_workspace():
    return json.loads(
        subprocess.check_output(
            ["aerospace", "list-windows", "--workspace", "focused", "--json"]
        ).decode("utf-8")
    )


def move_to_window(window_id):
    subprocess.run(["aerospace", "focus", "--window-id", str(window_id)])


if __name__ == "__main__":
    direction = 1
    if sys.argv[1] == "prev":
        direction = -1
    current_win = get_focused_window()
    all_win = get_all_windows_in_workspace()
    app_wins = list(filter(lambda w: w["app-name"] == current_win["app-name"], all_win))
    next_idx = 0
    for idx, win in enumerate(app_wins):
        if win["window-id"] == current_win["window-id"]:
            next_idx = (idx + direction) % len(app_wins)
            break
    move_to_window(app_wins[next_idx]["window-id"])
