---
pretty_name: Lane Centerline Extraction from Surveyed Boundaries
license: mit
language:
  - en
tags:
  - matlab
  - autonomous-driving
  - lane-centerline
  - computational-geometry
  - maximal-disks
  - research
---

# Lane Centerline Extraction from Surveyed Boundaries

MATLAB reference implementation and synthetic demonstration data for the
maximal-disk lane-centerline extraction method described in:

> C. Yin, M. Cecotti, D. J. Auger, A. Fotouhi, and H. Jiang,
> "Lane Centerline Extraction Based on Surveyed Boundaries: An Efficient
> Approach Using Maximal Disks," *Sensors*, vol. 25, no. 8, article 2571,
> 2025. https://doi.org/10.3390/s25082571

This repository is intended to be published as a Hugging Face **Dataset**
repository containing research code and a small, fully synthetic lane-boundary
dataset. It is not a trained model and not an executable Hugging Face Space.

## Important data notice

The real-world maps used in the paper originated from the
[inD](https://levelxdata.com/ind-dataset/) and
[rounD](https://levelxdata.com/round-dataset/) datasets. Their terms prohibit
redistribution of the datasets or modified versions. Consequently:

- the original Lanelet2 maps are not included;
- real-world derived files named `*locn1*` through `*locn5*` are not part of
  the public release;
- those files may exist in a private development checkout, but `.gitignore`
  prevents them from being committed;
- users who need the original datasets must request access from the dataset
  providers and comply with their terms independently.

The only distributable demonstration data in this repository is
`0_data/LaneletData/laneList_dummy.mat`. It is generated synthetically by the
scripts in `8_buildDummyLanelist` and contains no inD or rounD map data.

Before publishing, use Git to stage the repository and verify that no
`locn1`-`locn5` files are tracked. Do not upload the local folder with a tool
that ignores `.gitignore`.

## Scope

The public workflow starts from **already generated lane boundaries**. Each
lane must provide ordered left- and right-boundary points. Lanelet2 parsing,
map import, lane reconstruction, and distribution of source Lanelet2 files are
outside the scope of this repository.

## Requirements

- MATLAB R2020b or later
- Statistics and Machine Learning Toolbox

The project was developed for MATLAB R2020b. The current code and the
synthetic workflow were additionally checked with MATLAB R2025b.

## Quick start with the synthetic data

Start MATLAB in the repository root and run:

```matlab
repoRoot = pwd;
algorithmRoot = fullfile(repoRoot, ...
    '3_centrelineCalculation', 'maximalDisks');

addpath(genpath(algorithmRoot));
rmpath(genpath(fullfile(algorithmRoot, 'notUsed')));

inputFile = fullfile(repoRoot, '0_data', 'LaneletData', ...
    'laneList_dummy.mat');
load(inputFile, 'laneList');

utmOrigin.x = 0;
utmOrigin.y = 0;
discretInfo.isCnlDiscret = 1;
discretInfo.cnlDiscretStep = 0.4; % metres

[laneListWithCentreline, circlesConnected] = ...
    calculateCentreline_MaximalDisk_sixCases( ...
        laneList, discretInfo, utmOrigin);

% Optional: visualise the dummy lanes and maximal disks.
plotCentreline_MaximalDisk_dummy(laneListWithCentreline, utmOrigin);
```

The dummy plotting function uses the generated lane boundaries directly and does
not require an `alignedLanelet` map object.

`main_calculateCentreline_MD.m` is an editable research driver whose input,
coordinate origin, plotting data, discretisation setting, and output filename
must be configured consistently for the selected scenario. It also expects
MATLAB's current folder to be
`3_centrelineCalculation/maximalDisks`.

## Input format

The input MAT-file must contain a structure array named `laneList`. Each lane
has this minimum schema:

```text
laneList(i)
├── leftBoundary.Points(j).UTM_x
├── leftBoundary.Points(j).UTM_y
├── rightBoundary.Points(k).UTM_x
└── rightBoundary.Points(k).UTM_y
```

Requirements:

- coordinates are planar metric coordinates;
- points on each boundary are ordered along the direction of travel;
- left and right boundaries describe the same lane and use a consistent
  direction;
- `utmOrigin.x` and `utmOrigin.y` use the same coordinate system as the
  boundary points;
- sparse boundaries are supported, but severely incomplete or incorrectly
  ordered boundaries can produce invalid centerlines.

The included synthetic file contains 36 lanes and only the four boundary
coordinate fields shown above.

## Output format

The primary output is the input `laneList` augmented with:

```text
laneListWithCentreline(i).centerline.Points(j).UTM_x
laneListWithCentreline(i).centerline.Points(j).UTM_y
laneListWithCentreline(i).centerline.Points(j).radius
```

`radius` is the corresponding maximal-disk radius in metres. The second
output, `circlesConnected`, is the internal connected-circle representation
for the last processed lane and is mainly intended for debugging and
visualisation.

## Repository layout

```text
0_data/
  LaneletData/                 Synthetic public input and ignored local data
  centrelineComparasion/       Local generated results; real-data results ignored
3_centrelineCalculation/
  maximalDisks/                Maximal-disk implementation and main driver
8_buildDummyLanelist/          Synthetic lane-boundary generators
```

Directories for Lanelet2 extraction and lane reconstruction are intentionally
not part of the public workflow. The repository assumes those preprocessing
steps have already been completed by the user.

## Method summary

The implementation searches for maximal disks constrained by sparse left and
right lane-boundary points and segments. Candidate disks are filtered,
connected in boundary order, checked for ligature artifacts, and optionally
discretised into a centerline with a user-defined spacing.

## Limitations

- The method assumes correctly ordered and geometrically consistent lane
  boundaries; it does not repair map topology.
- It does not infer lane connectivity or import Lanelet2 maps.
- Results depend on boundary sparsity, measurement quality, lane geometry,
  and the selected discretisation spacing.
- Degenerate or strongly self-intersecting boundaries may require manual
  inspection.
- The code is research software and has not been certified for safety-critical
  planning or control.
- Reproducing the paper's real-world experiments requires separately licensed
  source data that cannot be redistributed here.

## Synthetic data generation

The synthetic `laneList_dummy.mat` can be regenerated using either:

- `8_buildDummyLanelist/main_buildDummyLanelist_LHS.m`
- `8_buildDummyLanelist/main_buildDummyLanelist_Rand.m`

These scripts generate parametrised curved and straight lane boundaries with
different widths, radii, intersection angles, and sampling densities.

## Third-party software

`3_centrelineCalculation/maximalDisks/conicsIntersection1.04` contains
**Conics intersection** by Pierluigi Taddei, version 1.0.4, obtained from
[MATLAB Central File Exchange](https://www.mathworks.com/matlabcentral/fileexchange/28318-conics-intersection).
The bundled copy is unmodified and remains under its original BSD 2-Clause
license. See `THIRD_PARTY_NOTICES.md` and the license file inside that
directory.

## Version and authors

- Public release version: **1.0.0**
- Chenhui Yin
- Marco Cecotti
- Daniel J. Auger
- Abbas Fotouhi
- Haobin Jiang

## Citation

If this repository contributes to your research, cite the associated paper:

```bibtex
@Article{Yin_2025_LaneCenterlineExtractionBasedonSurveyedBoundariesanEfficientApproachUsingMaximalDisks,
  author    = {Yin, Chenhui and Cecotti, Marco and Auger, Daniel J. and Fotouhi, Abbas and Jiang, Haobin},
  journal   = {Sensors},
  title     = {Lane Centerline Extraction Based on Surveyed Boundaries: An Efficient Approach Using Maximal Disks},
  year      = {2025},
  month     = apr,
  number    = {8},
  pages     = {2571},
  volume    = {25},
  issn      = {1424-8220},
  doi       = {10.3390/s25082571},
  publisher = {MDPI AG}
}
```

Machine-readable citation metadata is provided in `CITATION.cff`, and a
standalone BibTeX entry is provided in `CITATION.bib`.

## License

The original project code and synthetic dummy data are released under the MIT
License; see `LICENSE`. The MIT License does not apply to the excluded inD or
rounD data, nor does it replace the license of bundled third-party software.
