within TRANSFORM.Nuclear.ReactorKinetics.Data.DecayHeat;
partial record PartialDecayHeat_powerBased

  extends TRANSFORM.Icons.Record;

  constant String[:] extraPropertiesNames= fill("",0) "Names of decay-heat groups";

  final constant Integer nC=size(extraPropertiesNames, 1) "# of decay-heat groups";
  constant Real C_nominal[nC]=fill(1e14, nC) "Default for the nominal values for the extra properties";

  // Data
  parameter TRANSFORM.Units.InverseTime[nC] lambdas "Decay constants for each decay-heat group";
  parameter Units.NonDim efs[nC]
    "Decay-heat group fractions of fission power";

  annotation (defaultComponentName="data",Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialDecayHeat_powerBased;
