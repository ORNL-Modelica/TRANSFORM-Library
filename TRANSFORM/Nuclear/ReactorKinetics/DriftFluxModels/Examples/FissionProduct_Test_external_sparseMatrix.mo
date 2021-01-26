within TRANSFORM.Nuclear.ReactorKinetics.DriftFluxModels.Examples;
model FissionProduct_Test_external_sparseMatrix

  extends TRANSFORM.Icons.Example;

  Reactivity.FissionProducts_external_withDecayHeat_sparseMatrix
    fissionProducts_sparseMatrix(
    redeclare record Data = Data,
    Q_fission=Q_fission.y,
    mCs=mCs,
    use_noGen=true,
    i_noGen=i_noGen)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  //Comment/Uncomment as a block - BIG DATA
  //   record Data = FissionProducts.fissionProducts_test3;
  //   parameter Real mCs_start[1,fissionProducts.nC] = {cat(1,fill(0,1008),{1e30},fill(0,2237-1008-1))};
  //   parameter Integer i_noGen[:]={1009};

  //Comment/Uncomment as a block - SMALL DATA
  record Data = DriftFluxModels.Data.FissionProducts.fissionProducts_TeIXeU;
  parameter Real mCs_start[1,4]={{0,0,0,1.43e24}};
  parameter Integer i_noGen[:]={4};

  SIadd.ExtraPropertyExtrinsic mCs[1,fissionProducts_sparseMatrix.nC](start=
        mCs_start);

  parameter Real mCs_old_start[1,3]={{0,0,0}};
  SIadd.ExtraPropertyExtrinsic mCs_old[1,fissionProducts.nC](start=
        mCs_old_start);

  Modelica.Blocks.Sources.Step Q_fission(
    height=-0.5e6,
    offset=1e6,
    startTime=2e5)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  TRANSFORM.Nuclear.ReactorKinetics.Reactivity.FissionProducts_externalBalance_withTritium_withDecayHeat
    fissionProducts(
    redeclare record Data =
        TRANSFORM.Nuclear.ReactorKinetics.Data.FissionProducts.fissionProducts_TeIXe_U235,
    Q_fission=Q_fission.y,
    mCs=mCs_old)
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));

equation

  der(mCs) =fissionProducts_sparseMatrix.mC_gens;
  der(mCs_old) =fissionProducts.mC_gens;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=500000,
      __Dymola_NumberOfIntervals=100000,
      __Dymola_Algorithm="Dassl"));
end FissionProduct_Test_external_sparseMatrix;
