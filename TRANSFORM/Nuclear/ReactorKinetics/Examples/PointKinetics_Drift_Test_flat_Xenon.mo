within TRANSFORM.Nuclear.ReactorKinetics.Examples;
model PointKinetics_Drift_Test_flat_Xenon
  extends
    TRANSFORM.Nuclear.ReactorKinetics.Examples.PointKinetics_Drift_Test_flat(
      core_kinetics(Qs_input=fill(Power.y/core.nV, core.nV)));

  Modelica.Blocks.Sources.Pulse Power(
    amplitude=core_kinetics.Q_nominal,
    nperiod=1,
    startTime=6*60*60,
    width=100*60*60,
    period=100*60*60 + 1)
    annotation (Placement(transformation(extent={{-30,50},{-10,70}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=741600, __Dymola_NumberOfIntervals=74160));
end PointKinetics_Drift_Test_flat_Xenon;
