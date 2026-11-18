within TRANSFORM.HeatAndMassTransfer.Resistances.Heat;
model Fin "Fin convection resistance model"
  extends TRANSFORM.HeatAndMassTransfer.Resistances.Heat.BaseClasses.PartialResistance;
  input SI.Efficiency eta "Fin efficiency" annotation(Dialog(group="Inputs"));
  input SI.Area surfaceArea "Fin surface area" annotation(Dialog(group="Inputs"));
  input SI.CoefficientOfHeatTransfer alpha "Convection heat transfer coefficient" annotation(Dialog(group="Inputs"));
equation
  R = 1/(eta*alpha*surfaceArea);
  annotation (defaultComponentName="convection",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={Bitmap(extent={{
              -40,-100},{40,-30}}, fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/Fin.jpg")}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Heat transfer from a fin to the fluid around it, as a resistance between the fin base and the fluid. The fin efficiency <code>eta</code> comes from a model in <code>FinEfficiency</code>, such as <code>GenericFin</code>, which also computes the matching fin surface area.</p>
</html>"));
end Fin;
