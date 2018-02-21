within TRANSFORM.Examples.MoltenSaltReactor.Data.FissionProducts;
record fissionProducts_test "test for debugging"

  extends PartialFissionProduct(
    extraPropertiesNames={"v1","v2","v3"},
    fissionSourceNames={"s1","s2"},
    fissionTypes={"thermal","fast"},
    C_nominal=fill(1e14, nC),
    fissionYield={if k == 1 then fissionYield_t[i,j] else fissionYield_f[i,j] for k in 1:2, j in 1:nFS, i in 1:nC},
    lambdas={0,0.00001,0.01},
    w_decay=1.6022e-16*{5.682,335,305},
    wG_decay=1.6022e-16*{18.591,2628,1165},
    sigmaA_thermal = 1e-28*{0,0,2650000},
    sigmaA_fast = 1e-28*{0,0,7600},
    parents=[[0,0,0];[0.5,0,0];[0.5,1,0]]);

  parameter Real[nC,nFS] fissionYield_t=0.01*transpose({{0,0.01,1},
        {0.004,0.001,0.02}}) "Fission yield per fast fission";

  parameter Real[nC,nFS] fissionYield_f=0.01*transpose({{0.00269,0.00082,0.0108},{0.00346,0.00106,0.0142}}) "Fission yield per fast fission";

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info=""));
end fissionProducts_test;
