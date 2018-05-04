within TRANSFORM.Nuclear.ReactorKinetics.Data.FissionProducts;
record fissionProducts_0 "Choose to define no fission products"

  extends PartialFissionProduct(
    extraPropertiesNames=fill("", 0),
    fissionSourceNames=fill("", 0),
    fissionTypes=fill("", 0),
    C_nominal=fill(1e14, nC),
    fissionYields=fill(
        0,
        nC,
        nFS,
        nT),
    lambdas=fill(1, nC),
    w_near_decay=fill(0, nC),
    w_far_decay=fill(0, nC),
    sigmaA_thermal=fill(0, nC),
    parents=fill(
        0,
        nC,
        nC));


  annotation (defaultComponentName="data",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info=""));
end fissionProducts_0;
