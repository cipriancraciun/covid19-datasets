

# COVID-19 derived datasets (JHU, NY Times, ECDC)


> Table of contents:
> * [About](#about)
> * [Visualizations](#visualizations)
> * Datasets: **[JHU](#jhu-csse-covid-19-dataset)**, **[NY Times](#ny-times-covid-19-dataset)**, **[ECDC](#ecdc-covid-19-dataset)**, [example](#dataset-example)
> * [Licensing](#licensing)




## About

This repository contains various datasets related to COVID-19 (JHU CSSE, NY Times, ECDC):
* the data files are available inside the [./exports](./exports) folder;
* the original and intermediary data files are available inside the [./imports](./imports) folder;

Also some visualizations based on the derived datasets are available at:
* https://scratchpad.volution.ro/ciprian/eedf5eb117ec363ca4f88492b48dbcd3/
* or inside the [./plots](./plots) folder of this repository;

None of these datasets were collected by me, however I have re-processed, re-formatted and augmented them for easier manipulation.




## Disclaimer

As with anything on the Internet these days, I take no responsibility for anything.  :)




## Visualizations

I have created 6 groups of countries / regions, based on the JHU CSSE dataset, and for each one I've plotted all the available metrics:

* `global`
  -- [./plots/jhu/global](./plots/jhu/global)
  -- contains the most impacted countries (mainly central Europe, China, Korea and US);
* `europe-major`
  -- [./plots/jhu/europe-major](./plots/jhu/europe-major)
  -- contains the most impacted (>15K) countries in Europe (at the moment mostly the same as above) (plus China and Korea for comparisons);
* `europe-major`
  -- [./plots/jhu/europe-minor](./plots/jhu/europe-minor)
  -- contains the "medium" impacted (>2K and <15K) countries in Europe (plus China and Korea for comparisons);
* `us`
  -- [./plots/jhu/us](./plots/jhu/us)
  -- contains all US states with more than 1K cases;
* `continents`
  -- [./plots/jhu/continents](./plots/jhu/continents)
  -- contains statistics grouped by continents (for those with >10K);
* `subcontinents`
  -- [./plots/jhu/subcontinents](./plots/jhu/subcontinents)
  -- contains statistics grouped by continents (for those with >10K);
* `romania`
  -- [./plots/jhu/romania](./plots/jhu/romania)
  -- contains Romania, Hungary, Bulgaria (and a few major impacted ones for comparison);

![absolute-confirmed](./plots/jhu/global/svg/absolute-confirmed.svg)
![absolute_pop100k-confirmed](./plots/jhu/global/svg/absolute_pop100k-confirmed.svg)
![absolute-deaths](./plots/jhu/global/svg/absolute-deaths.svg)




## Dataset sources




### JHU CSSE COVID-19 dataset

* I have re-formatted the original JHU dataset in a one-data-point-per-row format (thus more "relational" and SQL friendly):
  * in JSON format: [values.json](./exports/jhu/v1/values.json);
  * in TSV format: [values.tsv](./exports/jhu/v1/values.tsv);
  * (these are based on the `daily_reports` dataset;  JHU also provides `time_series` dataset, which is also available under the [exports](./exports/jhu/v1) folder);
* I have also augmented the original JHU dataset with the following:
  * `day_index_*` means how many days have passed for that country since there were at least that many confirmed cases;
  * `absolute_pop100k` means the absolute metric per 100k people in that country / region;
  * `relative_*` means the percentage of that metric relative to the number of confirmed cases for that same day;
  * `delta_*` means the delta of that metric compared to the same metric for the previous day;
  * `*_infected` means the number of "active" cases (i.e. `infected := confirmed - recovered - deaths`);
* I have normalized the country names (i.e. some countries are named differently in different rows, etc.);
* I have augmented the country data with ISO codes, continents, subcontinents and other useful information;
* I have augmented the country data with area, population, average death rate, and median age (from CIA Factbook);
* I have added rows for continent and sub-continent levels;
* the original data is available at [github.com/CSSEGISandData/COVID-19](https://github.com/CSSEGISandData/COVID-19);




### NY Times COVID-19 dataset

* although the original NY dataset is already in a friendly format, I have applied the same augmentations as described above for the JHU dataset:
  * in JSON format: [values.json](./exports/nytimes/v1/us-counties/values.json);
  * in TSV format: [values.tsv](./exports/nytimes/v1/us-counties/values.tsv);
  * (these are based on the `us-counties` dataset;  NY Times also provides `us-states` dataset, which is also available under the [exports](./exports/nytimes/v1) folder);
* all the transformations and augmentations described for the JHU one were applied also to the NY one;
* the original data is available at [github.com/nytimes/covid-19-data](https://github.com/nytimes/covid-19-data);




### ECDC COVID-19 dataset

* although the original ECDC dataset is already in a friendly format, I have applied the same augmentations as described above for the JHU dataset:
  * in JSON format: [values.json](./exports/ecdc/v1/worldwide/values.json);
  * in TSV format: [values.tsv](./exports/ecdc/v1/worldwide/values.tsv);
* all the transformations and augmentations described for the JHU one were applied also to the ECDC one;
* the original data is available at [ecdc.europa.eu](https://www.ecdc.europa.eu/en/publications-data/download-todays-data-geographic-distribution-covid-19-cases-worldwide);




### Dataset example

* both derived JHU and NY datasets use exactly the same schema, thus can be used interchangeably;
* the following is an example of such an augmented record (valid for both JHU and NY datasets):

~~~~
[
  ...

  {
    "location": {
      "key": "3048f6958aa1d30fa1d7d1abc9420cd6",
      "type": "country",
      "label": "Italy",
      "country": "Italy",
      "country_code": "IT",
      "country_latlong": [
        42.83333333,
        12.83333333
      ],
      "region": "Europe",
      "subregion": "Southern Europe",
      "province": "(total)",
      "latlong": [
        42.83333333,
        12.83333333
      ]
    },
    "date": {
      "year": 2020,
      "month": 3,
      "day": 25,
      "date": "2020-03-25"
    },
    "values": {
      "absolute": {
        "confirmed": 74386,
        "deaths": 7503
      },
      "absolute_pop1k": {
        "confirmed": 1.1920325382288597,
        "deaths": 0.1202352611288567,
        "infected": 1.071797277100003
      },
      "absolute_pop10k": {
        "confirmed": 11.920325382288597,
        "deaths": 1.202352611288567,
        "infected": 10.717972771000031
      },
      "absolute_pop100k": {
        "confirmed": 119.20325382288597,
        "deaths": 12.02352611288567,
        "infected": 107.17972771000031
      },
      "relative": {
        "deaths": 10.086575430860647
      },
      "delta": {
        "confirmed": 5210,
        "deaths": 683
      },
      "delta_pct": {
        "confirmed": 7.531513819821903,
        "deaths": 10.014662756598241
      }
    },
    "factbook": {
      "population": 62402659,
      "median_age": 46.5,
      "death_rate": 10.7,
      "area": 301340
    },
    "day_index_1": 55,
    "day_index_10": 34,
    "day_index_100": 32,
    "day_index_1k": 26,
    "day_index_10k": 16
  }

  ...
]
~~~~




## Licensing

* the graphs are licensed under the *Creative Commons Attribution-ShareAlike 4.0 (CC BY-SA 4.0)* license;
* the data files are licensed under the *Creative Commons Attribution-ShareAlike 4.0 (CC BY-SA 4.0)* license;
* the sources and scripts are licensed under the *Affero General Public License v3 (AGPLv3)* license;
* however, the original JHU CSSE COVID-19 data is copyrighted by the *Johns Hopkins University*,
  and *provided to the public strictly for educational and academic research purposes*;
  therefore I don't know if I am actually able to license my derived files data as *CC BY-SA 4.0*;
* also, the original NY COVID-19 data is copyrighted by *The New York Times*,
  and *made publicly available for broad, non-commercial public use*;
  therefore I don't know if I am actually able to license my derived files data as *CC BY-SA 4.0*;
* also, the original ECDC COVID-19 data is copyrighted by (I assume) the ECDC,
  and *users must comply with data use restrictions to ensure that the information will be used solely for statistical analysis or reporting purposes*;
* although given the global situation, I'll let the lawyers decide later...

