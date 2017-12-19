within TRANSFORM.Media.Fluids.Sodium;
package LinearSodium_pTold "Sodium with linear compressibility"

// references are based on 800K
  extends TRANSFORM.Media.Interfaces.Fluids.PartialLinearFluid(
    mediumName="Linear Sodium",
    constantJacobian=false,
    reference_p=1e5,
    reference_T=800,
    reference_d=828,
    reference_h=769e3,
    reference_s=0,
    beta_const=2.82e-4,
    kappa_const=2.89e-10,
    cp_const=1251,
    MM_const=0.02298976928,
    T_default = 800);

redeclare function extends dynamicViscosity "Dynamic viscosity"

algorithm
  eta := -3.0655e-7*state.T+5.2303e-4;
end dynamicViscosity;

redeclare function extends thermalConductivity
    "Thermal conductivity"
algorithm
  lambda := -0.043096*state.T + 99.3504;
end thermalConductivity;
end LinearSodium_pTold;
