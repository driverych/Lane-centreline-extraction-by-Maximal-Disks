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

Direct the directory to `3_centrelineCalculation/maximalDisks` and run 
`main_calculateCentreline_MD.m`. This main script is an editable research driver whose input,
coordinate origin, plotting data, discretisation setting, and output filename
must be configured consistently for the selected scenario.

The dummy plotting function `plotCentreline_MaximalDisk_dummy` uses the generated lane boundaries directly and does
not require an `alignedLanelet` map object.

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
  LaneletData/                 Synthetic public input
  centrelineComparasion/       Local generated results
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

The synthetic `laneList_dummy.mat` can be regenerated using:

- `8_buildDummyLanelist/main_buildDummyLanelist_LHS.m`

This script generates parametrised curved and straight lane boundaries with
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
