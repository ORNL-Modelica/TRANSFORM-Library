within TRANSFORM.Nuclear.Data.FissionProducts;
record fissionProducts_TeIXe_U235
  "List of Te-135, I-135 and Xe-135 for U-235 fuel"

  // Values taken from Chapter 6 of W. M. STACEY, Nuclear Reactor Physics, Wiley-VCH Verlag GmbH & Co. KGaA, Weinheim, Germany (2007); https://doi.org/10.1002/9783527611041.
  // Decay values taken from most likely value from chart of the nuclides 17E

  extends PartialFissionProduct(
    extraPropertiesNames={"Te135","I135","Xe135"},
    fissionSourceNames={"U235"},
    fissionTypes={"thermal"},
    C_nominal=fill(1e14, nC),
    fissionYield={fissionYield_t[i,j] for k in 1:nT, j in 1:nFS, i in 1:nC},
    lambdas={log(2)/19,log(2)/23760,log(2)/32760},
    w_decay = 1.6022e-16*{6000,1300,910},
    wG_decay = 1.6022e-16*{603.5,1260.4,249.8},
    sigmaA_thermal = 1e-28*{0,0,2.6e6},
    parents=[[0,0,0];
             [1,0,0];
             [0,1,0]]);

  parameter Real[nC,nFS] fissionYield_t=transpose({
    {0.061,0,0.003}})
      "Fission yield per thermal fission";

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info=""));
end fissionProducts_TeIXe_U235;
