within TRANSFORM.Fluid.ClosureRelations.MassTransfer.Models.Lumped.PhaseInterface;
model Interface_GasKineticTheory

  extends PhaseInterface.PartialPhaseInterface;

  parameter Real f = 1.0 "Fraction of vapor molecules striking the liquid surface that enter the liquid phase";

equation

  m_flow = f*surfaceArea*(Medium.fluidConstants[1].molarMass/(2*pi*Modelica.Constants.R*state_vapor.T))^(0.5)*(state_vapor.p - Medium.saturationPressure(state_liquid.T));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Interface_GasKineticTheory;
