import pdfkit
import jinja2
from fpdf import FPDF, HTMLMixin

from jinja2 import Environment, FileSystemLoader, select_autoescape

env = Environment(
    loader=FileSystemLoader("./tpl"),
    autoescape=select_autoescape()
)
template = env.get_template("template.html")

rendered = template.render({'fullname': 'Alex Muradov'})

with open('./tpl/tmp.html', 'w') as file:
    file.write(rendered)

pdfkit.from_file('./tpl/tmp.html', './tpl/out.pdf')
