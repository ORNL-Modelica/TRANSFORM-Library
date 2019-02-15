within TRANSFORM.Fluid.Volumes.ClosureModels.MassTransfer.PhaseInterface;
model GasKineticTheory
  extends
    TRANSFORM.Fluid.Volumes.ClosureModels.MassTransfer.PhaseInterface.PartialPhase_m_flow;
  parameter Real f = 1.0 "Fraction of vapor molecules striking the liquid surface that enter the liquid phase";
equation
  m_flow = f*surfaceArea*(Medium.fluidConstants[1].molarMass/(2*pi*Modelica.Constants.R*state_vapor.T))^(0.5)*(state_vapor.p - Medium.saturationPressure(state_liquid.T));
end GasKineticTheory;
