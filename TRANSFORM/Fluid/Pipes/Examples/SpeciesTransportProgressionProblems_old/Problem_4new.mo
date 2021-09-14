within TRANSFORM.Fluid.Pipes.Examples.SpeciesTransportProgressionProblems_old;
model Problem_4new "I-135 Decay with Non-uniform concentration"
  extends TRANSFORM.Icons.Example;
  extends TRANSFORM.Icons.UnderConstruction;

  package Medium = Modelica.Media.Water.StandardWater (extraPropertiesNames=fill("a", nC), C_nominal=fill(1.0,
          nC));

  constant Integer nC=6;
  parameter Integer nV=10;
  parameter SI.Length length=1.0;
  parameter SI.Length dimension=0.01;
  parameter SI.Temperature T_start=20 + 273.15;
  parameter SI.Pressure p_start=1e5;

  parameter SI.Velocity v=0.025;
  final parameter SI.MassFlowRate m_flow=Medium.density_pT(p_start, T_start)*Modelica.Constants.pi*dimension^2/4
      *v;

  parameter TRANSFORM.Units.InverseTime lambda_i[nC]={0.0127,0.0317,0.115,0.311,1.4,3.87};
  final parameter SI.Time time_half[nC]={log(2)/lambda_i[i] for i in 1:nC};
  final parameter SIadd.ExtraPropertyConcentration C_i_start[nV,nC]=zeros(nV, nC);
  parameter Real phi_0=1e10;
  parameter Real beta_i[nC]={0.0006,0.00364,0.00349,0.00628,0.00179,0.00070};

  final parameter SIadd.ExtraProperty Cs_start[nV,nC]={{C_i_start[i, j]/Medium.density_pT(p_start, T_start)
      for j in 1:nC} for i in 1:nV};
  final parameter SI.Length x[nV]=linspace(
      0,
      length,
      nV);

  SIadd.ExtraPropertyConcentration C_i[nV,nC];
  //SIadd.ExtraPropertyConcentration C_i_analytical[nV,nC];

  SIadd.ExtraPropertyFlowRate[nV,nC] mC_gens={{-lambda_i[j]*pipe.mCs[i, j]*pipe.nParallel + beta_i[j]*phi_0*sin(
       Modelica.Constants.pi*pipe.summary.xpos_norm[j]) for j in 1:nC} for i in 1:nV};

       Real cool[nV] = {if x[j] < v*time then 1 else 0 for j in 1:nV};
  Pipes.GenericPipe_MultiTransferSurface pipe(
    redeclare package Medium = Medium,
    Cs_start=Cs_start,
    p_a_start=p_start,
    T_a_start=T_start,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe (
        dimension=dimension,
        length=length,
        nV=nV),
    redeclare model InternalTraceGen =
        TRANSFORM.Fluid.ClosureRelations.InternalTraceGeneration.Models.DistributedVolume_Trace_1D.GenericTraceGeneration
        (mC_gens=mC_gens)) annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  BoundaryConditions.MassFlowSource_T boundary(
    redeclare package Medium = Medium,
    use_C_in=true,
    m_flow=m_flow,
    T=T_start,
    nPorts=1) annotation (Placement(transformation(extent={{-68,-10},{-48,10}})));

  BoundaryConditions.Boundary_pT boundary1(
    redeclare package Medium = Medium,
    p=p_start,
    T=T_start,
    nPorts=1) annotation (Placement(transformation(extent={{60,-10},{40,10}})));

  Sensors.TraceSubstancesTwoPort_multi sensor_C(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{10,10},{30,-10}})));
equation

  // Create variable for volume based concentration
  for j in 1:nV loop
    for i in 1:nC loop
      C_i[j, i] = pipe.Cs[j, i]*pipe.mediums[j].d;
    end for;
  end for;

  // Analytic solution independently implemented in Mathematica

  connect(boundary.ports[1], pipe.port_a) annotation (Line(points={{-48,0},{-30,0}}, color={0,127,255}));
  connect(sensor_C.C, boundary.C_in)
    annotation (Line(points={{20,-3.6},{20,-20},{-80,-20},{-80,-8},{-68,-8}}, color={0,0,127}));
  connect(pipe.port_b, sensor_C.port_a)
    annotation (Line(points={{-10,0},{10,0}}, color={0,127,255}));
  connect(sensor_C.port_b, boundary1.ports[1])
    annotation (Line(points={{30,0},{40,0}}, color={0,127,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=1000,
      __Dymola_NumberOfIntervals=4800,
      __Dymola_Algorithm="Dassl"));
end Problem_4new;
