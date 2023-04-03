within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Models.TwoPhase;
partial model PartialTwoPhase
  extends TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Models.PartialHeatTransfer_setQ_flows(
      redeclare replaceable package Medium =
        Modelica.Media.Water.StandardWater
      constrainedby Modelica.Media.Interfaces.PartialTwoPhaseMedium);
  Media.BaseProperties2Phase[nHT] mediums2(
    redeclare package Medium = Medium,
    state = states) "Bulk fluid properties"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
  Media.BaseProperties2Phase[nHT] mediums2_film(
    redeclare package Medium = Medium,
    state = states_film) "Film fluid properties"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Bitmap(extent={{-124,-100},{124,100}}, fileName="modelica://TRANSFORM/Resources/Images/Icons/HeatTransfer_alphas.jpg")}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialTwoPhase;
