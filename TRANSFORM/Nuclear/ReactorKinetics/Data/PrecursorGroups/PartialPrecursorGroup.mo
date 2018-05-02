within TRANSFORM.Nuclear.ReactorKinetics.Data.PrecursorGroups;
partial record PartialPrecursorGroup

  extends TRANSFORM.Icons.Record;

  constant String[:] extraPropertiesNames= fill("",0) "Names of precursor groups";

  final constant Integer nC=size(extraPropertiesNames, 1) "# of precursor groups";
  constant Real C_nominal[nC]=fill(1e14, nC) "Default for the nominal values for the extra properties";

  // Data
  parameter TRANSFORM.Units.InverseTime[nC] lambdas "Decay constants for each precursor group";
  parameter TRANSFORM.Units.NonDim[nC] alphas "Normalized precursor fractions [betas = alphas*Beta]";
  parameter TRANSFORM.Units.NonDim Beta "Effective delayed neutron fraction";

  constant Real[nC,nC] parents = fill(0,nC,nC) "Matrix of parent sources (sum(column) = 0 or 1) for each fission product 'daughter'. Row is daughter, Column is parent.";

  parameter SI.Energy[nC] w_decay = fill(0,nC) "Energy release (near field - beta) per fission product decay per type";
  parameter SI.Energy[nC] wG_decay = fill(0,nC) "Energy release (far field - gamma) per fission product decay per type";

  annotation (defaultComponentName="data",Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialPrecursorGroup;
