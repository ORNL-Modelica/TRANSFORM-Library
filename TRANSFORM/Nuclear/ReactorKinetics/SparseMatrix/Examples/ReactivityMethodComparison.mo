within TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Examples;
model ReactivityMethodComparison
  extends TRANSFORM.Icons.UnderConstruction;
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;

  //Comment/Uncomment as a block - BIG DATA
  //   record Data = FissionProducts.fissionProducts_test3;
  //   parameter Real mCs_start[1,fissionProducts.nC] = {cat(1,fill(0,1008),{1e30},fill(0,2237-1008-1))};
  //   parameter Integer i_noGen[:]={1009};

  //Comment/Uncomment as a block - SMALL DATA
  record Data =
      TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Data.Isotopes.Isotopes_TeIXeU;
  parameter Real mCs_start[4]={0,0,0,1.43e1};


  TRANSFORM.Nuclear.ReactorKinetics.Reactivity.FissionProducts_withDecayHeat
    fissionProducts(
    Q_fission=Q_fission.y,
    mCs_start=zeros(fissionProducts.nC),
                    traceDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      redeclare record Data =
        TRANSFORM.Nuclear.ReactorKinetics.Data.FissionProducts.fissionProducts_TeIXe_U235)
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Reactivity.Isotopes.Lumped.Isotopes_withDecayHeat_sparseMatrix
    fissionProducts_sparseMatrix(
    Q_fission=Q_fission.y,
    mCs_start=mCs_start,
    traceDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    redeclare record Data =
        TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Data.Isotopes.Isotopes_TeIXeU,
    use_noGen=true)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Sources.Step Q_fission(
    height=-0.5e6,
    offset=1e6,
    startTime=2e5)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ReactivityMethodComparison;
