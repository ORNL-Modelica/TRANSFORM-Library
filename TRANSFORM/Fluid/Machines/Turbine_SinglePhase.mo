within TRANSFORM.Fluid.Machines;
model Turbine_SinglePhase
  extends BaseClasses.PartialTurbine(eta_is=1.0,eta_mech=1.0);
extends TRANSFORM.Icons.UnderConstruction;
Real p_ratio "port_b.p/port_a.p pressure ratio";

equation
  p_ratio = port_b.p/port_a.p;
  p_ratio = 1;

  annotation (Documentation(info="<html>
<p><b>Under construction.</b> This class is still being developed: any release may change, move or remove it without a deprecation period.</p>
</html>"), defaultComponentName="turbine",Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Turbine_SinglePhase;
