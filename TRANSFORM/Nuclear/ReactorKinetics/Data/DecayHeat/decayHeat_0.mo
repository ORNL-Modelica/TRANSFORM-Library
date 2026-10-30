within TRANSFORM.Nuclear.ReactorKinetics.Data.DecayHeat;
record decayHeat_0 "Choose to define to no decay heat groups"
  extends PartialDecayHeat_powerBased(
    extraPropertiesNames=fill("", 0),
    C_nominal=fill(1e-6, nC),
    lambdas=fill(1,nC),
    efs=fill(0,nC));
  annotation (defaultComponentName="data",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info=""));
end decayHeat_0;
