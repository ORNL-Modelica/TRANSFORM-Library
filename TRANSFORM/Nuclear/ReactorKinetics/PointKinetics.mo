within TRANSFORM.Nuclear.ReactorKinetics;
model PointKinetics
  "0-D point kinetics model of reactor dynamics with 6-group default precursor concentrations"

  extends TRANSFORM.Icons.ObsoleteModel;

  import Modelica.Fluid.Types.Dynamics;

  /* General parameters */
  parameter Boolean use_DecayHeat = false
    "Include decay heat in power calculation";
  parameter SI.Time T_op = 360*24*3600 "Time since reactor startup" annotation(Dialog(enable=use_DecayHeat));
  parameter SI.Power Q_nominal "Nominal total reactor power";

  /* Kinetics */
  // Neutron kinetic parameters as defined by TRACE Manual V5.0, p. 469
  parameter Integer nI = 6
    "Number of groups of the delayed-neutron precursors groups"
     annotation (Dialog(tab="Kinetics", group="Neutron Kinetics Parameters"));
  parameter Units.NonDim[nI] beta_i={0.000169,0.000832,0.00264,0.00122,0.00138,
      0.000247} "Delayed neutron precursor fractions"
    annotation (Dialog(tab="Kinetics", group="Neutron Kinetics Parameters"));
  parameter Units.InverseTime[nI] lambda_i={3.87,1.40,0.311,0.115,0.0317,0.0127}
    "Decay constants for each precursor group"
    annotation (Dialog(tab="Kinetics", group="Neutron Kinetics Parameters"));
  // Default Lambda taken from approximate range (1e-6 - 1e-4) discussed in Duderstadt and Hamilton Nuclear Reactor Kinetics p. 239
  parameter SI.Time Lambda = 1e-5 "Prompt neutron generation time" annotation (Dialog(tab="Kinetics", group="Neutron Kinetics Parameters")); //16e-6
  // Reactivity feedback parameters
  // Default values taken from average value of range from Table 14-2 in Duderstadt and Hamilton Nuclear Reactor Kinetics p. 563
  parameter Units.TempFeedbackCoeff alpha_fuel=-2.5e-5
    "Doppler feedback coefficient"
    annotation (Dialog(tab="Kinetics", group="Reactivity Feedback Parameters"));
  parameter Units.TempFeedbackCoeff alpha_coolant=-20e-5
    "Moderator feedback coefficient"
    annotation (Dialog(tab="Kinetics", group="Reactivity Feedback Parameters"));
  // These values correspond to the nominal full power operation
  parameter SI.Temperature Teffref_fuel = 1000 "Reference Fuel Temperature" annotation (Dialog(tab="Kinetics", group="Reactivity Feedback Parameters"));
  parameter SI.Temperature Teffref_coolant = 500
    "Reference Coolant Temperature"                                             annotation (Dialog(tab="Kinetics", group="Reactivity Feedback Parameters"));

  /* Assumptions */
  parameter Dynamics energyDynamics = Dynamics.DynamicFreeInitial
    "Formulation of nuclear kinetics balances"   annotation(Dialog(tab="Assumptions",group="Dynamics"));

  /* Initialization */
  parameter SI.Power[nI] C_i_start = {beta_i[i]/(lambda_i[i]*Lambda)*Q_nominal for i in 1:nI}
    "Power of the initial delayed-neutron precursor concentrations"
    annotation(Dialog(tab="Initialization"));

  /* Simulation variables */
  Units.NonDim Reactivity_Fuel "Fuel reactivity feedback";
  Units.NonDim Reactivity_Coolant "Coolant reactivity feedback";
  Units.NonDim Reactivity_Total "Total reactivity feedback";

  SI.Power Q_fission "Total fission power";
  SI.Power Q_decay "Decay heat";

  Units.NonDim Beta=sum(beta_i) "Sum of delayed neutron precursor fractions";
  SI.Power[nI] C_i(start=C_i_start)
    "Power of the delayed-neutron precursor concentration in group i";

  Units.NonDim Reactivity_CR "Control rod reactivity";
  Units.NonDim Reactivity_Other "Alternative Sources of Reactivity";
  SI.Temperature Teff_coolant "Effective coolant temperature";
  SI.Temperature Teff_fuel "Fuel effective temperature";
  SI.Power S_external "Thermal power from external source of neutrons";

  /* Inputs */
  Modelica.Blocks.Interfaces.RealInput Reactivity_Other_in
    "Additional non-classified reactivity" annotation (Placement(transformation(
        extent={{-9.5,-9.5},{9.5,9.5}},
        rotation=0,
        origin={-111,22}), iconTransformation(
        extent={{9.75,-10.25},{-9.75,10.25}},
        rotation=180,
        origin={-89.75,35.25})));
  Modelica.Blocks.Interfaces.RealInput Reactivity_CR_in
    "Control rod reactivity" annotation (Placement(transformation(
        extent={{-9.5,-9.5},{9.5,9.5}},
        rotation=0,
        origin={-111,40.5}),
                           iconTransformation(
        extent={{9.75,-10.25},{-9.75,10.25}},
        rotation=180,
        origin={-89.75,70.25})));
  Modelica.Blocks.Interfaces.RealInput S_external_in
    "Thermal power from external source of neutrons"
    annotation (Placement(transformation(extent={{-9.5,-9.5},{9.5,9.5}},
          rotation=0,
        origin={-111,4}),
                       iconTransformation(extent={{9.75,-10.25},{-9.75,10.25}},
        rotation=180,
        origin={-89.75,0.25})));
  Modelica.Blocks.Interfaces.RealInput Teff_fuel_in
    "Effective fuel temperature"
    annotation (Placement(transformation(extent={{-9.5,-9.75},{9.5,9.75}},
          rotation=0,
        origin={-111.25,-16}),
                       iconTransformation(extent={{9.75,-9.75},{-9.75,9.75}},
        rotation=180,
        origin={-89.75,-35.25})));
  Modelica.Blocks.Interfaces.RealInput Teff_coolant_in
    "Effective moderator temperature"
    annotation (Placement(transformation(extent={{-9.5,-9.5},{9.5,9.5}},
          rotation=0,
        origin={-111,-39.5}),
                       iconTransformation(extent={{9.75,-10.25},{-9.75,10.25}},
        rotation=180,
        origin={-89.75,-69.75})));

  /* Outputs */
  Modelica.Blocks.Interfaces.RealOutput Q_total(start=Q_nominal, fixed=not energyDynamics == Dynamics.SteadyState)
    "Total power of the reactor"
    annotation (Placement(transformation(extent={{101,24},{123.5,45}}),                                                      iconTransformation(extent={{80,-9},
            {99.5,9.5}})));

