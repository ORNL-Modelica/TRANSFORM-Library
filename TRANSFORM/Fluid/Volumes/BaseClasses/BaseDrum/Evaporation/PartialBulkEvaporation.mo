within TRANSFORM.Fluid.Volumes.BaseClasses.BaseDrum.Evaporation;
partial model PartialBulkEvaporation
  input SI.QualityFactor x(min=0.0, max=1.0) "Vapor quality in liquid";
  input SI.Mass m "Mass of liquid";

  SI.MassFlowRate m_flow "Mass flow rate of vapor bubbles";
end PartialBulkEvaporation;
