within TRANSFORM.Nuclear.ReactorKinetics.Data.FissionProducts;
partial record PartialFissionProduct

  extends TRANSFORM.Icons.Record;

  constant String[:] extraPropertiesNames= fill("", 0) "Names of transport fission products";
  constant String[:] fissionSourceNames = fill("", 0) "Name of original source of fission products";
  constant String[:] fissionTypes = fill("", 0) "Name of fission type for each source of fission products";

  final constant Integer nC=size(extraPropertiesNames, 1) "# of fission products (e.g., I/Xe)";
  constant Real C_nominal[nC] = fill(1e14,nC) "Default for the nominal values for the extra properties";

  final constant Integer nFS=size(fissionSourceNames, 1) "# of fission product sources (e.g., U/Pu)";

  final constant Integer nT=size(fissionTypes, 1) "# of fission product sources (e.g., fast/thermal)";

  // Data
  parameter Real[nC,nFS,nT] fissionYield "Fission yield per fission per source and type";

  parameter SIadd.InverseTime[nC] lambdas "Half-life of fission product";

  parameter SI.Energy[nC] w_decay = fill(0,nC) "Energy release (near field - beta) per fission product decay per type";
  parameter SI.Energy[nC] wG_decay = fill(0,nC) "Energy release (far field - gamma) per fission product decay per type";

  parameter SI.Area[nC] sigmaA_thermal = fill(0,nC) "Thermal absorption cross-section for reactivity feedback";
  parameter SI.Area[nC] sigmaA_fast = fill(0,nC) "Fast absorption cross-section for reactivity feedback";

  constant Real[nC,nC] parents = fill(0,nC,nC) "Matrix of parent sources (sum(column) = 0 or 1) for each fission product 'daughter'. Row is daughter, Column is parent.";

  annotation (defaultComponentName="data",Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialFissionProduct;
