within TRANSFORM.Fluid.Volumes.BaseClasses.BaseDrum.PhaseInterface;
partial model PartialPhase_alpha
  "heat transfer coefficient at the phase interface"

  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium in the component"
    annotation(Dialog(tab="Internal Interface",enable=false));

  // Inputs provided model
  input Medium.ThermodynamicState state_liquid "Liquid thermodynamic state";
  input Medium.ThermodynamicState state_vapor "Vapor thermodynamic state";

  SI.CoefficientOfHeatTransfer alpha
    "Heat transfer coefficient at vapor-liquid surface";
end PartialPhase_alpha;
