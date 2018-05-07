within TRANSFORM.Nuclear.ReactorKinetics.Data.Tritium;
record tritium_0 "Choose to define no fission products"

  extends PartialTritium(
    extraPropertiesNames=fill("", 0),
    C_nominal=fill(1e14, nC),
    lambdas=fill(1, nC),
    sigmasA=fill(0, nC),
    sigmasT=fill(0, nC),
    parents=fill(
        0,
        nC,
        nC));

  annotation (defaultComponentName="data",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info=""));
end tritium_0;
