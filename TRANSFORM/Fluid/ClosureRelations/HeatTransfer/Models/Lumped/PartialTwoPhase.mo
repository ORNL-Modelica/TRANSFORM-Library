within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.Lumped;
partial model PartialTwoPhase

  extends PartialHeatTransfer_setQ_flows(
       replaceable package Medium =
         Modelica.Media.Water.StandardWater
       constrainedby Modelica.Media.Interfaces.PartialTwoPhaseMedium);

  TRANSFORM.Media.BaseProperties2Phase mediaProps(redeclare package Medium =
        Medium, state=state) "Bulk fluid properties"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

//   TRANSFORM.Media.BaseProperties2Phase medium_film(redeclare package Medium =
//         Medium, state=state_film) "Film fluid properties"
//     annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));

equation
  m_flow =v .* mediaProps.d .* crossArea;
  //v_film =v .* mediaProps.d ./ medium_film.d;
  Re =mediaProps.d .* dimension .* abs(v) ./ mediaProps.mu;
  //Re_film =medium_film.d .* dimension .* abs(v_film) ./ medium_film.mu;
  Pr = Medium.prandtlNumber(state);
  //Pr_film = Medium.prandtlNumber(state_film);

  annotation (defaultComponentName="heatTransfer",Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialTwoPhase;
