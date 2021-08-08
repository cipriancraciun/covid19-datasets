

# COVID-19 derived datasets (JHU, NY Times, ECDC)


> Table of contents:
> * [About](#about), [Used by](#used-by)
> * [Visualizations](#visualizations)
> * Datasets: **[JHU](#jhu-csse-covid-19-dataset)**, **[NY Times](#ny-times-covid-19-dataset)**, **[ECDC](#ecdc-covid-19-dataset)**, [example](#dataset-example)
> * [Attribution](#attribution), [Licensing](#licensing)




## About

This repository contains various datasets related to COVID-19 (JHU CSSE, NY Times, ECDC):
* the original data files are available inside the [./imports](./imports) folder;
* some of the derived data files are available inside the [./exports](./exports) folder;
* **due to the fact that file sizes have become increasingly large, they can no longer be hosted on GitHub, however all the original, intermediary and derived data files are available at the links below;**
* all the original and intermediary data files ar available at (https://data.volution.ro/ciprian/f8ae5c63a7cccce956f5a634a79a293e/imports/)
  (there is also an `md5` file that can be used as an index at (https://data.volution.ro/ciprian/f8ae5c63a7cccce956f5a634a79a293e/imports/.md5));
* all the derived data files are available at (https://data.volution.ro/ciprian/f8ae5c63a7cccce956f5a634a79a293e/exports/)
  (there is also an `md5` file that can be used as an index at (https://data.volution.ro/ciprian/f8ae5c63a7cccce956f5a634a79a293e/exports/.md5));

Also some visualizations based on the derived datasets are available at:
* inside the [./plots](./plots) folder of this repository;
* or at (https://scratchpad.volution.ro/ciprian/eedf5eb117ec363ca4f88492b48dbcd3/);
* all the plot variants (PDF, SVG and PNG) are available at (https://data.volution.ro/ciprian/f8ae5c63a7cccce956f5a634a79a293e/plots/)
  (there is also an `md5` file that can be used as an index at (https://data.volution.ro/ciprian/f8ae5c63a7cccce956f5a634a79a293e/exports/.md5));

None of these datasets were collected by me, however I have re-processed, re-formatted and augmented them for easier manipulation.




## Used by

* (paper) [Statistical Physics of Epidemic on Network Predictions for SARS-CoV-2 Parameters](https://arxiv.org/abs/2007.03101);
* (website) [covid19.geo-spatial.org](https://covid19.geo-spatial.org/dashboard/statistici/situatie-europa);
* (website) [jgoerzen.github.io/covid19ks](https://jgoerzen.github.io/covid19ks);
* (code) [github.com/jgoerzen/covid19db](https://github.com/jgoerzen/covid19db);
* (code) [github.com/jgoerzen/covid19ks](https://github.com/jgoerzen/covid19ks);
* (code) [github.com/jojo4u/covid-19-graphs-jo](https://github.com/jojo4u/covid-19-graphs-jo);
* (code) [github.com/bogdanvso/diseases_risk_analysing](https://github.com/bogdanvso/diseases_risk_analysing);




## Disclaimer

As with anything on the Internet these days, I take no responsibility for anything.  :)




## Visualizations

I have created a few groups of countries / regions, based on the derived datasets, and for each one I've plotted all the available metrics:

* `global`
  -- [JHU](./plots/jhu/global)
  -- first 25 world-wide countries ordered by confirmed cases;
* `global-major`
  -- [JHU](./plots/jhu/global-major)
  -- world-wide countries with more than 4M confirmed cases;
* `global-medium`
  -- [JHU](./plots/jhu/global-medium)
  -- world-wide countries with more than 1M confirmed cases, but less than 4M;
* `global-minor`
  -- [JHU](./plots/jhu/global-minor)
  -- world-wide countries with more than 500K confirmed cases, but less than 1M, limited to 20 countries;
* `europe`
  -- [ECDC](./plots/ecdc/europe) or [JHU](./plots/jhu/europe)
  -- first 25 European countries ordered by confirmed cases;
* `europe-major`
  -- [ECDC](./plots/ecdc/europe-major) or [JHU](./plots/jhu/europe-major)
  -- European countries with more than 1.5M confirmed cases;
* `europe-medium`
  -- [ECDC](./plots/ecdc/europe-medium) or [JHU](./plots/jhu/europe-medium)
  -- European countries with more than 500K confirmed cases, but less than 1.5M;
* `europe-minor`
  -- [ECDC](./plots/ecdc/europe-minor) or [JHU](./plots/jhu/europe-minor)
  -- European countries with more than 100K confirmed cases, but less than 500K, limited to 20 countries;
* `us`
  -- [NY Times](./plots/nytimes/us)
  -- first 25 US states ordered by confirmed cases;
* `us-major`
  -- [NY Times](./plots/nytimes/us-major)
  -- US states with more than 1M confirmed cases;
* `us-medium`
  -- [NY Times](./plots/nytimes/us-medium)
  -- US states with more than 500K confirmed cases, but less than 1M;
* `us-minor`
  -- [NY Times](./plots/nytimes/us-minor)
  -- US states with more than 100K confirmed cases, but less than 500K, limited to 20 states;
* `world`
  -- [JHU](./plots/jhu/world)
  -- overall aggregated values;
* `continents`
  -- [JHU](./plots/jhu/continents)
  -- aggregated countries grouped by continents;
* `subcontinents`
  -- [JHU](./plots/jhu/subcontinents)
  -- aggregated countries grouped by sub-continents;
* `romania`
  -- [JHU](./plots/jhu/romania) or [ECDC](./plots/ecdc/romania)
  -- Romania, Hungary, Bulgaria and a few other countries for comparison;

![absolute_pop100k--confirmed](https://data.volution.ro/ciprian/f8ae5c63a7cccce956f5a634a79a293e/plots/jhu/global/png/absolute_pop100k--confirmed--lines.png)
![delta--confirmed](https://data.volution.ro/ciprian/f8ae5c63a7cccce956f5a634a79a293e/plots/jhu/global/png/delta--confirmed--lines.png)
![delta--deaths](https://data.volution.ro/ciprian/f8ae5c63a7cccce956f5a634a79a293e/plots/jhu/global/png/delta--deaths--lines.png)
![peak--confirmed](https://data.volution.ro/ciprian/f8ae5c63a7cccce956f5a634a79a293e/plots/jhu/global/png/peak_pct--confirmed--heatmap.png)
![peak--deaths](https://data.volution.ro/ciprian/f8ae5c63a7cccce956f5a634a79a293e/plots/jhu/global/png/peak_pct--deaths--heatmap.png)




## Dataset sources




### JHU CSSE COVID-19 dataset

* I have re-formatted the original JHU dataset in a one-data-point-per-row format (thus more "relational" and SQL friendly):
  * the `daily` dataset (includes world countries and US counties, plus higher level aggregates):
    * in JSON format: [values.json.zst](https://data.volution.ro/ciprian/f8ae5c63a7cccce956f5a634a79a293e/exports/jhu/v1/daily/values.json.zst);
    * in TSV format: [values.tsv.zst](https://data.volution.ro/ciprian/f8ae5c63a7cccce956f5a634a79a293e/exports/jhu/v1/daily/values.tsv.zst);
    * in SQL format (for SQLite): [values-sqlite.sql.zst](https://data.volution.ro/ciprian/f8ae5c63a7cccce956f5a634a79a293e/exports/jhu/v1/daily/values-sqlite.sql.zst)
      and [values-sqlite.db.zst](https://data.volution.ro/ciprian/f8ae5c63a7cccce956f5a634a79a293e/exports/jhu/v1/daily/values-sqlite.db.zst);
    * in JSON format only the "current status" (i.e. the latest values): [status.json](https://data.volution.ro/ciprian/f8ae5c63a7cccce956f5a634a79a293e/exports/jhu/v1/daily/status.json);
  * the `series` dataset (includes world countries and US states, plus higher level aggregates):
    * in JSON format: [values.json.zst](https://data.volution.ro/ciprian/f8ae5c63a7cccce956f5a634a79a293e/exports/jhu/v1/series/values.json.zst);
    * in TSV format: [values.tsv.zst](https://data.volution.ro/ciprian/f8ae5c63a7cccce956f5a634a79a293e/exports/jhu/v1/series/values.tsv.zst);
    * in SQL format (for SQLite): [values-sqlite.sql.zst](https://data.volution.ro/ciprian/f8ae5c63a7cccce956f5a634a79a293e/exports/jhu/v1/series/values-sqlite.sql.zst)
      and [values-sqlite.db.zst](https://data.volution.ro/ciprian/f8ae5c63a7cccce956f5a634a79a293e/exports/jhu/v1/series/values-sqlite.db.zst);
    * in JSON format only the "current status" (i.e. the latest values): [status.json](https://data.volution.ro/ciprian/f8ae5c63a7cccce956f5a634a79a293e/exports/jhu/v1/series/status.json);
* **for other files and formats see (https://data.volution.ro/ciprian/f8ae5c63a7cccce956f5a634a79a293e/exports/jhu/v1/);**
* all the files above are also available in uncompressed format (just remove the `.zst` extension), or with `gzip` compression (just replace `.zst` with `.gz`);
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
  * the `us-counties` dataset (includes only US counties, plus higher level aggregates):
    * in JSON format: [values.json.zst](https://data.volution.ro/ciprian/f8ae5c63a7cccce956f5a634a79a293e/exports/nytimes/v1/us-counties/values.json.zst);
    * in TSV format: [values.tsv.zst](https://data.volution.ro/ciprian/f8ae5c63a7cccce956f5a634a79a293e/exports/nytimes/v1/us-counties/values.tsv.zst);
    * in SQL format (for SQLite): [values-sqlite.sql.zst](https://data.volution.ro/ciprian/f8ae5c63a7cccce956f5a634a79a293e/exports/nytimes/v1/us-counties/values-sqlite.sql.zst)
      and [values-sqlite.db.zst](https://data.volution.ro/ciprian/f8ae5c63a7cccce956f5a634a79a293e/exports/nytimes/v1/us-counties/values-sqlite.db.zst);
    * in JSON format only the "current status" (i.e. the latest values): [status.json](https://data.volution.ro/ciprian/f8ae5c63a7cccce956f5a634a79a293e/exports/nytimes/v1/us-counties/status.json);
  * the `us-states` dataset (includes only US states, plus higher level aggregates):
    * in JSON format: [values.json.zst](https://data.volution.ro/ciprian/f8ae5c63a7cccce956f5a634a79a293e/exports/nytimes/v1/us-states/values.json.zst);
    * in TSV format: [values.tsv.zst](https://data.volution.ro/ciprian/f8ae5c63a7cccce956f5a634a79a293e/exports/nytimes/v1/us-states/values.tsv.zst);
    * in SQL format (for SQLite): [values-sqlite.sql.zst](https://data.volution.ro/ciprian/f8ae5c63a7cccce956f5a634a79a293e/exports/nytimes/v1/us-states/values-sqlite.sql.zst)
      and [values-sqlite.db.zst](https://data.volution.ro/ciprian/f8ae5c63a7cccce956f5a634a79a293e/exports/nytimes/v1/us-states/values-sqlite.db.zst);
    * in JSON format only the "current status" (i.e. the latest values): [status.json](https://data.volution.ro/ciprian/f8ae5c63a7cccce956f5a634a79a293e/exports/nytimes/v1/us-states/status.json);
* **for other files and formats see (https://data.volution.ro/ciprian/f8ae5c63a7cccce956f5a634a79a293e/exports/nytimes/v1/);**
* all the files above are also available in uncompressed format (just remove the `.zst` extension), or with `gzip` compression (just replace `.zst` with `.gz`);
* all the transformations and augmentations described for the JHU one were applied also to the NY one;
* the original data is available at [github.com/nytimes/covid-19-data](https://github.com/nytimes/covid-19-data);




### ECDC COVID-19 dataset

* although the original ECDC dataset is already in a friendly format, I have applied the same augmentations as described above for the JHU dataset:
  * the `europe` dataset (includes EU/EEA countries) (**this dataset is currently maintained by ECDC, and contains data from 2021-03-01**):
    * in JSON format: [values.json.zst](https://data.volution.ro/ciprian/f8ae5c63a7cccce956f5a634a79a293e/exports/ecdc/v1/europe/values.json.zst);
    * in TSV format: [values.tsv.zst](https://data.volution.ro/ciprian/f8ae5c63a7cccce956f5a634a79a293e/exports/ecdc/v1/europe/values.tsv.zst);
    * in SQL format (for SQLite): [values-sqlite.sql.zst](https://data.volution.ro/ciprian/f8ae5c63a7cccce956f5a634a79a293e/exports/ecdc/v1/europe/values-sqlite.sql.zst)
      and [values-sqlite.db.zst](https://data.volution.ro/ciprian/f8ae5c63a7cccce956f5a634a79a293e/exports/ecdc/v1/europe/values-sqlite.db.zst);
    * in JSON format only the "current status" (i.e. the latest values): [status.json](https://data.volution.ro/ciprian/f8ae5c63a7cccce956f5a634a79a293e/exports/ecdc/v1/europe/status.json);
  * the `worldwide` dataset (includes world countries, plus higher level aggregates) (**this dataset is no longer maintained by ECDC, and contains data until 2020-12-14**):
    * in JSON format: [values.json.zst](https://data.volution.ro/ciprian/f8ae5c63a7cccce956f5a634a79a293e/exports/ecdc/v1/worldwide/values.json.zst);
    * in TSV format: [values.tsv.zst](https://data.volution.ro/ciprian/f8ae5c63a7cccce956f5a634a79a293e/exports/ecdc/v1/worldwide/values.tsv.zst);
    * in SQL format (for SQLite): [values-sqlite.sql.zst](https://data.volution.ro/ciprian/f8ae5c63a7cccce956f5a634a79a293e/exports/ecdc/v1/worldwide/values-sqlite.sql.zst)
      and [values-sqlite.db.zst](https://data.volution.ro/ciprian/f8ae5c63a7cccce956f5a634a79a293e/exports/ecdc/v1/worldwide/values-sqlite.db.zst);
    * in JSON format only the "current status" (i.e. the latest values): [status.json](https://data.volution.ro/ciprian/f8ae5c63a7cccce956f5a634a79a293e/exports/ecdc/v1/worldwide/status.json);
* **for other files and formats see (https://data.volution.ro/ciprian/f8ae5c63a7cccce956f5a634a79a293e/exports/ecdc/v1/);**
* all the files above are also available in uncompressed format (just remove the `.zst` extension), or with `gzip` compression (just replace `.zst` with `.gz`);
* all the transformations and augmentations described for the JHU one were applied also to the ECDC one;
* the original data for the `europe` dataset is available at [ecdc.europa.eu](https://www.ecdc.europa.eu/en/publications-data/data-daily-new-cases-covid-19-eueea-country);
* the original data for the `worldwide` dataset is available at [ecdc.europa.eu](https://www.ecdc.europa.eu/en/publications-data/download-todays-data-geographic-distribution-covid-19-cases-worldwide);




### Dataset example

* all derived datasets (JHU, NY Times, ECDC) use exactly the same schema, thus can be used interchangeably;
* the first is an example of such an augmented record (from the `values.json` file);
* the second is an example of a status record (i.e. the latest values) (from the `status.json` file);
* also, these datasets are also available in SQL and SQLite database formats;


#### `values.json` example extract
~~~~
[
  ...

  {
    "dataset": "jhu/daily",
    "location": {
      "key": "fb583ceb1834efe5f595d1d7ac84a7f1",
      "type": "total-country",
      "label": "Italy",
      "country": "Italy",
      "country_code": "IT",
      "country_latlong": [
        42.83333333,
        12.83333333
      ],
      "province": null,
      "region": "Europe",
      "subregion": "Southern Europe",
      "administrative": null,
      "latlong": [
        42.83333333,
        12.83333333
      ]
    },
    "date": {
      "year": 2020,
      "month": 4,
      "day": 1,
      "date": "2020-04-01",
      "timestamp": 1585702800,
      "index": 71
    },
    "values": {
      "absolute": {
        "confirmed": 110574,
        "deaths": 13155,
        "recovered": 16847,
        "infected": 80572
      },
      "delta": {
        "confirmed": 4782,
        "recovered": 1118,
        "deaths": 727,
        "infected": 2937
      },
      "delta_pct": {
        "confirmed": 4.52019056261343,
        "recovered": 7.107889884925933,
        "infected": 3.7830875249565272,
        "deaths": 5.8496942388155775
      },
      "peak_pct": {
        "confirmed": 80.68979481641469,
        "recovered": 88.23993685872139,
        "deaths": 88.9405431857108,
        "infected": 67.14677640603567
      },
      "relative": {
        "deaths": 11.897010147050842,
        "recovered": 15.23595058512851,
        "infected": 72.86703926782064
      },
      "absolute_pop1k": {
        "confirmed": 1.771943724385206,
        "recovered": 0.26997247024361576,
        "deaths": 0.2108083246901386,
        "infected": 1.2911629294514517
      },
      "absolute_pop10k": {
        "confirmed": 17.71943724385206,
        "recovered": 2.6997247024361575,
        "deaths": 2.108083246901386,
        "infected": 12.911629294514517
      },
      "absolute_pop100k": {
        "confirmed": 177.19437243852062,
        "recovered": 26.997247024361577,
        "deaths": 21.08083246901386,
        "infected": 129.11629294514518
      }
    },
    "factbook": {
      "population": 62402659,
      "median_age": 46.5,
      "death_rate": 10.7,
      "area": 301340
    },
    "data_key": "fc397cfe886db71b40d2baf78a4827c5",
    "day_index_1": 62,
    "day_index_10": 41,
    "day_index_100": 39,
    "day_index_1k": 33,
    "day_index_10k": 23,
    "day_index_peak_confirmed": 8,
    "day_index_peak_deaths": 5,
    "day_index_peak": 6
  }

  ...
]
~~~~


#### `status.json` example extract
~~~~
{
  ...
  "countries": {
    ...

    "Italy": {
      "dataset": "jhu/daily",
      "location": {
        "label": "Italy",
        "type": "total-country",
        "country_code": "IT",
        "country": "Italy",
        "province": null,
        "administrative": null,
        "latlong": [
          42.83333333,
          12.83333333
        ]
      },
      "date": "2020-04-01",
      "day_index": {
        "confirmed_1": 62,
        "confirmed_10": 41,
        "confirmed_100": 39,
        "confirmed_1k": 33,
        "confirmed_10k": 23,
        "peak": 6,
        "peak_confirmed": 8,
        "peak_deaths": 5
      },
      "values": {
        "absolute": {
          "confirmed": 110574,
          "deaths": 13155,
          "recovered": 16847,
          "infected": 80572
        },
        "absolute_pop100k": {
          "confirmed": 177.19437243852062,
          "recovered": 26.997247024361577,
          "deaths": 21.08083246901386,
          "infected": 129.11629294514518
        },
        "delta": {
          "confirmed": 4782,
          "recovered": 1118,
          "deaths": 727,
          "infected": 2937
        },
        "relative": {
          "deaths": 11.897010147050842,
          "recovered": 15.23595058512851,
          "infected": 72.86703926782064
        },
        "peak_pct": {
          "confirmed": 80.68979481641469,
          "recovered": 88.23993685872139,
          "deaths": 88.9405431857108,
          "infected": 67.14677640603567
        }
      },
      "factbook": {
        "population": 62402659,
        "median_age": 46.5,
        "death_rate": 10.7,
        "area": 301340
      }
    }

    ...
  }
  ...
}
~~~~



## Attribution

If you use any of these derived datasets, please attribute both the original dataset and my derived dataset.

Choose (and adapt if necessary) one (or more) of the following snippets depending on which derived dataset you are using:

~~~~
based on original data from JHU CSSE (https://github.com/CSSEGISandData/COVID-19),
as processed and augmented at https://github.com/cipriancraciun/covid19-datasets
~~~~

~~~~
based on original data from ECDC (https://www.ecdc.europa.eu/),
as processed and augmented at https://github.com/cipriancraciun/covid19-datasets
~~~~

~~~~
based on original data from "The New York Times" (https://github.com/nytimes/covid-19-data),
as processed and augmented at https://github.com/cipriancraciun/covid19-datasets
~~~~




## Licensing

* the graphs are licensed under the *Creative Commons Attribution-ShareAlike 4.0 (CC BY-SA 4.0)* license;
* the data files are licensed under the *Creative Commons Attribution-NonCommercial 4.0 (CC BY-NC 4.0)* license;
* the sources and scripts are licensed under the *Affero General Public License v3 (AGPLv3)* license;
* however, the original JHU CSSE COVID-19 data is copyrighted by the *Johns Hopkins University*,
  and *provided to the public strictly for educational and academic research purposes*;
  therefore I don't know if I am actually able to license my derived files data as *CC BY-NC 4.0*;
* also, the original NY COVID-19 data is copyrighted by *The New York Times*,
  and *made publicly available for broad, non-commercial public use*;
  although they state that "the license is co-extensive with the *CC BY-NC 4.0*";
* also, the original ECDC COVID-19 data is copyrighted by (I assume) the ECDC,
  and *users must comply with data use restrictions to ensure that the information will be used solely for statistical analysis or reporting purposes*,
  therefore I don't know if I am actually able to license my derived files data as *CC BY-NC 4.0*;
* although given the global situation, I'll let the lawyers decide later...

