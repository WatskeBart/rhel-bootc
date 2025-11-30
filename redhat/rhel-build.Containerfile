FROM localhost/rhel-bootc:base

WORKDIR /app

RUN touch HelloWorld

CMD ["/bin/bash"]