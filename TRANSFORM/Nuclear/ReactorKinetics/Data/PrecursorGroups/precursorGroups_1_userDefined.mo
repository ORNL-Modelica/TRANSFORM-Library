within TRANSFORM.Nuclear.ReactorKinetics.Data.PrecursorGroups;
record precursorGroups_1_userDefined "User defined 1-group | nC = 1"
  extends PartialPrecursorGroup(
  extraPropertiesNames=TRANSFORM.Utilities.Strings.fillNumString(1,"PreGroup"));
  annotation (defaultComponentName="data",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info=""));
end precursorGroups_1_userDefined;
