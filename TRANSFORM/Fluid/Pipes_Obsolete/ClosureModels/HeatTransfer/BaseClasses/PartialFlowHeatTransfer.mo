within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.BaseClasses;
partial model PartialFlowHeatTransfer
  "base class for any pipe heat transfer correlation"
  extends
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.BaseClasses.PartialHeatTransfer;
  // Additional inputs provided to flow heat transfer model
  input SI.MassFlowRate[nHT] m_flows "Mean flow rate in segments";
  // Geometry parameters and inputs for flow heat transfer
  parameter Real nParallel "number of identical parallel flow devices"
     annotation(Dialog(tab="Internal Interface",enable=false,group="Geometry"));
  input SI.Length[nHT] lengths "Lengths along flow path";
  input SI.Length[nHT] dimensions
    "Characteristic dimensions for fluid flow (diameter for pipe flow)";
  input SI.Area[nHT] crossAreas "Cross flow area of flow segments";
  input SI.Area[nHT] surfaceAreas "Heat transfer areas";
  input SI.Height[nHT] roughnesses "Average heights of surface asperities";
  parameter SI.CoefficientOfHeatTransfer[nHT] alphas_start "heat transfer coefficient" annotation(Dialog(tab="Initialization"));
  SI.CoefficientOfHeatTransfer[nHT] alphas(start=alphas_start) "Coefficient of heat transfer";
  annotation (Documentation(info="<html>
Base class for heat transfer models of flow devices.
<p>
The geometry is specified in the interface with the <code>surfaceAreas[nHT]</code>, the <code>roughnesses[nHT]</code>
and the lengths[nHT] along the flow path.
Moreover the fluid flow is characterized for different types of devices by the characteristic <code>dimensions[nHT+1]</code>
and the average velocities <code>vs[nHT+1]</code> of fluid flow.
See <a href=\"modelica://Modelica.Fluid.Pipes.BaseClasses.CharacteristicNumbers.ReynoldsNumber\">Pipes.BaseClasses.CharacteristicNumbers.ReynoldsNumber</a>
for example definitions.
</p>
</html>"),
      Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},
              {100,100}}), graphics={Rectangle(
            extent={{-80,60},{80,-60}},
            pattern=LinePattern.None,
            lineColor={0,0,0},
            fillColor={255,0,0},
            fillPattern=FillPattern.HorizontalCylinder), Text(
            extent={{-40,22},{38,-18}},
            lineColor={0,0,0},
            textString="%name")}));
end PartialFlowHeatTransfer;
