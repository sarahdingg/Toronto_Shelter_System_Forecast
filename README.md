# Toronto Shelter System Flow Forecast

## Overview

This repo contains all data and files needed to perform the analysis of the Toronto Shelter System's performance on reducing chronic homelessness. Data is obtained from an open source, Open Data Toronto.


## File Structure

The repo is structured as:

-   `data/raw_data` contains the raw data as obtained from Open Data Toronto.
-   `data/analysis_data` contains the cleaned dataset that was constructed.
-   `model` contains fitted models. 
-   `other` contains relevant literature, details about LLM chat interactions, and sketches.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, download and clean data.


## Statement on LLM usage

Aspects of the code were written with the assistance of ChatGPT. The data cleaning, testing and modelling scripts, as well as discussions, results, introduction, model sections were written with the help of ChatGPT and the entire chat history is available in inputs/llms/usage.txt.