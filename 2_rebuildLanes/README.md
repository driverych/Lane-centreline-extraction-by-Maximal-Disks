# Lane reconstruction

This module aligns extracted lanelet boundaries and joins lanelets into
consecutive lane paths. The current driver uses `buildLanes_DFS_noLoop` to build
static topology and enumerate paths without revisiting a lanelet within a path.

## Run and input

First run [map extraction](../1_extractLanelets/README.md). Set the MATLAB current
folder to this directory, then run `main_rebuildLanes`.
The default input is `../0_data/LaneletData/originalLanelet_demo.mat`, containing
`lanelet`. Input lanelets must have IDs, boundary point IDs and UTM coordinates,
point counts, `isOneWay`, and boundary inversion/flipping flags.

The script clears the workspace, closes figures, displays lanes, and overwrites:

| File in `../0_data/LaneletData` | Variable |
| --- | --- |
| `alignedLanelet_demo.mat` | `alignedLanelet` |
| `laneList_demo.mat` | `laneList` |
| `laneList_LaneletID_demo.mat` | `IDs_laneLanelets` |

For another input, update input/output filenames and the plotting reference
point together. The demo reference is `(736190,3565310)` metres.

## Structure and output

- `utilityFunc`: initial lanelets, topology, DFS paths, alignment and duplicate removal.
- `plotFunc`: reconstructed lanes and lanelet boundaries.
- `notUsed`: older implementations and unused helpers, retained for reference.

Aligned lanelets retain lowercase `boundary.points`; reconstructed lanes use
`leftBoundary.Points` and `rightBoundary.Points`. MATLAB field names are case
sensitive. The lanelet-ID table uses zero padding for shorter paths.
Continue with [centreline calculation](../3_centrelineCalculation/README.md).

## Limitations

Connectivity is inferred from matching boundary endpoint IDs, not proximity or
full Lanelet2 routing rules. Missing attributes and invalid references can stop
the workflow. Pure cyclic components may have no initial lanelet; path coverage
and bidirectional traversal need checking for a new map. Highly branching maps
can generate many paths. Duplicate removal now compares point-ID sequences
using `isequal`; empty-input handling and trailing index-table rows remain
known areas for improvement. 
