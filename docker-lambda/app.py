import os
import json
import pdfkit
import jinja2
from jinja2 import Environment, FileSystemLoader, select_autoescape

def handler(event, context):

    env = Environment(
        loader=FileSystemLoader("./tpl"),
        autoescape=select_autoescape()
    )
    template = env.get_template("template.html")

    rendered = template.render({'fullname': 'Alex Muradov'})

    with open('./tmp/tmp.html', 'w') as file:
        file.write(rendered)

    pdfkit.from_file('./tmp/tmp.html', './mnt/out/out.pdf')

    return 'ok..'