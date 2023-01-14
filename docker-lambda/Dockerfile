FROM ubuntu:latest
RUN apt update

RUN apt install python3 -y && apt install python3-pip -y && apt install nano -y && apt install wget -y
RUN pip install pdfkit && pip install jinja2
RUN pip install awslambdaric
RUN wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/wkhtmltox_0.12.6.1-2.jammy_arm64.deb
RUN dpkg -i wkhtmltox_0.12.6.1-2.jammy_arm64.deb; exit 0
RUN apt-get install -f -y
ADD . .
ENV APP_VERSION=1.0.1
RUN chmod -R 777 /tpl
ENTRYPOINT [ "/usr/bin/python3.10", "-m", "awslambdaric" ]
CMD [ "app.handler" ]