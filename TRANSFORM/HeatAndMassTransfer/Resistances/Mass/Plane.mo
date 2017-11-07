within TRANSFORM.HeatAndMassTransfer.Resistances.Mass;
model Plane "Plane Wall"

  extends
    TRANSFORM.HeatAndMassTransfer.Resistances.Mass.BaseClasses.PartialResistance;

  input SI.Length L "Wall thickness parallel to flow"
    annotation (Dialog(group="Input Variables"));
  input SI.Area crossArea "Cross-sectional area perpindicular to flow"
    annotation (Dialog(group="Input Variables"));
  input SI.DiffusionCoefficient D_ab[nC] "Diffusion coefficient"
    annotation (Dialog(group="Input Variables"));

equation

  R = L./(D_ab*crossArea);

  annotation (
    defaultComponentName="plane",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={Bitmap(extent={{
              -40,-100},{40,-30}}, fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/Plane.jpg")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end Plane;
