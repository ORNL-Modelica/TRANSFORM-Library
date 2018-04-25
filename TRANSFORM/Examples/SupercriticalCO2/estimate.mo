within TRANSFORM.Examples.SupercriticalCO2;
model estimate


  package Medium = ExternalMedia.Examples.CO2CoolProp(p_default=8e6);  //Requires VS2012 compiler option

  package Medium_salt = TRANSFORM.Media.Fluids.KClMgCl2.LinearKClMgCl2_67_33_pT;

  parameter SI.Power Q_nominal=data.Q_nominal;

  Medium.ThermodynamicState state_co2_in = Medium.setState_pT(data.p_nominal_PCL,data.T_in_pcx);
  Medium.ThermodynamicState state_co2_out = Medium.setState_pT(data.p_nominal_PCL,data.T_out_pcx);

  Medium_salt.ThermodynamicState state_salt_in = Medium_salt.setState_pT(1e5,data.T_hot_salt);

  SI.SpecificHeatCapacity cp_co2_in = Medium.specificHeatCapacityCp(state_co2_in);
  SI.SpecificHeatCapacity cp_co2_out = Medium.specificHeatCapacityCp(state_co2_out);

  SI.SpecificHeatCapacity cp_salt = Medium_salt.specificHeatCapacityCp(state_salt_in);

  SI.MassFlowRate m_flow_co2 = Q_nominal/(0.5*(cp_co2_in+cp_co2_out)*(data.T_out_pcx-data.T_in_pcx));
  SI.MassFlowRate m_flow_salt = Q_nominal/(cp_salt*(data.T_hot_salt-data.T_cold_salt));

  Real nT = uAdT_lm.surfaceArea/(Modelica.Constants.pi*data.r_pcx+2*data.r_pcx)*data.length_pcx;

  HeatExchangers.UAdT_lm uAdT_lm(
    calcType="surfaceArea",
    Q_flow=300e3,
    Ts_h={data.T_hot_salt,data.T_cold_salt},
    Ts_c={data.T_in_pcx,data.T_out_pcx},
    U_input=5000)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Data.Data_Basic data
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end estimate;
