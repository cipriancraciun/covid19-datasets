

# COVID-19 derived datasets




## Warnings

* (permanent change) **due to JHU dataset changes, the recovered and infected values starting with 2020-03-23 will not be provided;**
  (values for previous days are still provided;)




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

I have created 6 groups of countries / regions, and for each one I've plotted all the available metrics:
* `global` -- [./plots/jhu/global](./plots/jhu/global)
  -- contains the most impacted countries (mainly central Europe, China, Korea and US);
* `europe-major` -- [./plots/jhu/europe-major](./plots/jhu/europe-major)
  -- contains the most impacted (>15K) countries in Europe (at the moment mostly the same as above) (plus China and Korea for comparisons);
* `europe-major` -- [./plots/jhu/europe-minor](./plots/jhu/europe-minor)
  -- contains the "medium" impacted (>2K and <15K) countries in Europe (plus China and Korea for comparisons);
* `continents` -- [./plots/jhu/continents](./plots/jhu/continents)
  -- contains statistics grouped by continents (for those with >10K);
* `subcontinents` -- [./plots/jhu/subcontinents](./plots/jhu/subcontinents)
  -- contains statistics grouped by continents (for those with >10K);
* `romania` -- contains Romania, Hungary, Bulgaria (and a few major impacted ones for comparison);

![absolute-confirmed](./plots/jhu/global/svg/absolute-confirmed.svg)
![absolute_pop100k-confirmed](./plots/jhu/global/svg/absolute_pop100k-confirmed.svg)
![absolute-deaths](./plots/jhu/global/svg/absolute-deaths.svg)




## JHU CSSE COVID-19 dataset

* I have re-formated the original JHU dataset in a one-data-point-per-row format (thus more "relational" and SQL friendly):
  * in JSON format: [values.json](./exports/jhu/v1/values.json);
  * in TSV format: [values.tsv](./exports/jhu/v1/values.tsv);
* I have also augmented the original JHU dataset with the following:
  * `day_index_*` means how many days have passed for that country since there were at least that many confirmed cases;
  * `absolute_pop100k` means the absolute metric per 100k people in that country / region;
  * `relative_*` means the percentage of that metric relative to the number of confirmed cases for that same day;
  * `delta_*` means the delta of that metric compared to the same metric for the previous day;
  * `*_infected` means the number of "active" cases (i.e. `infected := confirmed - recovered - deaths`);
* I have normalized the country names (i.e. some countries are named differently in differnent rows, etc.);
* I have augmented the country data with ISO codes, continents, subcontinents and other useful information;
* I have augmented the country data with area, population, average death rate, and median age (from CIA Factbook);
* I have added rows for continent and sub-continent levels;
* the original data is available at [github.com/CSSEGISandData/COVID-19](https://github.com/CSSEGISandData/COVID-19);




## Licensing

* the graphs are licensed under the *Creative Commons Attribution-ShareAlike 2.0 (CC BY-SA 2.0)* license;
* the data files are licensed under the *Creative Commons Attribution-ShareAlike 2.0 (CC BY-SA 2.0)* license;
* however the original JHU CSSE COVID-19 data is copyrighted by the *Johns Hopkins University*,
  and *provided to the public strictly for educational and academic research purposes*;
  therefore I don't know if I am actually able to license my derived files as *CC BY-SA 2.0*;
  although given the global situation, I'll let the lawyers decide later...

