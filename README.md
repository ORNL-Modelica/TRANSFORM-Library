# TRANSFORM-Library
__TRANsient Simulation Framework of Reconfigurable Models__

A Modelica based library for modeling thermal hydraulic energy systems and other multi-physics systems.

## Check out the TRANSFORM demo reel to get excited!

[![TRANSFORMDemo](http://img.youtube.com/vi/esUoh9zBK-M/0.jpg)](https://youtu.be/lEhW7kK8ypw)

## Requirements

Dymola

Optional libraries, needed only by the models that use them:

- [ExternalMedia](https://github.com/modelica-3rdparty/ExternalMedia) 4.0.0, for the CoolProp media in `TRANSFORM.Media.ExternalMedia` and the models that use them.
- [SDF](https://github.com/ScientificDataFormat/SDF-Modelica) 0.4.5, for the critical heat flux and film boiling look-up tables. Dymola 2026x ships it.

## Related Training

For training related to TRANSFORM, please see the [TRANSFORM Training repository](https://github.com/ORNL-Modelica/TRANSFORM-Training)

### Check that the Library is working

- The regression tests and their reference results live in [TRANSFORM-UnitTests](https://github.com/ORNL-Modelica/TRANSFORM-UnitTests). They run with [DSTF](https://github.com/ORNL-Modelica/DynamicSystemsTestingFramework) (Dynamic Systems Testing Framework); see the TRANSFORM-UnitTests README for the commands.

## License

TRANSFORM itself is licensed as follows:

Copyright 2017, UT-Battelle, LLC

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

## To Contribute...
You may report any issues with using the Issues button.

Contributions in the form of Pull Requests are always welcome.
See [CONTRIBUTING.md](CONTRIBUTING.md) for how to change the library without breaking user models.
Prior to issuing a pull request, make sure your code follows the conventions in `TRANSFORM.UsersGuide.Conventions` (the Conventions package of the User's Guide inside the library, [TRANSFORM/UsersGuide/Conventions](TRANSFORM/UsersGuide/Conventions)). Its Checklist page lists what to check.

## Citation
Greenwood, M. S.. TRANSFORM - TRANsient Simulation Framework of Reconfigurable Models. Computer Software. https://github.com/ORNL-Modelica/TRANSFORM-Library. USDOE. 26 Sep. 2017. Web. doi:10.11578/dc.20171025.2022.
