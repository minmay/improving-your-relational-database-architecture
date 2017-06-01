FROM postgres:9.4
MAINTAINER Marco Villalobos <mvillalobos@kineteque.com>

RUN useradd -G postgres -ms /bin/bash lajug
ENV POSTGRES_USER lajug

# docker build -t lajug-presentation-db:latest .
# docker run -it --rm --name lajug-presentation-db -p 5432:5432 lajug-presentation-db:latest