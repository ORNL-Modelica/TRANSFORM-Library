within TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components.Records;
record BoilerStartValues_Transform
  extends TRANSFORM.Icons.Record;
  extends BoilerStartValues;
  // Pressure
  parameter Modelica.SIunits.Pressure pin_shell
    "Start value for inlet pressure of the steam generator shell" annotation(Evaluate=true,Dialog(group="Pressure"));
  parameter Modelica.SIunits.Pressure pout_shell
    "Start value for outlet pressure of the steam generator shell" annotation(Evaluate=true,Dialog(group="Pressure"));
  // Mass-flow
  parameter Modelica.SIunits.MassFlowRate m_flow_start_sodium
    "Start value intermediate sodium flow rate" annotation(Evaluate=true,Dialog(group="Flow"));
  // Temperature, shell side
  parameter Modelica.SIunits.Temperature Tin_shell
    "Start value for sodium inlet temperature" annotation(Evaluate=true,Dialog(group="Temperature"));
  parameter Modelica.SIunits.Temperature Tout_shell
    "Start value for sodium outlet temperature" annotation(Evaluate=true,Dialog(group="Temperature"));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<!--copyright-->
</html>"));
end BoilerStartValues_Transform;
