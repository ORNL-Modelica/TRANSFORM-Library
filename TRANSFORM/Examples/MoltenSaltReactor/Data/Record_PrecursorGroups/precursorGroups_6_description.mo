within TRANSFORM.Examples.MoltenSaltReactor.Data.Record_PrecursorGroups;
model precursorGroups_6_description
  "6 precursor groups for description"

  extends PartialPrecursorGroup;

  constant String[:] extraPropertiesNames={"PreGroup_1","PreGroup_2","PreGroup_3","PreGroup_4","PreGroup_5","PreGroup_6"}
    "Names of precursor groups";

  final constant Integer nC=size(extraPropertiesNames, 1) "# of precursor groups";
  constant Real C_nominal[nC]=fill(1e14, nC)
    "Default for the nominal values for the extra properties";

  // Data
  parameter TRANSFORM.Units.InverseTime[nC] lambdas={0.0125,0.0318,0.109,0.317,1.35,8.64} "Decay constants for each precursor group";

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info=""));
end precursorGroups_6_description;
