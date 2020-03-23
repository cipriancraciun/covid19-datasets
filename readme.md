

# COVID-19 derived datasets

This repository contains datasets related to COVID-19.

None of these datasets were collected by me, however I have re-processed, re-formated and augmented them for easier manipulation.

Also I have created some graphs based on the derived data which are available at:
* https://scratchpad.volution.ro/ciprian/eedf5eb117ec363ca4f88492b48dbcd3/
* or inside the [./plots] folder of this repository;




## Disclaimer

As with anything on the Internet these days, I take no responsibility for anything.




## Selected plots

![absolute-confirmed](./plots/jhu/global/svg/absolute-confirmed.svg)
![delta-confirmed](./plots/jhu/global/svg/delta-confirmed.svg)
![absolute-deaths](./plots/jhu/global/svg/absolute-deaths.svg)




## JHU CSSE COVID-19 dataset

* the original data is available at [github.com/CSSEGISandData/COVID-19](https://github.com/CSSEGISandData/COVID-19);
* the re-formatted data is available as <a href="./exports/jhu/values.tsv">TSV</a> or <a href="./exports/jhu/values.json">JSON</a> on this site;
* `day_index_1000` means how many days have passed for that country since there were at least 1000 confirmed cases;
* `relative_*` means the percentage of that metric relative to the number of confirmed cases for that same day;
* `delta_*` means the delta of that metric compared to the same metric for the previous day;
* `*_infected` means the number of "active" cases (i.e. `infected := confirmed - recovered - deaths`);




## Licensing

* the graphs are licensed under the *Creative Commons Attribution-ShareAlike 2.0 (CC BY-SA 2.0)* license;
* the data files are licensed under the *Creative Commons Attribution-ShareAlike 2.0 (CC BY-SA 2.0)* license;
* however the original JHU CSSE COVID-19 data is copyrighted by the *Johns Hopkins University*,
  and *provided to the public strictly for educational and academic research purposes*;
  therefore I don't know if I am actually able to license my derived files as *CC BY-SA 2.0*;
  although given the global situation, I'll let the lawyers decide later...

