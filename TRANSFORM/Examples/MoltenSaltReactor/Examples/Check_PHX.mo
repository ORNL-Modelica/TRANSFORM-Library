within TRANSFORM.Examples.MoltenSaltReactor.Examples;
model Check_PHX

package Material = TRANSFORM.Media.Solids.AlloyN;

SI.SpecificHeatCapacity cp = Material.specificHeatCapacityCp_T(sum(uAdT_lm.Ts_h)/2);

  HeatExchangers.UAdT_lm uAdT_lm(Ts_h={data.T_inlet_tube,data.T_outlet_tube},
      Ts_c={data.T_inlet_shell,data.T_outlet_shell},
    Q_flow=data.m_flow_tube*cp*(uAdT_lm.Ts_h[1] - uAdT_lm.Ts_h[2]),
    U_input=
        TRANSFORM.Units.Conversions.Functions.CoefficientOfHeatTransfer_W_m2K.from_btuhrft2f(
        700),
    calcType="U",
    surfaceArea_input=TRANSFORM.Units.Conversions.Functions.Area_m2.from_feet2(
        4024))
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Data.data_PHX data
    annotation (Placement(transformation(extent={{-100,-2},{-80,18}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Check_PHX;
