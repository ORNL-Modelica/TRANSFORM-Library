within TRANSFORM.Nuclear.ReactorKinetics.Examples.Functions;
model Initial_powerBased_powerHistory

extends TRANSFORM.Icons.Example;

  PointKinetics_L1_powerBased kinetics(
    nC=data.nC,
    lambdas_start=data.lambdas,
    alphas_start=data.alphas,
    Beta_start=data.Beta,
    lambda_dh_start=data_dh.lambdas,
    nDH=data_dh.nC,
    efs_dh_start=data_dh.efs,
    use_history=true,
    history=data_history.table,
    includeDH=true)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Data.PrecursorGroups.precursorGroups_6_TRACEdefault data
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  Blocks.DataTable data_history(table=[0,0; 1e4,1e3; 2e4,1e4; 1e16,1e6])
    annotation (Placement(transformation(extent={{20,40},{40,60}})));

  Utilities.ErrorAnalysis.UnitTests unitTests(
    x=cat(        1,
                  Cs,
                  Es),
    x_reference=cat(
                  1,
                  kinetics.Cs[1, :],
                  kinetics.Es[1, :]),
    n=17)                   annotation (Placement(transformation(
          extent={{80,80},{100,100}})));
  Data.DecayHeat.decayHeat_11_TRACEdefault data_dh
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));

   SI.Energy Es[data_dh.nC];
   SI.Power Cs[data.nC];

initial equation
  (Cs,Es) =
    TRANSFORM.Nuclear.ReactorKinetics.Functions.Initial_powerBased_powerHistory(
              data_history.table,
              data.lambdas,
              data.alphas,
              data.Beta,
              kinetics.Lambda_start,
              data_dh.lambdas,
              data_dh.efs,
              includeDH=kinetics.includeDH);

equation
   der(Cs) = zeros(data.nC);
   der(Es) = zeros(data_dh.nC);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Initial_powerBased_powerHistory;
