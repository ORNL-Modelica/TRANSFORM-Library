within TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components.Records;
record BoilerNominalValues
  extends TRANSFORM.Icons.Record;

  // Pressure
  parameter Modelica.SIunits.Pressure p_nom_boiler=NominalData.steamPressure_Pa
    "Nominal boiler pressure" annotation(Evaluate=true,Dialog(group="Pressure"));
  parameter Modelica.SIunits.PressureDifference dp_nom_riser=1e5
    "Nominal frictional pressure drop riser tubes" annotation(Evaluate=true,Dialog(group="Pressure drop"));
  parameter Modelica.SIunits.PressureDifference dp_nom_feedWaterValve=1e5
    "Nominal pressure feed water valve" annotation(Evaluate=true,Dialog(group="Pressure drop"));

  // Mass-flow
  parameter Modelica.SIunits.MassFlowRate m_flow_nom_feedWater=
      NominalData.steamRate_kg_per_s
    "Nominal feed water mass flow rate" annotation(Dialog(group="Flow"));
  parameter Modelica.SIunits.MassFlowRate m_flow_nom_circulation=m_flow_nom_feedWater*1.1
    "Nominal boiler circulation flow rate" annotation(Evaluate=true,Dialog(group="Flow"));
  parameter Modelica.SIunits.MassFlowRate m_flow_nom_sodium=NominalData.sodiumRate_kg_per_s
    "Nominal boiler sodium flow rate" annotation(Evaluate=true,Dialog(group="Flow"));

  // Temperature
  parameter Modelica.SIunits.Temperature T_nom_feedWater=NominalData.feedWaterTemperature_K
    "Nominal feed water temperature" annotation(Dialog(group="Flow"));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<!--copyright-->
</html>"));
end BoilerNominalValues;
