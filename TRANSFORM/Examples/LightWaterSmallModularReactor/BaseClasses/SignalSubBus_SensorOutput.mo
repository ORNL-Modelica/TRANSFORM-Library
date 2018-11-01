within TRANSFORM.Examples.LightWaterSmallModularReactor.BaseClasses;
expandable connector SignalSubBus_SensorOutput

  extends TRANSFORM.Examples.Interfaces.SignalSubBus_SensorOutput;

  SI.Power Q_total "Total thermal Output of Reactor";
  SI.Temperature T_Core_Inlet "Core inlet temperature";
  SI.Temperature T_Core_Outlet "Core outlet temperature";
  SI.Pressure p_pressurizer "Pressurizer pressure";

  annotation (defaultComponentName="sensorBus",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SignalSubBus_SensorOutput;
