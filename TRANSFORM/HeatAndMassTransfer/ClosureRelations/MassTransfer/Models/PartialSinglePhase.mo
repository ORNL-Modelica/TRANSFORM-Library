within TRANSFORM.HeatAndMassTransfer.ClosureRelations.MassTransfer.Models;
partial model PartialSinglePhase "Base model"

extends PartialMassTransfer(
     final flagIdeal=0);

  TRANSFORM.Media.BaseProperties1Phase[nMT] mediaProps(redeclare package Medium =
        Medium, state=states) "Bulk fluid properties"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

equation

  for i in 1:nMT loop
    m_flows[i] =vs[i]*mediaProps[i].d*crossAreas[i];
    Res[i] =mediaProps[i].d*dimensions[i]*abs(vs[i])/mediaProps[i].mu;
    Scs[i, :] =mediaProps[i].mu ./ (mediaProps[i].d .* Ds_ab[i, :]);
  end for;

  annotation (
    defaultComponentName="heatTransfer",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end PartialSinglePhase;
