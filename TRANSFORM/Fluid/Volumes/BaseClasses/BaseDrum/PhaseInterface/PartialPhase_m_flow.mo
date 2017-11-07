within TRANSFORM.Fluid.Volumes.BaseClasses.BaseDrum.PhaseInterface;
partial model PartialPhase_m_flow "mass transport at the phase interface"

  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium in the component"
    annotation(Dialog(tab="Internal Interface",enable=false));

  // Inputs provided model
  input Medium.ThermodynamicState state_liquid "Liquid thermodynamic state";
  input Medium.ThermodynamicState state_vapor "Vapor thermodynamic state";

  Real alphaD(unit="kg/(s.m2.K)") "Coefficient of mass transport";

end PartialPhase_m_flow;
