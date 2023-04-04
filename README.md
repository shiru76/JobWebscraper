
# Job Web Scraper

This project scrapes data analyst jobs from Jobstreet PH.

## Setup
1. Install Python
2. Install Jupyter
3. Install requests module
```
pip install requests
```
4. Install beautifulsoup4 package
```
pip install beautifulsoup4
```
5. Install pandas package
```
pip install pandas
```
5. Install numpy package
```
pip install numpy
```

## How to use this tool?
Simply run the Job Webscraper.ipynb in Jupyter.

## Output
This program will automatically produce jobstreet_dataset.xls

*Column Description of the Excel*

* title: job title
* company: company that posted the job
* location: where the job is located
* salary: salary range of the job
* days_since_posted: number of days since the job was posted
* link: link for the job posting
* night_shift: jobs requiring to work at night
* sql: jobs requiring SQL skill
* excel: jobs requiring Excel skill
* tableau: jobs requiring Tableau skill
* power_bi: jobs requiring Power BI skill
* python: jobs requiring Python skill
* r: jobs requiring R skill
* career_level: career level requirement for the job
* qualification: degree requirement for the job
* years_of_experience: number of years as an experienced employee
* job_type: full-time, part-time, or contract
* specialization: job specialization
* specialty: job specialty
* registration_no: registration number of the company
* company_size: number of employees working for the company
* ave_process_time: average processing time of the job posting
* industry: company industry
* benefits_and_others: company benefits and other information

## Disclaimer
I do not condone scraping data from Jobstreet PH in any way. Anyone who wishes to do so should first read their [Terms of Use](https://www.jobstreet.com/about-us/en-ph/terms-of-use/).




