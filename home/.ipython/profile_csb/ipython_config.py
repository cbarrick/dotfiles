# Configuration file for ipython.
#
# See the docs for a complete list of options.
# https://ipython.readthedocs.io/en/stable/config/options/index.html

# Classic prompt style ('>>>') with colors.
c.InteractiveShell.color_info = True
c.TerminalInteractiveShell.colors = 'Neutral'
c.TerminalInteractiveShell.prompts_class = 'IPython.terminal.prompts.ClassicPrompts'

# Disable the startup banner.
c.TerminalIPythonApp.display_banner = False

# Don't confirm exit.
c.TerminalInteractiveShell.confirm_exit = False

# Don't mess with my terminal title.
c.TerminalInteractiveShell.term_title = False
