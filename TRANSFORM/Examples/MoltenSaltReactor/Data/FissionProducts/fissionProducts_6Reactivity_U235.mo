within TRANSFORM.Examples.MoltenSaltReactor.Data.FissionProducts;
record fissionProducts_6Reactivity_U235
  "List of 6 primary reactivity contributors of U-235 fuel"

  extends PartialFissionProduct(
    extraPropertiesNames={"Te135","I135","Xe135","Nd149","Pm149","Sm149"},
    fissionSourceNames={"U235"},
    fissionTypes={"thermal"},
    C_nominal=fill(1e14, nC),
    fissionYield={fissionYield_t[i,j] for k in 1:nT, j in 1:nFS, i in 1:nC},
    lambdas={log(2)/19,log(2)/23760,log(2)/32760,log(2)/6120,log(2)/190800,0},
    w_decay = 1.6022e-16*{1,1,1,1,1,1},
    wG_decay = 1.6022e-16*{1,1,1,1,1,1},
    sigmaA_thermal = 1e-28*{0,0,2.6e6,0,0,40e3},
    parents=[[0,0,0,0,0,0];
             [1,0,0,0,0,0];
             [0,1,0,0,0,0];
             [0,0,0,0,0,0];
             [0,0,0,1,0,0];
             [0,0,0,0,1,0]]);

  parameter Real[nC,nFS] fissionYield_t=transpose({
    {0.061,0,0.003,0.0113,0,0}})
      "Fission yield per thermal fission";

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info=""));
end fissionProducts_6Reactivity_U235;
