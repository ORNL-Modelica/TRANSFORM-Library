within TRANSFORM.Examples.MoltenSaltReactor.Data.FissionProducts;
partial record PartialFissionProduct

  extends TRANSFORM.Icons.Record;

  constant String[:] extraPropertiesNames= fill("", 0) "Names of transport fission products";
  constant String[:] fissionSourceNames = fill("", 0) "Name of original source of fission products";

  final constant Integer nC=size(extraPropertiesNames, 1) "# of fission products";
  constant Real C_nominal[nC] = fill(1e14,nC) "Default for the nominal values for the extra properties";

  final constant Integer nFS=size(fissionSourceNames, 1) "# of fission product sources";

  // Data
  parameter Real[nC,nFS] fisYield_t "Fission yield per thermal fission";

  parameter Real[nC,nFS] fisYield_f "Fission yield per fast fission";

  parameter SIadd.InverseTime[nC] lambdas "Half-life of fission product";


  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialFissionProduct;
