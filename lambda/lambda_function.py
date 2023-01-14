import json
from latex import build_pdf
from jinja2.loaders import FileSystemLoader
from latex.jinja2 import make_env

def lambda_handler(event, context):
    somevalues = [1,2,3,4]
    
    return {
        'statusCoccde': 200,
        'body': json.dumps('Hello from Lambda!'),
        'other': event
    }
