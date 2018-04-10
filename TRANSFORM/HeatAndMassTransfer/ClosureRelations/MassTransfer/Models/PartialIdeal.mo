within TRANSFORM.HeatAndMassTransfer.ClosureRelations.MassTransfer.Models;
partial model PartialIdeal "Base model"

extends PartialMassTransfer(
     final flagIdeal=1);

  TRANSFORM.Media.BaseProperties1Phase[nMT] mediums(redeclare package
      Medium =
        Medium, state=states) "Bulk fluid properties"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

equation

  for i in 1:nMT loop
    m_flows[i] = vs[i]*mediums[i].d*crossAreas[i];
    Res[i] = mediums[i].d*dimensions[i]*abs(vs[i])/mediums[i].mu;
    Scs[i, :] =mediums[i].mu ./ (mediums[i].d .* Ds_ab[i, :]);
  end for;

  annotation (
    defaultComponentName="heatTransfer",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end PartialIdeal;
