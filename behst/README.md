# BEHST - Biological Enrichment of Hidden Sequence Targets #

BEHST: an advanced tool for gene set enrichment analysis (GSEA) enhanced
through integration of chromatin long-range interactions

## Summary ##
BEHST reads an input dataset of chromosome regions, and intersects them with the chromatin interactions available in the Hi-C dataset. Of these chromosome regions, BEHST selects those that are presentthe regulatory regions of genes of APPRIS, a dataset of principal isoform annotations. We defined these cis-regulatory regions upon the position of their nearest transcription start site of the APPRIS genes' principal transcripts (obtained through GENCODE), plus an upstream and downstream extension. Afterwards, BEHST takes the genes of the resulting partner loci found in gene regulatory regions, and performs a gene set enrichment analysis on them through g:Profiler. BEHST, finally, outputs the list of the most significant Gene Ontology terms detected by g:Profiler.

## Installation ##
To run BEHST, you need to have the following programs and packages installed in your machine:

* **Python** (version 2.7.5)
* Python **Pandas** package
* **Bedtools** (version v2.25.0)
* Python **PyBedtools** package
* **R** (version 3.3.2)
* R **gProfileR** package

If you already have all of them installed on your computer, you can download and run BEHST (without root privileges), following the **Execution instructions** below.

On the contrary, in case you needed to install some of these programs, you need to have root privileges, an internet connection, and at least 8 GB of free space on your hard disk.

We here provide the instructions to install all the needed programs and dependencies on Linux CentOS, Linux Ubuntu, and Mac OS. BEHST was originally developed on a Linux CentOS computer.
 
#### Instructions for Linux CentOS ####
Here are the instructions to install all the programs and libraries needed by BEHST on a Linux CentOS computer, from a shell terminal. We tested these instructions on a Dell Latitude 3540 laptop running Linux CentOS 7.2.1511 operating system, in February 2017. If you are using another operating system version, some instructions might be slightly different.

(Optional) First of all, update your system:

`sudo yum -y update`

Install Python, and Python Pandas package:

`sudo yum -y install python`

`sudo yum -y install python-devel`

`sudo yum -y install epel-release`

`sudo yum -y install python-pip`

`sudo pip install pandas`

Install the development tools, such as gcc:

`sudo yum -y group install "Development Tools"`

`sudo yum -y install zlib-devel`

Install Bedtools:

`sudo yum -y install BEDTools`

`sudo pip install pybedtools`

Install R and its packages RCurl and gProfileR:

`sudo yum -y install R`

`sudo yum -y install curl-devel`

`sudo Rscript -e 'install.packages(c("RCurl","gProfileR"), repos="https://cran.rstudio.com")' `

#### Instructions for Linux Ubuntu ####
Here are the instructions to install all the programs and libraries needed by BEHST on a Linux Ubuntu computer, from a shell terminal. We tested these instructions on a Dell Latitude 3540 laptop running Linux Ubuntu 16.10 operating system, in February 2017. If you are using another operating system version, some instructions might be slightly different.


First of all, update your system:

(Optional) `sudo apt-get -y update`

Install Python, and Python Pandas package:

`sudo apt-get -y install python`

`sudo apt-get -y install python-pip`

`sudo pip install pandas`

Install the development tools, such as gcc:

`sudo apt-get -y install build-essential`

`sudo apt-get -y install libpng-dev`

`sudo apt-get -y install zlib1g-dev`

Install Bedtools:

`sudo apt-get -y install bedtools`

`sudo pip install pybedtools`

Install R and its packages RCurl and gProfileR:

`sudo apt-get -y install r-base`

`sudo apt-get -y install curl`

`sudo apt-get -y install libcurl3`

`sudo apt-get -y install libcurl4-gnutls-dev`

`sudo Rscript -e 'install.packages(c("RCurl", "gProfileR"), repos="https://cran.rstudio.com")' `

