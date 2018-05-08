within TRANSFORM.Nuclear.ReactorKinetics.Data.PrecursorGroups;
record precursorGroups_6_FLiBeFueledSalt

  extends PartialPrecursorGroup(
  extraPropertiesNames=TRANSFORM.Utilities.Strings.fillNumString(6,"PreGroup"),
  C_nominal=fill(1e14, nC),
  lambdas={0.0125,0.0318,0.109,0.317,1.35,8.64},
  alphas={0.0320,0.1664,0.1613,0.4596,0.1335,0.0472},
  Beta=0.0065);

  annotation (defaultComponentName="data",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info=""));
end precursorGroups_6_FLiBeFueledSalt;