initial equation

  if energyDynamics == Dynamics.FixedInitial then
    C_i = C_i_start;
  elseif energyDynamics == Dynamics.SteadyStateInitial then
    der(C_i) = zeros(nI);
  end if;

equation
  Reactivity_CR = Reactivity_CR_in;
  Reactivity_Other = Reactivity_Other_in;
  Teff_fuel = Teff_fuel_in;
  Teff_coolant = Teff_coolant_in;
  S_external = S_external_in;

  // Reactivity feedback equations
  Reactivity_Fuel = alpha_fuel*(Teff_fuel - Teffref_fuel);
  Reactivity_Coolant = alpha_coolant*(Teff_coolant - Teffref_coolant);
  Reactivity_Total = Reactivity_CR + Reactivity_Other + Reactivity_Fuel + Reactivity_Coolant;

  // Point kinetics equations
  if energyDynamics == Dynamics.SteadyState then
    0 = (Reactivity_Total - Beta)/Lambda*Q_fission + sum(lambda_i.*C_i) + S_external/(Lambda*(1-Reactivity_Total));
    zeros(nI) = -lambda_i.*C_i + beta_i./Lambda*Q_fission;
  else
    der(Q_fission) = (Reactivity_Total - Beta)/Lambda*Q_fission + sum(lambda_i.*C_i) + S_external/(Lambda*(1-Reactivity_Total));
    der(C_i) = -lambda_i.*C_i + beta_i./Lambda*Q_fission;
  end if;

  /* Decay heat equations */
  //der(H_j) = -lambdaH_j*H_j + E_j*Q_fission; #Place holder see TRACE manual eq 9-17 pg 468
  Q_decay = (0.1*((time + 10)^(-0.2) - (time + T_op)^(-0.2) + 0.87*(time +
             T_op + 2e7)^(-0.2) - 0.87*(time + 2e7)^(-0.2)))*Q_nominal;

  /*=======================*/
  /* Thermal power profile */
  /*=======================*/

  if use_DecayHeat then
    Q_total = Q_fission + Q_decay;
  else
    Q_total = Q_fission;
  end if;
  //Q_total = Q_fission + sum(lambdaH_j*H_j); place holder eq 9-18 pg. 468 trace manual

 annotation (defaultComponentName="kinetics",
    Dialog(tab="Kinetics", group="prompt neutron generation time"),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-80},{100,80}},
        grid={0.5,0.5})),
          Documentation(info="<html>
<p>Implementaion of the 0-D point reactor kinetics equations as preseneted in TRACE 5.0 manual (pg. 467).</p>
<p><br>- Decay heat is currently charaterized by an approximation for a light water reactor that has been operating</p>
<p>for a long period of time iven by eq. 4-32 (pg.96) in Nuclear Heat Transport by M. M. El-Wakil. This will be</p>
<p>improved to ANS decay heat standards as described in the TRACE manual (pg 470).</p>
</html>",     revisions="<html>
<p>Test</p>
</html>"),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-80},{100,80}}),
        graphics={
        Rectangle(
        extent={{-80,-80},{80,80}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{28,-48.5},{40,-36.5}},
          fillColor={255,0,0},
          fillPattern=FillPattern.Sphere,
          pattern=LinePattern.None,
          lineColor={0,0,0}),           Text(
        extent={{-149,138.5},{151,98.5}},
        textString="%name",
        lineColor={0,0,255}),
        Ellipse(
          extent={{-14,7},{-2,19}},
          fillColor={0,0,255},
          fillPattern=FillPattern.Sphere,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-6,11},{6,23}},
          fillColor={255,0,0},
          fillPattern=FillPattern.Sphere,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{2,7},{14,19}},
          fillColor={0,0,255},
          fillPattern=FillPattern.Sphere,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{2,-1},{14,11}},
          fillColor={255,0,0},
          fillPattern=FillPattern.Sphere,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-6,3},{6,15}},
          fillColor={0,0,255},
          fillPattern=FillPattern.Sphere,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-6,-5},{6,7}},
          fillColor={0,0,255},
          fillPattern=FillPattern.Sphere,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-14,-1},{-2,11}},
          fillColor={255,0,0},
          fillPattern=FillPattern.Sphere,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-41.5,-41},{-29.5,-29}},
          fillColor={0,0,255},
          fillPattern=FillPattern.Sphere,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-33,-49},{-21,-37}},
          fillColor={0,0,255},
          fillPattern=FillPattern.Sphere,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-41.5,-49},{-29.5,-37}},
          fillColor={255,0,0},
          fillPattern=FillPattern.Sphere,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{25.5,-39.5},{37.5,-27.5}},
          fillColor={0,0,255},
          fillPattern=FillPattern.Sphere,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{19.5,-45},{31.5,-33}},
          fillColor={255,0,0},
          fillPattern=FillPattern.Sphere,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-6.5,55},{5.5,67}},
          fillColor={0,0,255},
          fillPattern=FillPattern.Sphere,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{-5.5,40},{-0.5,30},{4.5,40},{-5.5,40}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-1,50},{0,40}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{-5,5},{0,-5},{5,5},{-5,5}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={-20,-23.5},
          rotation=-30),
        Rectangle(
          extent={{-0.5,5},{0.5,-5}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={-15,-15},
          rotation=-30),
        Polygon(
          points={{-5,5},{0,-5},{5,5},{-5,5}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={20,-23.5},
          rotation=30),
        Rectangle(
          extent={{-0.5,5},{0.5,-5}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={15,-15},
          rotation=30),
        Ellipse(
          extent={{-13.5,-66.5},{-1.5,-54.5}},
          fillColor={0,0,255},
          fillPattern=FillPattern.Sphere,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{1,-61.5},{13,-49.5}},
          fillColor={0,0,255},
          fillPattern=FillPattern.Sphere,
          pattern=LinePattern.None,
          lineColor={0,0,0})}),
          experiment(
              StopTime=1000,NumberOfIntervals=10000),
              __Dymola_experimentSetupOutput);
end PointKinetics;