#### Instructions for Mac OS ####
Here are the instructions to install all the programs and libraries needed by BEHST on a Mac computer, from a shell terminal. We tested these instructions on an Apple computer running a Mac OS macOS 10.12.2 Sierra operating system, in March 2017. If you are using another operating system version, some instructions might be slightly different.

First of all, update:

(Optional) `sudo softwareupdate -iva`

Install rudix:
`curl -O https://raw.githubusercontent.com/rudix-mac/rpm/2016.12.13/rudix.py`

`sudo python rudix.py install rudix`

`sudo rudix install coreutils`

Install the development tools, such as gcc:

`xcode-select --install`

Install Python Pandas: 

`sudo easy_install pandas`

Install homebrew:

`ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`

Install Bedtools:

`brew install homebrew/science/bedtools`

`sudo easy_install pybedtools`

Install R and its packages RCurl and gProfileR:

`brew install r`

`sudo Rscript -e 'install.packages(c("RCurl", "gProfileR"), repos="https://cran.rstudio.com")' `

Since the sed command has a different meaning from Linux to Mac, we have to replace sed with gsed in the main project.sh file:

`brew install gnu-sed`

`cd /BEHST/bin/`

`gsed -i.bak 's/sed/gsed/g' project.sh`

## Execution instructions ##
To run best, move to the /BEHST/bin/ folder and execute the project.sh bash file. For example, to run BEHST with the PrESSTo lung file as input and the input optimized hyper-parameter values QUERY = 24100 and TSS extension = 9400

`cd /BEHST/bin/`

`mkdir ../results/`

`mkdir ../temp/`

On Linux CentOS and Mac:

`sh project.sh ../data/pressto_LUNG_enhancers.bed DEFAULT_EQ DEFAULT_ET`

On Linux Ubuntu:

`bash project.sh ../data/pressto_LUNG_enhancers.bed DEFAULT_EQ DEFAULT_ET`


## License ##
All the code is licensed under the [GNU General Public License, version 2 (GPLv2)](http://www.gnu.org/licenses/gpl-2.0-standalone.html).

The file of the Hi-C dataset `\data\hic_allCellTypes` was downloaded from the National Center for Biotechnology Information (NCBI) [Gene Expression Omnibus (GEO) website](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE63525) and is available under the [GEO copyright license](https://www.ncbi.nlm.nih.gov/geo/info/disclaimer.html).

The file of the APPRIS dataset `\data\appris_data_principal.txt` was downloaded from the [APPRIS website](http://appris.bioinfo.cnio.es/#/downloads) and is available under the [Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)](https://creativecommons.org/licenses/by-nc-nd/4.0/).

The file of the GENCODE dataset `\data\gencode.v19.annotation.gtf_withproteinids` was downloaded from the [GENCODE website](http://appris.bioinfo.cnio.es/#/downloads) and is available under the [Creative Commons
Attribution-NonCommercial-NoDerivs 2.5 Generic (CC BY-NC-ND 2.5)](https://creativecommons.org/licenses/by-nc-nd/2.5/).

The files of the VISTA dataset `\data\*vista*` are publically available on the [VISTA Enhancer Browser website](https://enhancer.lbl.gov/cgi-bin/imagedb3.pl?form=search&show=1&search.form=no&search.result=yes).

The files of the PrESSTo dataset `\data\*pressto*` are publically available on the [Promoter Enhancer Slider Selector Tool (PrESSto) website](http://enhancer.binf.ku.dk/presets/#download_view_div).

## Contacts ##

BEHST was developed by Davide Chicco, Haixin Sarah Bi, and Michael M. Hoffman at the [Hoffman Lab](http://www.hoffmanlab.org) of the [Princess Margaret Cancer Centre](http://www.uhn.ca/PrincessMargaret/Research/) (Toronto, Ontario, Canada).

For code questions, write to Davide Chicco: davide.chicco(AT)davidechicco.it

For scientific questions, write to Michael M. Hoffman: michael.hoffman(AT)utoronto.ca