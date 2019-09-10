within TRANSFORM.Examples.LightWaterSmallModularReactor.Data;
record IRIS_PHS
  extends BaseClasses.Record_Data;
  parameter SI.Power Q_totalTh=1000e6 "core thermal output";
  parameter SI.MassFlowRate core_m_flow=4712 "nominal core mass flow rate";
  parameter SI.Temperature core_T_inlet=556 "core inlet temperature";
  parameter SI.Temperature core_T_outlet=594 "core outlet temperature";
  parameter SI.Temperature core_T_avg=0.5*(core_T_inlet + core_T_outlet)
    "core average temperature";
  parameter SI.TemperatureDifference core_dT=core_T_outlet - core_T_inlet
    "core temperature rise";
  parameter SI.Pressure pressurizer_p=1.55e7 "nominal operating pressure";
  parameter SI.Height pressurizer_level=1.68 "nominal pressurizer level";
  parameter Units.NonDim pressurizer_Vfrac_liquid=0.34
    "nominal fraction of liquid in pressurizer";
  annotation (
    defaultComponentName="data",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          lineColor={0,0,0},
          extent={{-100,-90},{100,-70}},
          textString="IRIS")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
</html>"));
end IRIS_PHS;
