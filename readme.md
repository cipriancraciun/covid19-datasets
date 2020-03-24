

# COVID-19 derived datasets




## Warnings

* **due to JHU dataset changes, the values for 2020-03-23 are not reliable;**




## About

This repository contains various datasets related to COVID-19:
* the data files are available inside the [./exports](./exports) folder;
* the original and intermediary data files are available inside the [./imports](./imports) folder;

Also some visualizations based on the derived datasets are available at:
* https://scratchpad.volution.ro/ciprian/eedf5eb117ec363ca4f88492b48dbcd3/
* or inside the [./plots](./plots) folder of this repository;

None of these datasets were collected by me, however I have re-processed, re-formated and augmented them for easier manipulation.




## Disclaimer

As with anything on the Internet these days, I take no responsibility for anything.




## Visualizations

![absolute-confirmed](./plots/jhu/global/svg/absolute-confirmed.svg)
![delta-confirmed](./plots/jhu/global/svg/delta-confirmed.svg)
![absolute-deaths](./plots/jhu/global/svg/absolute-deaths.svg)




## JHU CSSE COVID-19 dataset

* I have re-formated the original JHU dataset in a one-data-point-per-row format (thus more "relational" and SQL friendly):

  * in JSON format: [values.json](./exports/jhu/v1/values.json);
  * in TSV format: [values.tsv](./exports/jhu/v1/values.tsv);

* I have also augmented the original JHU dataset with the following:

  * `day_index_1000` means how many days have passed for that country since there were at least 1000 confirmed cases;
  * `relative_*` means the percentage of that metric relative to the number of confirmed cases for that same day;
  * `delta_*` means the delta of that metric compared to the same metric for the previous day;
  * `*_infected` means the number of "active" cases (i.e. `infected := confirmed - recovered - deaths`);

* I have normalized the country names (i.e. some countries are named differently in differnent rows, etc.);
* I have augmented the country data with ISO codes, continents, subcontinents and other useful information;
* I have added rows for continent and sub-continent levels;

* the original data is available at [github.com/CSSEGISandData/COVID-19](https://github.com/CSSEGISandData/COVID-19);




## Licensing

* the graphs are licensed under the *Creative Commons Attribution-ShareAlike 2.0 (CC BY-SA 2.0)* license;
* the data files are licensed under the *Creative Commons Attribution-ShareAlike 2.0 (CC BY-SA 2.0)* license;
* however the original JHU CSSE COVID-19 data is copyrighted by the *Johns Hopkins University*,
  and *provided to the public strictly for educational and academic research purposes*;
  therefore I don't know if I am actually able to license my derived files as *CC BY-SA 2.0*;
  although given the global situation, I'll let the lawyers decide later...

