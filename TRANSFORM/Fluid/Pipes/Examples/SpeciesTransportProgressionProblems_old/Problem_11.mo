within TRANSFORM.Fluid.Pipes.Examples.SpeciesTransportProgressionProblems_old;
model Problem_11 "Uranium Isotopes Drift w/ Decay"
  extends TRANSFORM.Icons.Example;
  extends TRANSFORM.Icons.UnderConstruction;

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=20,
      __Dymola_NumberOfIntervals=400,
      __Dymola_Algorithm="Dassl"));
end Problem_11;
