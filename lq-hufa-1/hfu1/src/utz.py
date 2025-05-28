# Rich Prettifier Code
# ------------------------------------------------------
import logging
from rich import print as rprint  # For rprinting
from rich.pretty import pprint  # For pretty printing
from rich import inspect  # For inspect
from rich.console import Console  # For console.print
from rich.markdown import Markdown  # For markdow
from rich.panel import Panel  # For Panel()
from rich import box  # For Panel Boxes
from rich.prompt import Prompt  # For Prompting
from rich.style import Style  # For styles colors
from rich.text import Text  # For text Styles
from rich.logging import RichHandler
from rich.traceback import install

console = Console()  # Standard code to access console
install(show_locals=True)

# Setting up rich logger with color
logging.basicConfig(
    level=logging.DEBUG,
    format="%(message)s",
    datefmt="[%X]",
    handlers=[RichHandler(rich_tracebacks=True, markup=True)],
)
log = logging.getLogger("rich")

# ------------------------------------------------------


def header1(text):
    panel = Panel.fit(
        f"""[green_yellow]{text}[/green_yellow]""",
        title="<:",
        subtitle=":>",
        style="Italic",
        border_style="magenta",
    )
    # Print the Panel
    console.print(panel)

def header2(text):
    panel = Panel.fit(
        f"""[green_yellow]{text}[/green_yellow]""",
        title="Making Repo",
        subtitle="Made",
        style="Italic",
        border_style="magenta",
    )
    # Print the Panel
    console.print(panel)



def l_debug(text):
    log.debug(f"[green]{text}[/green]")


def l_info(text):
    log.info(f"[blue]{text}[/blue]")


def l_warning(text):
    log.warning(f"[yellow]{text}[/yellow]")


def l_error(text):
    log.error(f"[red]{text}[/red]")


def l_critical(text):
    log.critical(f"[white on red bold]{text}[/white on red bold]")
