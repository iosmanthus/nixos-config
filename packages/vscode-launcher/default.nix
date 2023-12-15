{ pkgs, ... }:
(pkgs.writers.writePython3 "run_vscode"
{
  libraries = [ ];
} ''
  import shutil
  import subprocess
  import sys


  def check_code_command():
      commands = ['code', 'codium', 'code-insiders']
      for cmd in commands:
          if shutil.which(cmd):
              return cmd


  subprocess.run([check_code_command()] + sys.argv[1:])
'')
