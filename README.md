Computational Models for the project APUP (Atypical Processing of Uncertainty in Psychosis)
====================

Accompanying manuscript: Atypical processing of uncertainty in individuals at risk for psychosis

Authors: David M. Cole, Andreea O. Diaconescu, Ulrich J. Pfeiffer, Kay H. Brodersen, Christoph D. Mathys, Dominika Julkowski, Stephan Ruhrmann, Leonhard Schilbach, Marc Tittgemeyer, Kai Vogeley, Klaas E. Stephan


About this Code
---------------

This analysis was run using Matlab R2018b on a Mac OS System (MacBook Pro Mojave version 10.14.6). 


Getting Started
---------------

To run the whole computational modelling analysis, simply set the paths using `apup_set_path` and then run the main script `apup_main`.

Running parts of the analysis pipeline:

- Load analysis settings `options = apup_options(options)`.
- Fitting of experimental data: The main function is `loop_analyze_behaviour_local.m`
    - Note that this part of the code will only run, if you have access to the 
      acquired behavioral data.

- Second level analyses:
`apup_second_level(options,comparisonType)`. 

The `comparisonType` allows you to perform group level analysis for all subjects when `comparisonType = 'all'` or only controls `comparisonType = 'controls'` or only patients, `comparisonType = 'patients'`. 