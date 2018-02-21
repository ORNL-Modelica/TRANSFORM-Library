within TRANSFORM.Nuclear.ReactorKinetics.Examples;
model PointKinetics_Drift_Test_feedback_Xenon
  extends TRANSFORM.Nuclear.ReactorKinetics.Examples.PointKinetics_Drift_Test_feedback(
      core_kinetics(
      rhos_input=fill(Reactivity.y/core.nV, core.nV),
      Q_nominal=0,
      Ns_external=fill(1, core.nV),
      fissionYield=data_traceSubstances.fissionProducts.fissionYield[:, :, 1]),
      core(T_b_start=573.15));

  Modelica.Blocks.Sources.Pulse Reactivity(
    nperiod=1,
    startTime=6*60*60,
    amplitude=1,
    offset=-1,
    width=90,
    period=100*60*60/0.9)
    annotation (Placement(transformation(extent={{-30,50},{-10,70}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=741600, __Dymola_NumberOfIntervals=74160));
end PointKinetics_Drift_Test_feedback_Xenon;
