within TRANSFORM.Fluid.Pipes.Examples.SpeciesTransportProgressionProblems_old;
model Problem_5 "Single Species Drift w/ DepositionSingle species drift with decay non-uniform concentration"
  extends TRANSFORM.Icons.Example;
  extends TRANSFORM.Icons.UnderConstruction;

  // Seems ok but scaling is messed up if nV changes. unit issues too?
  // need to add Ci_w still

  package Medium = Modelica.Media.Water.StandardWater (extraPropertiesNames=fill(
           "a", nC), C_nominal=fill(1.0, nC));

  constant Integer nC=1;
  parameter Integer nV=10;
  parameter SI.Length length=0.100;
  parameter SI.Length dimension=0.01;
  parameter SI.Temperature T_a_start=293.15;
  parameter SI.Pressure p_a_start=1e5;

  parameter SI.Velocity v=0.02;
  final parameter SI.MassFlowRate m_flow = Medium.density_pT(p_a_start,T_a_start)*Modelica.Constants.pi*dimension^2/4*v;

  parameter TRANSFORM.Units.InverseTime lambda_i[nC]=fill(0.1, nC);
  parameter SIadd.ExtraPropertyConcentration C_i_start[nV,nC]=1000*ones(nV, nC);
  parameter SIadd.ExtraPropertyConcentration C_i_w_start[nV,nC]=zeros(nV, nC);

  parameter Real a1 = 0.1*100;
  parameter Real a2 = -500;
  parameter Real T = 900;

  final parameter SIadd.ExtraProperty Cs_start[nV,nC]={{C_i_start[i, j]/
      Medium.density_pT(p_a_start, T_a_start) for j in 1:nC} for i in 1
      :nV};
  SI.Length x[nV]=pipe.summary.xpos;

  SIadd.ExtraPropertyConcentration C_i[nV,nC];
  SIadd.ExtraPropertyConcentration C_i_w[nV,nC];
  SIadd.ExtraPropertyConcentration C_i_analytical[nV,nC];
  SIadd.ExtraPropertyConcentration C_i_w_analytical[nV,nC];

  SIadd.ExtraPropertyFlowRate[nV,nC] mC_gens={{-a1/100^2*exp(a2/T)*Medium.density_pT(pipe.mediums[j].d,pipe.mediums[j].T)
      for j in 1:nC} for i in 1:nV};

  Pipes.GenericPipe_MultiTransferSurface pipe(
    redeclare package Medium = Medium,
    Cs_start=Cs_start,
    p_a_start=p_a_start,
    T_a_start=T_a_start,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        dimension=dimension,
        length=length,
        nV=nV),
    redeclare model InternalTraceGen =
        TRANSFORM.Fluid.ClosureRelations.InternalTraceGeneration.Models.DistributedVolume_Trace_1D.GenericTraceGeneration
        (mC_gens=mC_gens))
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  BoundaryConditions.MassFlowSource_T boundary(
    redeclare package Medium = Medium,
    m_flow=m_flow,
    T=T_a_start,
    C=Cs_start[1, :],
    nPorts=1) annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  BoundaryConditions.Boundary_pT boundary1(
    redeclare package Medium = Medium,
    p=p_a_start,
    T=T_a_start,
    nPorts=1) annotation (Placement(transformation(extent={{60,-10},{40,10}})));

equation

  // Create variable for volume based concentration
  for j in 1:nV loop
    for i in 1:nC loop
      C_i[j, i] = pipe.Cs[j, i]*pipe.mediums[j].d;
      der(C_i_w[j,i]) = a1*exp(a2/T);
    end for;
  end for;

  // Analytical Solution
  for j in 1:nV loop
    if x[j] < v*time then
      for i in 1:nC loop
        //Heavyside = 1
        C_i_analytical[j, i] = (C_i_start[j, i]*v - a1*exp(a2/T)*time*v + C_i_start[1, i]*v -
                               C_i_start[j, i]*v + a1*exp(a2/T)*time*v - a1*exp(a2/T)*x[j])/v;
      end for;
    else
      for i in 1:nC loop
        C_i_analytical[j, i] = (C_i_start[j, i]*v - a1*exp(a2/T)*time*v)/v;

      end for;
    end if;
  end for;

  for j in 1:nV loop
    for i in 1:nC loop
      C_i_w_analytical[j,i] = a1*exp(a2/T)*time;
    end for;
  end for;

  connect(boundary.ports[1], pipe.port_a)
    annotation (Line(points={{-40,0},{-10,0}}, color={0,127,255}));
  connect(pipe.port_b, boundary1.ports[1])
    annotation (Line(points={{10,0},{40,0}}, color={0,127,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=20,
      __Dymola_NumberOfIntervals=400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"));
end Problem_5;
