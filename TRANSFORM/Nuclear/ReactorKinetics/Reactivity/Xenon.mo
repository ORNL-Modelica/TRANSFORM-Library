within TRANSFORM.Nuclear.ReactorKinetics.Reactivity;
model Xenon

  /*****************************************/
  /*              Parameters               */
  /*****************************************/

  parameter Real gamma_iodine = 6.1e-2 "Fraction of Iodine from fission" annotation (Dialog(tab="Nuclear Data", group="Iodine"));
  parameter Real gamma_xeon = 3.0e-3 "Fraction of Xeon from fission"  annotation (Dialog(tab="Nuclear Data", group="Xeon"));
  parameter SI.DecayConstant lambda_xenon=2.092e-5
    "Fraction of xenon from fission"
    annotation (Dialog(tab="Nuclear Data", group="xenon"));
  parameter SI.DecayConstant lambda_iodine=2.875e-5 "Decaay constant of Iodine"
    annotation (Dialog(tab="Nuclear Data", group="Iodine"));

  parameter Real sigma_fission(unit="1/cm") = 0.209
    "Macroscopic neutron fission cross section"                                                  annotation (Dialog(tab="Nuclear Data", group="Neutron"));
  parameter SI.Energy energy_per_fission=200*1e6*1.602*1e-19
    annotation (Dialog(tab="Nuclear Data", group="Neutron"));
  parameter Real micro_sigma_xenon(unit="cm2") = 2.609e-18
    "Microscopic cross section"                                                          annotation (Dialog(tab="Nuclear Data", group="Neutron"));

  parameter SI.Power reactor_power_ref=540*1e6
    annotation (Dialog(tab="Initial Conditions", group="Reactor"));
  parameter Real xenon_reactivity_worth = -2653*1e-5
    "difference between no xenon and max. xenon in the core"                                                 annotation (Dialog(tab="Initial Conditions", group="Reactor"));
  parameter Real vol_fuel(unit="cm3") = 2.31648*100*(0.81915/2)^2*Modelica.Constants.pi
                                                                     annotation (Dialog(tab="Initial Conditions", group="Reactor"));

  parameter Real N_xenon_start(unit = "1/cm3", displayUnit = "1/cm3") = 0  annotation (Dialog(tab="Initial Conditions", group="Reactor"));
  parameter Real N_iodine_start(unit = "1/cm3", displayUnit = "1/cm3") = 0  annotation (Dialog(tab="Initial Conditions", group="Reactor"));

  /*****************************************/
  /* Variables that require starting value */
  /*****************************************/
  Real N_iodine(start=N_iodine_start, unit = "1/cm3", displayUnit = "1/cm3")
    "Atom density of Iodine";
  Real N_xenon(start= N_xenon_start, unit = "1/cm3", displayUnit = "1/cm3")
    "Atom density of xenon";

  /*****************************************/
  /*              Variables                */
  /*****************************************/

  Real phi_neutron(unit="1/(cm2.s)")
    "Neutron flux, converted from the reactor power";
  Real phi_neutron_ref(unit="1/(cm2.s)")
    "Neutron flux by reference power, converted from the reactor power";
  SI.DecayConstant lambda_xenon_effective "Effective xenon decay constant";

  SI.Power reactor_power "reactor power by kinetic model";
  Real reactivity_xenon "xenon reactivity feedback";

  Real N_iodine_steady(unit = "1/cm3", displayUnit = "1/cm3")
    "Steady-state atom density of Iodine at reactor full power";
  Real N_xenon_steady(unit = "1/cm3", displayUnit = "1/cm3")
    "Steady-state atom density of xenon at reactor full power";
  Real alpha_xenon
    "reactivity feedback coefficient, solve by xenon reactivity worth / xenon atom density at steady-state";

  /* =================== */
  /* Interactive Options */
  /* =================== */

  parameter Boolean use_Power_in = false
    "Input Effective Moderator Temperature"
    annotation(Evaluate=true, HideResult=true, choices(checkBox=true));

  Modelica.Blocks.Interfaces.RealInput Power_In(unit="W") if use_Power_in
    annotation (Placement(transformation(extent={{-80,-50},{-120,-10}},
          rotation=0), iconTransformation(extent={{4.5,-4.5},{-4.5,4.5}},
        rotation=180,
        origin={-84,-0.5})));

  parameter Boolean use_reactivity_out = false
    "Input Effective Moderator Temperature"
    annotation(Evaluate=true, HideResult=true, choices(checkBox=true));

  Modelica.Blocks.Interfaces.RealOutput xenon_reactivity_out if use_reactivity_out
    annotation (Placement(transformation(extent={{-100,-10},{-140,30}},
          rotation=0), iconTransformation(extent={{4.5,-4.5},{-4.5,4.5}},
        rotation=180,
        origin={92,1.5})));

protected
  Modelica.Blocks.Interfaces.RealOutput Power_In_internal(unit="W")
    "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealOutput xenon_reactivity_out_internal
    "Needed to connect to conditional connector";

equation
  /* =================== */
  /* Interactive Options */
  /* =================== */

  connect(Power_In_internal, Power_In);
  if not use_Power_in then
    Power_In_internal = 540*1e6;
  end if;
  reactor_power = Power_In_internal;

  connect(xenon_reactivity_out_internal, xenon_reactivity_out);
  xenon_reactivity_out_internal = reactivity_xenon;

  /********************/
  /* balance equation */
  /********************/

  der(N_iodine) = - lambda_iodine * N_iodine + gamma_iodine * sigma_fission * phi_neutron;
  der(N_xenon)   = - lambda_xenon_effective * N_xenon + gamma_xenon * sigma_fission * phi_neutron + lambda_iodine * N_iodine;

  /**********************/
  /* Solving parameters */
  /**********************/

  /* Solve N_xenon_ref */
  0 = - lambda_iodine * N_iodine_steady + gamma_iodine * sigma_fission * phi_neutron_ref;
  0 = - lambda_xenon_effective * N_xenon_steady + gamma_xenon * sigma_fission * phi_neutron_ref + lambda_iodine * N_iodine_steady;

  /* Solve flux */
  phi_neutron = reactor_power / energy_per_fission / vol_fuel / sigma_fission;
  phi_neutron_ref = reactor_power_ref / energy_per_fission / vol_fuel / sigma_fission;

  /* Solve reactivity */
  reactivity_xenon = alpha_xenon * (N_xenon - N_xenon_steady);

  /* Solve effective xenon decay constant */
  lambda_xenon_effective = lambda_xenon + micro_sigma_xenon * phi_neutron;

  /* Solve reactivity feedback coefficient */
  alpha_xenon = xenon_reactivity_worth / N_xenon_steady; // take absolute value to ensurse positive reactivity coefficient

      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                       graphics={Text(
                       visible=use_reactivity_out,
          extent={{-12.25,3.75},{12.25,-3.75}},
          lineColor={0,0,255},
          origin={90.75,12.75},
          rotation=0,
          textString="rho"),
          Text(
          visible=use_Power_in,
          extent={{-12.25,3.75},{12.25,-3.75}},
          lineColor={0,0,255},
          origin={-89.25,10.75},
          rotation=0,
          textString="PowerIn"),
        Ellipse(extent={{-46,46},{48,-40}}, lineColor={0,0,255},
          lineThickness=0.5),
        Text(
          extent={{-26,34},{34,-26}},
          lineColor={0,0,255},
          textString="xenon")}));
end Xenon;
