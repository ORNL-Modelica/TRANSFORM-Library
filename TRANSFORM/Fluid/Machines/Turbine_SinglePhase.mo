within TRANSFORM.Fluid.Machines;
model Turbine_SinglePhase
  extends BaseClasses.PartialTurbine(eta_is=1.0,eta_mech=1.0);
equation
  p_ratio = 1;

  annotation (defaultComponentName="turbine",Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Turbine_SinglePhase;
