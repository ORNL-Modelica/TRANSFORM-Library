within TRANSFORM.Fluid.Machines;
model Turbine_SinglePhase
  extends BaseClasses.PartialTurbine(eta_is=1.0,eta_mech=1.0);
extends TRANSFORM.Icons.UnderConstruction;
Real p_ratio "port_b.p/port_a.p pressure ratio";

equation
  p_ratio = port_b.p/port_a.p;
  p_ratio = 1;

  annotation (defaultComponentName="turbine",Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Turbine_SinglePhase;
