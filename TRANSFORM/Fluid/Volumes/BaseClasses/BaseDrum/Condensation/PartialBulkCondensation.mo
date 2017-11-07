within TRANSFORM.Fluid.Volumes.BaseClasses.BaseDrum.Condensation;
partial model PartialBulkCondensation
  input SI.QualityFactor x(min=0.0, max=1.0) "Quality of vapor";
  input SI.Mass m "Mass of vapor";

  SI.MassFlowRate m_flow "Mass flow rate of liquid droplets";
end PartialBulkCondensation;
