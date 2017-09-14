This repository houses the data components used by the public [POTAGE](https://github.com/CroBiAd/potage) web server (http://crobiad.agwine.adelaide.edu.au/potage).

This information is relevant for those seeking to add unpublished gene expression data sets to their [own POTAGE instance](https://github.com/CroBiAd/potage#running-potage-locally) or wish to contribute a published gene expression dataset to the community of POTAGE users.

There are two major data components to POTAGE:

  1. [Global](./global) - the core precomputed information on which POTAGE is built
  2. [Expression](./expression) - the gene expression data sets for visualisation within POTAGE


# Contributing Gene Expression Data Sets to POTAGE

POTAGE currently houses a limited number of publically available gene expression data sets:

  1. [IWGSC RNA-Seq tissue series](https://urgi.versailles.inra.fr/files/RNASeqWheat/) under [`expression/001_iwgsc`](expression/001_iwgsc)
  2. [Meiose](https://www.ncbi.nlm.nih.gov/bioproject/PRJEB5029) data under [`expression/002_meiose`](expression/002_meiose)

While we plan to add additional public data sets over time, we welcome [contributions](CONTRIBUTING.md) from the public via pull requests.
