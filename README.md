# TRANSFORM Library

**TRANSFORM** (TRANsient Simulation Framework of Reconfigurable Models) is a Modelica library for thermal hydraulics, heat and mass transfer, media, controls, and related multiphysics systems.

## Start here

1. Load `TRANSFORM/package.mo` in a Modelica tool with the Modelica Standard Library 4.0.0 available. The package declares dependencies on `Modelica`, `ModelicaServices`, and `Complex` 4.0.0.
2. Open `TRANSFORM.UsersGuide.Overview` for the package map and modeling conventions.
3. Explore `TRANSFORM.Fluid.Volumes.Examples.SimpleVolume_Test` or the examples beside a component of interest. An example is a starting point, not a guarantee that it runs in every compiler or without optional libraries.

The library has historically been developed and tested primarily with Dymola. OpenModelica coverage exists in the separate regression repository, but varies by model and platform. Compiler support should be checked for the specific model, medium, and external dependencies you intend to use.

## Optional dependencies

Some packages and examples need libraries beyond the top-level `uses(...)` declaration. `TRANSFORM.Media.ExternalMedia` uses the separate [ExternalMedia](https://github.com/modelica-3rdparty/ExternalMedia) library and its CoolProp backend. Some table media and mathematical functions use native libraries, including GSL and TRANSFORM's interpolation code. Selected critical-heat-flux models use SDF. These dependencies are model-specific; inspect the selected model before treating an example as portable.

## Learning and testing

- [TRANSFORM demo reel](https://youtu.be/lEhW7kK8ypw) shows applications of the library.
- [TRANSFORM-Training](https://github.com/ORNL-Modelica/TRANSFORM-Training) contains a staged flow-loop course. Its declared TRANSFORM dependency is older than this checkout, so verify it with the revision you load.
- [TRANSFORM-UnitTests](https://github.com/ORNL-Modelica/TRANSFORM-UnitTests) stores regression configuration and reference results. Its README explains how to run tests with [DynamicSystemsTestingFramework (DSTF)](https://github.com/ORNL-Modelica/DynamicSystemsTestingFramework). The test runner and baselines are maintained there; this repository does not contain `runAll_*.mos` scripts.
- [TRANSFORM 2.0 investigation and roadmap](docs/TRANSFORM_2_0_INVESTIGATION_AND_ROADMAP.md) records current evidence, priorities, and decision gates.

## Contributing

Report problems in [GitHub Issues](https://github.com/ORNL-Modelica/TRANSFORM-Library/issues) and propose changes through pull requests. The [documentation and editorial style guide](docs/STYLE_GUIDE.md) describes the current text-only documentation standard and its review boundaries. For behavior changes, include the affected models, tool versions, and relevant test results.

## License and citation

TRANSFORM is licensed under the [Apache License 2.0](LICENSE.txt). Copyright 2017, UT-Battelle, LLC.

Greenwood, M. S. *TRANSFORM - TRANsient Simulation Framework of Reconfigurable Models*. Computer Software. USDOE, 26 September 2017. [doi:10.11578/dc.20171025.2022](https://doi.org/10.11578/dc.20171025.2022).
