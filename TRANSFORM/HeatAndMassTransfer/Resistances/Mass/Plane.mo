within TRANSFORM.HeatAndMassTransfer.Resistances.Mass;
model Plane "Plane wall diffusion resistance model"
  extends TRANSFORM.HeatAndMassTransfer.Resistances.Mass.BaseClasses.PartialResistance;
  input SI.Length L "Wall thickness parallel to flow"
    annotation (Dialog(group="Inputs"));
  input SI.Area crossArea "Cross-sectional area perpendicular to flow"
    annotation (Dialog(group="Inputs"));
  input SI.DiffusionCoefficient D_ab[nC] "Diffusion coefficient"
    annotation (Dialog(group="Inputs"));
equation
  R = L./(D_ab*crossArea);
  annotation (
    defaultComponentName="plane",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={Bitmap(extent={{
              -40,-100},{40,-30}}, fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/Plane.jpg")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Diffusion resistance across a plane wall.</p>
</html>"));
end Plane;
