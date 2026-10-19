# Lanelet2 map extraction

This module reads Lanelet2 OSM XML and creates MATLAB lanelet and multipolygon
structures. It stores WGS84 coordinates, converts them to metric UTM coordinates,
reads `one_way` and `subtype` attributes, and records boundary orientation flags.
It does not calculate lane centrelines or provide the full Lanelet2 routing API.

## Run

Set the MATLAB current folder to this directory and run `main_extractLanelets`.
Mapping Toolbox is required for `wgs84Ellipsoid`, `defaultm` and `mfwdtran`.
The script requires `../0_data/mapData/demo Lanelet2 map.osm` and writes:

- `../0_data/LaneletData/originalLanelet_demo.mat`, containing `lanelet`.
- `../0_data/LaneletData/originalMultiPoly_demo.mat`, containing `multiPoly`.

Outputs are overwritten. The script also clears the workspace and opens figures.

## Configuration and coordinates

Configure the input filename, `sceID`, output filenames and reference point in
the driver. The current demo uses:

```matlab
origin.utm_x = 736190;
origin.utm_y = 3565310;
origin.utm_zone = '50N';
```

`wgs2utm` reads the zone directly from `origin.utm_zone`; there is no fallback.
The current implementation stores absolute UTM coordinates in metres
(`isGlobal = 1`). The reference point is plotted as a marker; it does not move
these plots to a local `(0,0)` coordinate frame. Internally, `WGS84_x` stores
latitude and `WGS84_y` longitude. Boundary points use the lowercase field
`leftBoundary.points` or `rightBoundary.points`.

The legacy Mapping Toolbox `zone` notation uses latitude-band letters rather
than EPSG hemisphere notation. The current `50N` setting selects a northern
zone-50 projection; the demo latitude lies in band S. Keep that distinction in
mind when configuring another map. See [MathWorks UTM conventions](https://www.mathworks.com/help/map/create-utm-maps.html).

## Structure

- `main_extractLanelets.m`: input, coordinate settings, saving and plotting.
- `utilityFunc`: XML parsing, element lookup, extraction and orientation checks.
- `plotFunc`: map and boundary visualisation.

Continue with [lane reconstruction](../2_rebuildLanes/README.md).

## Supported inputs and limitations

The parser was initially developed around inD and rounD maps. It expects
Lanelet2 `type=lanelet` relations with left/right way references, and geographic
`lat`/`lon` node coordinates. Generic OSM road maps are not interchangeable with
these inputs. XML whitespace and type-tag order no longer determine traversal.
See the [official Lanelet2 documentation](https://github.com/fzi-forschungszentrum-informatik/Lanelet2).

This is a project-specific parser: regulatory elements, full traffic rules,
elevation and multipolygon inner rings are not fully represented. Missing
boundary references, missing attributes and degenerate boundaries still need
stronger validation. Do not assume arbitrary Lanelet2 maps are supported.
Recent parser changes have received static checks, but a fresh execution-based
comparison across differently formatted XML files has not been completed.

### Driving-road visualisation

`plotFunc/plotDrivingRoad.m` currently excludes all lanelets with
`isOneWay == 0` from its plot. Bidirectional travel does not imply a walkway,
so this filter can also hide valid bidirectional driving lanes. Driving-road
selection should use the road subtype or `isWalkWay` rather than `isOneWay`.
This is a limitation of the plotting filter; the function does not remove
those lanelets from the extracted data.
