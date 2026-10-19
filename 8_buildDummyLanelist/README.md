# Synthetic lane-boundary generation

This module generates dummy lane boundaries for studying centreline extraction
without requiring a Lanelet2 map. Straight and curved segments vary in width,
radius, angle and boundary sampling. Coordinates are synthetic planar metres.

## Run

Set the MATLAB current folder to this directory and run
`main_buildDummyLanelist_LHS`. The driver and `utilityFunc` generate geometry
and resample it using Latin hypercube sampling (`lhsdesign`), which requires
Statistics and Machine Learning Toolbox.

The script writes `laneList` to `../0_data/LaneletData/laneList_dummy.mat` and
overwrites that file. Review the parameter arrays and repetition count in the
driver before generating a large collection. Random sampling means a regenerated
file need not reproduce the bundled points exactly.

## Contents and use

- `utilityFunc`: segment construction, geometry and resampling helpers.
- `plotFunc`: synthetic lane visualisation.
- `laneList_dummy.mat`: generated data stored under `0_data`, not this folder.

The MAT format stores the boundary structure expected by the centreline method
directly, so map extraction and lane reconstruction can be skipped. Use the
[synthetic quick start](../README.md#quick-start-synthetic-boundaries) with a
zero plotting origin. Dummy data is independent of the inD and rounD maps and
is intended for algorithm demonstrations rather than traffic-rule validation.
