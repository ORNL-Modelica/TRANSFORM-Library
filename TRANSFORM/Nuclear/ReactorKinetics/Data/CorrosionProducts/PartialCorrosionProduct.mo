within TRANSFORM.Nuclear.ReactorKinetics.Data.CorrosionProducts;
partial record PartialCorrosionProduct
  extends TRANSFORM.Icons.Record;
  constant String[:] extraPropertiesNames= fill("",0) "Names of groups";
  final constant Integer nC=size(extraPropertiesNames, 1) "# of groups";
  constant Real C_nominal[nC]=fill(1e14, nC) "Default for the nominal values for the extra properties";
  // Data
  parameter TRANSFORM.Units.InverseTime[nC] lambdas = fill(0,nC) "Decay constants for each group";
  constant Real[nC,nC] parents = fill(0,nC,nC) "Matrix of parent sources (sum(column) = 0 or 1) for each product 'daughter'. Row is daughter, Column is parent.";
  parameter SI.Energy w_near_decay[nC]=fill(0, nC)
    "Energy release (near field - beta) per product decay per type";
  parameter SI.Energy w_far_decay[nC]=fill(0, nC)
    "Energy release (far field - gamma) per product decay per type";
  annotation (defaultComponentName="data",Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialCorrosionProduct;
