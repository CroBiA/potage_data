We welcome contributions of public gene expression data sets to POTAGE so the whole community can benefit.

To contribute a data set, you will need to create a new subdirectory under [./expression](./expression)
to house the two data files that POTAGE needs for displaying the gene expression data. The two files required are:

  1. `./expression/XXX_my_data_set/my_data_set.tsv` - A tab-separated file containing the expression values
  2. `./expression/XXX_my_data_set/config.cfg` - A configuration file telling POTAGE about the data set

# Creating a Gene Expression Data Set

For full information on the structure of these files and the data set subdirectory see
[`expression/README.md`](./expression/README.md). For an example of how to generate these files see
[Adding Expression Data Sets](https://github.com/CroBiAd/potage_data#adding-expression-data-sets).

# Issuing A Pull Request

Once you have generated these two files in a data set specific subdirectory, commit to your GitHub repository and
issue a Pull Request.

Once we have had a chance to look over your pull request, we'll merge it into our repository.
At this point, these changes will trigger a cascade of events which will see the data set appear in our
[crobiad/potage](https://hub.docker.com/r/crobiad/potage/) Docker image as well as on the
[public POTAGE instance](http://crobiad.agwine.adelaide.edu.au/potage).
