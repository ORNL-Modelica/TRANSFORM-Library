within TRANSFORM.HeatAndMassTransfer.Examples;
model ThermalProperties
  extends Icons.Example;
  constant SI.Temperature T=Units.Conversions.Functions.Temperature_K.from_degC(
      20) "Temperature";
  constant SI.Pressure p=Units.Conversions.Functions.Pressure_Pa.from_atm(1.0)
    "Pressure";
  package Medium_w = Modelica.Media.Water.StandardWater "Water model";
  package Medium_a = Modelica.Media.Air.DryAirNasa "Dry air model";
  Medium_w.ThermodynamicState state_w = Medium_w.setState_pT(p,T) "Set the state of the medium";
  Medium_a.ThermodynamicState state_a = Medium_a.setState_pT(p,T) "Set the state of the medium";
  .TRANSFORM.Media.BaseProperties1Phase Water(redeclare package Medium =
        Medium_w, state=state_w)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  .TRANSFORM.Media.BaseProperties1Phase Air(redeclare package Medium = Medium_a,
      state=state_a)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ThermalProperties;
