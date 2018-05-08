# TRANSFORM-Library
__TRANsient Simulation Framework of Reconfigurable Models__


A Modelica based library for modeling thermal hydraulic energy systems and other multi-physics systems



This is the development site for the Modelica _TRANSFORM_ library and its user guide.

Instructions for developers are available on the [wiki](https://github.com/ORNL-Modelica/TRANSFORM-Library/wiki).

## Versioning/Releases

A form of [SemVer](http://semver.org/) is used for versioning.

Version: 0.0.0b

As library is in its beta stage, library may change often with compatability breaking changes. Thought you should know!

## Getting Started

- To use download or clone the repository and Load/Open in your favorite Modelica development environment.

### Prerequisites

This library has been tested with:

- Dymola 2018FD01

### Check that the Library is working

- To test that the library is working, run the `runAll.mos` script. This will simulate all the examples which are included in the regression tests.


## Authors

* **Scott Greenwood**

See also the list of [contributors](https://github.com/ORNL-Modelica/TRANSFORM-Library/contributors) who participated in this project.

## License

This project is licensed under the UT-Battelle Open Source [License](LICENSE.md) (Permissive) - see the [LICENSE.md](LICENSE.md) file for details

Copyright 2017, UT-Battelle, LLC

## To Contribute...
You may report any issues with using the [Issues](https://github.com/ORNL-Modelica/TRANSFORM-Library/issues) button.

Contributions in the form of [Pull Requests](https://github.com/ORNL-Modelica/TRANSFORM-Library/pulls) are always welcome.
Prior to issuing a pull request, make sure your code follows the [style guide and coding conventions]()

## Acknowledgments
This application uses Open Source components. You can find the source code of their open source projects along with license information below. We acknowledge and are grateful to these developers for their contributions to open source.

Project: Modelica Standard Library https://github.com/modelica/Modelica

3-Clause BSD License https://github.com/modelica/ModelicaStandardLibrary/blob/master/LICENSE

## Citation
Greenwood, M. S.: TRANSFORM - TRANsient Simulation Framework of Reconfigurable Models. Computer Software. https://github.com/ORNL-Modelica/TRANSFORM-Library. 07 Nov. 2017. Web. Oak Ridge National Laboratory. doi:10.11578/dc.20171109.1.

## Extended Description

Existing development tools for early stage design and scoping of energy systems are often time consuming to use, proprietary, and do not contain the necessary function to model complete systems (i.e., controls, primary, and secondary systems) in a common platform. The Modelica programming language based TRANSFORM tool (1) provides a standardized, common simulation environment for early design of energy systems (i.e., power plants), (2) provides a library of baseline component modules to be assembled into full plant models using available geometry, design, and thermal-hydraulic data, (3) defines modeling conventions for interconnecting component models, and (4) establishes user interfaces and support tools to facilitate simulation development (i.e., configuration and parameterization), execution, and results display and capture.
