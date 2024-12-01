import subprocess
import json

if __name__ == "__main__":
    wins = json.loads(
        subprocess.check_output(
            ["aerospace", "list-windows", "--all", "--json"]
        ).decode("utf-8")
    )
    output = ""
    for idx, win in enumerate(wins):
        output += f'{idx} | {win["app-name"]} {win['window-title']}\n'

    choose = subprocess.Popen(["choose"], stdin=subprocess.PIPE, stdout=subprocess.PIPE)

    selected, _ = choose.communicate(bytes(output, "utf-8"))
    selected_idx = int(selected.decode("utf-8").split("|")[0].strip())
    subprocess.run(
        ["aerospace", "focus", "--window-id", str(wins[selected_idx]["window-id"])]
    )
