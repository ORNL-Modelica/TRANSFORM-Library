within TRANSFORM.Nuclear.ReactorKinetics.Examples;
model PointKinetics_Drift_Test_feedback
  extends
    TRANSFORM.Nuclear.ReactorKinetics.Examples.PointKinetics_Drift_Test_flat(
      kinetics(specifyPower=false));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=1000, __Dymola_NumberOfIntervals=1000));
end PointKinetics_Drift_Test_feedback;
