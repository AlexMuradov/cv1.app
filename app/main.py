
from latex import build_pdf
from jinja2.loaders import FileSystemLoader
from latex.jinja2 import make_env


env = make_env(loader=FileSystemLoader('./tpl'))
tpl = env.get_template('doc.latex')

pdf = build_pdf(tpl.render())

pdf.save_to("test.pdf")