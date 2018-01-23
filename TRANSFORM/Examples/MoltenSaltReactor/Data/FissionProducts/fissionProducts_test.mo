within TRANSFORM.Examples.MoltenSaltReactor.Data.FissionProducts;
record fissionProducts_test "test for debugging"

  extends PartialFissionProduct(
    extraPropertiesNames={"v1","v2","v3"},
    fissionSourceNames={"s1","s2"},
    C_nominal=fill(1e14, nC),
    fisYield_t=0.01*transpose({{0,0.01,1},
        {0.004,0.001,0.02}}),
    fisYield_f=0.01*transpose({{0.00269,0.00082,0.0108},{0.00346,0.00106,0.0142}}),
    lambdas={0,0.00001,0.01});

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info=""));
end fissionProducts_test;
