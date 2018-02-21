within TRANSFORM.Nuclear.ReactorKinetics.Examples;
model PointKinetics_Drift_Test_sine
  extends
    TRANSFORM.Nuclear.ReactorKinetics.Examples.PointKinetics_Drift_Test_flat(
      core_kinetics(Qs_input=core_kinetics.Q_nominal/6.5*sin(Modelica.Constants.pi
          /H*core.summary.xpos)));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=100000000, __Dymola_NumberOfIntervals=10000));
end PointKinetics_Drift_Test_sine;
