within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.Cylindrical.BaseClasses;
partial model Partial_BaseFDCond_Cylinder
  import SI = Modelica.SIunits;

  /* General */
  replaceable package Material =
      TRANSFORM.Media.Solids.SS316                     constrainedby
    TRANSFORM.Media.Interfaces.PartialAlloy
    "Specify material type"
    annotation(choicesAllMatching=true);

  parameter Boolean use_q_ppp = false
    "Toggle volumetric heat generation interface"
   annotation(Evaluate=true,choices(checkBox=true));
  parameter Integer nR(min=2) = 2 "Nodes in radial direction";
  parameter Integer nZ(min=2) = 2 "Nodes in axial direction";

  input SI.Length r_inner(min=0) = 0 "Centerline/Inner radius of cylinder or specify rs"
  annotation(Dialog(group="Input Variables"));
  input SI.Length r_outer "Outer radius of cylinder or specify rs"
  annotation(Dialog(group="Input Variables"));
  input SI.Length length "Length of cylinder or specify zs"
  annotation(Dialog(group="Input Variables"));
  input SI.Length rs[nR]=if nR == 1 then {0.5*(r_inner + r_outer)} else
      linspace(
      r_inner,
      r_outer,
      nR) "Define radial nodal positions" annotation (Dialog(group="Input Variables"));
  input SI.Length zs[nZ]=if nZ == 1 then {0.5*length} else linspace(
      0,
      length,
      nZ) "Define axial nodal positions" annotation (Dialog(group="Input Variables"));

  /* Assumptions */
  parameter Modelica.Fluid.Types.Dynamics energyDynamics = Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Formulation of energy balances" annotation(Dialog(tab="Advanced",group="Dynamics"));

  /* Initialization */
  parameter SI.Temperature Tref = 273.15 "Center nodes initial temperature"
   annotation(Dialog(tab="Initialization"));
  parameter SI.Temperature Ts_start[nR,nZ]=fill(
            Tref,
            nR,
            nZ)
          annotation (Dialog(tab="Initialization"));

  Modelica.Blocks.Interfaces.RealInput[nR,nZ] q_ppp_input(unit="W/m3") if
    use_q_ppp "Volumetric heat generation" annotation (Placement(transformation(
          extent={{-130,45},{-100,75}}), iconTransformation(
        extent={{-6,-6},{6,6}},
        rotate,
        rotation=-45,
        origin={-40,40})));
  Modelica.Fluid.Interfaces.HeatPorts_a[nZ] heatPorts_inner(T(start=
          Ts_start[1, :])) "Heat interface on inner boundary" annotation (
     Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-100,0}), iconTransformation(
        extent={{-20,-5},{20,5}},
        rotation=-90,
        origin={-59,0})));
  Modelica.Fluid.Interfaces.HeatPorts_a[nZ] heatPorts_outer(T(start=
          Ts_start[end, :])) "Heat interface on outer boundary"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={100,0}), iconTransformation(
        extent={{-20,-5},{20,5}},
        rotation=-90,
        origin={59,0})));
  Modelica.Fluid.Interfaces.HeatPorts_a[nR] heatPorts_bottom(T(start=
          Ts_start[:, 1])) "Heat interface on bottom boundary"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}}),
        iconTransformation(extent={{-20,-64},{20,-54}})));
  Modelica.Fluid.Interfaces.HeatPorts_a[nR] heatPorts_top(T(start=
          Ts_start[:, end])) "Heat interface on top boundary" annotation (
     Placement(transformation(extent={{-10,90},{10,110}}),
        iconTransformation(extent={{-20,56},{20,66}})));

equation
  assert(r_outer > r_inner, "r_inner must be greater than r_outer");
  assert(abs(rs[1] - r_inner) < Modelica.Constants.eps, "r_inner and r[1] must be equal");
  assert(abs(rs[end] - r_outer) < Modelica.Constants.eps, "r_outer and r[end] must be equal");
  assert(size(rs, 1) == nR, "r and nRadial must have equal sizes");
  assert(size(zs, 1) == nZ, "z and nAxial must have equal sizes");
  assert(length > 0, "length of cylinder must be greater than zero");
  assert(zs[1] >= 0, "cylinder length z[1] must be >= 0");
  assert(zs[end] <= length, "cylinder length z[1] must be >= 0");
  //assert((length-abs(z[end]-z[1]))/length < 1e-3, "length of cylinder must be equal to length of z");

end Partial_BaseFDCond_Cylinder;
