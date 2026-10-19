# Centreline calculation

`maximalDisks` contains the maximal-disk method used in the associated paper.
It searches for disks constrained by lane boundaries, connects their centres,
processes ligatures and optionally discretises the resulting centreline.

## Run

Set the MATLAB current folder to `maximalDisks` and run
`main_calculateCentreline_MD`. Statistics and Machine Learning Toolbox is needed
for the neighbour-search operations. The default input is
`../../0_data/LaneletData/laneList_demo.mat`, produced by
[lane reconstruction](../2_rebuildLanes/README.md).

The current driver uses the demo reference point `(736190,3565310)` metres,
`discretInfo.isCnlDiscret = 1`, and `discretInfo.cnlDiscretStep = 0.5` metres.
It saves `laneList` to
`../../0_data/centrelineComparasion/cnlWithMDP_cnlDiscret_5dm_demo.mat`.
Configured outputs are overwritten. The script clears the workspace and closes
figures before calculation.

To use synthetic data, change the input to `laneList_dummy.mat`, set both origin
coordinates to zero, and select the dummy output filename. See the
[top-level quick start](../README.md#quick-start-synthetic-boundaries).
`plotCentreline_MaximalDisk_dummy` handles either boundary-only input without
requiring an aligned-lanelet map object.

## Input and output

`laneList(i)` must supply ordered, consistently directed left and right
boundaries in planar metres using `leftBoundary.Points` and
`rightBoundary.Points`, with `UTM_x` and `UTM_y` coordinates.
The output adds `centerline.Points` with `UTM_x`, `UTM_y` and `radius` fields.
The second function output, `circlesConnected`, describes the last processed
lane and is intended for inspection rather than an all-lane result container.

## Structure and limitations

Within `maximalDisks`, the driver coordinates the workflow; helper subfolders
handle geometry, discrimination, point sequencing and plotting.
`conicsIntersection1.04` is bundled third-party software with its own license;
see [third-party notices](../THIRD_PARTY_NOTICES.md).

Results depend on boundary quality and spacing. This method does not repair map
topology, and degenerate or self-intersecting boundaries need inspection.
Switching input scenarios requires consistent filenames and coordinate origins.
Recent preprocessing edits have not been verified by a fresh end-to-end run.
