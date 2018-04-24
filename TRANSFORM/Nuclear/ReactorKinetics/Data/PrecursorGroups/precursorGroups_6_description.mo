within TRANSFORM.Nuclear.ReactorKinetics.Data.PrecursorGroups;
record precursorGroups_6_description
  "6 precursor groups for description"

  extends PartialPrecursorGroup(
  extraPropertiesNames={"PreGroup_1","PreGroup_2","PreGroup_3","PreGroup_4","PreGroup_5","PreGroup_6"},
  C_nominal=fill(1e14, nC),
  lambdas={0.0125,0.0318,0.109,0.317,1.35,8.64});

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info=""));
end precursorGroups_6_description;
