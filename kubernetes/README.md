# Sample Kubernetes deployments

This directory contains a sample Kubernetes deployment of:

* A [pygeoapi][] instance, configured to show the [10-m lakes dataset][]
  from [Natural Earth][], which is served by:
* A PostgreSQL instance set up with the PostGIS extension, which stores the
  lake data.

The Kubernetes manifests needed to run these samples are generated with
[Kustomize][]. They build upon [a common base definition](./base/), and the
following types of Kubernetes clusters are supported:

* A local [minikube][] cluster (see [./minikube/](./minikube/))


## Required tools

To deploy and run these samples you will need the following tools:
* [Kustomize],
* The [kubectl][] command-line tool, and
* [bzip2][].

If you have [Nix][] installed on your computer, the [Nix flake
definition](./flake.nix) in this directory will install those tools for you.


## How to deply these samples

Check the target-specific instructions, depending on where you are deploying
to:

* [./minikube/README.md](./minikube/README.md)


## Loading the lake dataset

Once the PostgreSQL instance is up and running, use the
[load-data](./load-data) script to feed the 10-m lakes data into the Kubernetes
PostgreSQL instance:

    $ ./load-data
    + kubectl -n pygeoapi-demo exec -i postgresql-0 -- psql --host localhost --user pygeoapi natural_earth
    SET
    SET
    SET
    SET
    SET
     set_config
    ------------

    (1 row)

    SET
    SET
    SET
    SET
    DROP INDEX
    ALTER TABLE
    ALTER TABLE
    DROP SEQUENCE
    DROP TABLE
    SET
    SET
    CREATE TABLE
    CREATE SEQUENCE
    ALTER SEQUENCE
    ALTER TABLE
    COPY 1343
     setval
    --------
       1343
    (1 row)

    ALTER TABLE
    CREATE INDEX

At this point you might need to go back to the target-specific instructions
to perform some target-specific tasks.


[10-m lakes dataset]: https://www.naturalearthdata.com/downloads/10m-physical-vectors/10m-lakes/
[bzip2]: https://sourceware.org/bzip2/
[kubectl]: https://kubernetes.io/docs/tasks/tools/#kubectl
[Kustomize]: https://kustomize.io/
[minikube]: https://minikube.sigs.k8s.io/docs/
[Natural Earth]: https://www.naturalearthdata.com/
[Nix]: https://nix.dev/
[pygeoapi]: https://pygeoapi.io/
