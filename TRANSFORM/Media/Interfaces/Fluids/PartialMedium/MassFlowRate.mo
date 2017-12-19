within TRANSFORM.Media.Interfaces.Fluids.PartialMedium;
type MassFlowRate = SI.MassFlowRate (
    quantity="MassFlowRate." + mediumName,
    min=-1.0e5,
    max=1.e5) "Type for mass flow rate with medium specific attributes";
