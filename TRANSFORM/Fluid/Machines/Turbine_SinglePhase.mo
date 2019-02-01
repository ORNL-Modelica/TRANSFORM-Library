within TRANSFORM.Fluid.Machines;
model Turbine_SinglePhase
  extends BaseClasses.PartialTurbine;

  parameter Real eta1 = 1;
  parameter Real eta2 = 1;

equation

  eta_is = eta1;
  eta_mech = eta2;
  U = 1*1000*1e5;

  annotation (defaultComponentName="turbine",Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Turbine_SinglePhase;
