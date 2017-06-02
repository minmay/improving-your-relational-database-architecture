# Improving Your Relational Database Architecture
Code for presentation on improving relational database architecture.

Presentation hosted at [Google Docs](https://docs.google.com/presentation/d/1IQeHJptGnU9TWCror8f5JPH1hC6xSBBTk8rRvcj_GOc/edit?usp=sharing).

First build the postgres docker image.

```docker build -t lajug-presentation-db:latest .```

Then run the postgres docker image.

```docker run -it --rm --name lajug-presentation-db -p 5432:5432 lajug-presentation-db:latest```

Then run the application org.lajug.rdbms.jdbc.SeedProductsWithBatchApplication

It will insert 130000 use an optimized batch insert routine.

Generate documentation by issuing the following commands.
If you want the entity diagram generated,  you must install graphviz.

```
cd documentation
./spy.sh 
cd db
open index.html
```

If you use Macports take note install graphviz with this command.

```
sudo port install graphviz
```






