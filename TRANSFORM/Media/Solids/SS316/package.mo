within TRANSFORM.Media.Solids;
package SS316 "SS316: Stainless steel 316"
  // Fits are taken from aksteel.com for 316 steel.
  extends TRANSFORM.Media.Interfaces.Solids.PartialSimpleAlloy(
    mediumName="SS316",
    T_min=Modelica.Units.Conversions.from_degC(0),
    T_max=Modelica.Units.Conversions.from_degC(1500));

  redeclare function extends specificEnthalpy
    "Specific enthalpy"
  algorithm
    h := h_reference + 500*(state.T - T_reference);
  end specificEnthalpy;

  redeclare function extends density
    "Density"
  algorithm
    d := 7990;
  end density;

  redeclare function extends thermalConductivity
    "Thermal conductivity"
  algorithm
    // max(state.T, 0): this straight-line fit reaches zero at -873 K. The wall conduction models
    // average the conductivity of two points, so at such temperatures a steady state has a
    // second, false solution with zero average conductivity (a wall at -2043 K next to 297 K
    // water). OpenModelica 1.27.1 converged to it while searching for the start of
    // Fluid.Pipes.Examples.GenericPipe_Tests.nParallel_withWall_*. Holding T at no less than
    // 0 K removes that solution and changes no value at any real temperature. Every other solid
    // polynomial, table or spline fit that reaches zero or a pole below 0 K has the same guard
    // (UN and UO2 are power laws, undefined below 0 K, and are not guarded); test:
    // TRANSFORMTest.Media.Solids.AlloyConductivity_FloorAt0K.
    lambda := 11.34905 + 0.013*max(state.T, 0);
  end thermalConductivity;

  redeclare function extends specificHeatCapacityCp
    "Specific heat capacity"
  algorithm
    cp := 500;
  end specificHeatCapacityCp;
end SS316;
