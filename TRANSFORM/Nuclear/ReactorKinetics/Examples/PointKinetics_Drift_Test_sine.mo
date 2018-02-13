within TRANSFORM.Nuclear.ReactorKinetics.Examples;
model PointKinetics_Drift_Test_sine
  extends TRANSFORM.Nuclear.ReactorKinetics.Examples.PointKinetics_Drift_Test_flat(kinetics(
                                                                                   Qs_input= kinetics.Q_nominal/6.5*sin(Modelica.Constants.pi/H*pipe.summary.xpos)));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=1000, __Dymola_NumberOfIntervals=1000));
end PointKinetics_Drift_Test_sine;
