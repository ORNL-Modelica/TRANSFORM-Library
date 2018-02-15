within TRANSFORM.Nuclear.ReactorKinetics;
model PointKinetics_Drift

  import TRANSFORM.Types.Dynamics;
  import TRANSFORM.Math.fillArray_1D;

  parameter Integer nV=1 "# of discrete volumes";
  parameter Integer nI=6 "# of delayed-neutron precursors groups";
  parameter SI.Power Q_nominal=1e6 "Total nominal reactor power";
  parameter Boolean specifyPower=false
    "=true to specify power (i.e., no der(P) equation)";

  // Inputs
  input SI.Temperature[nV] Ts "Medium temperature for temperature feedback"
    annotation (Dialog(group="Input Variables"));
  input SI.Mass[nV,nI] mCs
    "Absolute delayed precursor group concentration per volume"
    annotation (Dialog(group="Input Variables"));
  input SI.Power[nV] Qs_input=fill(Q_nominal/nV, nV)
    "Specifed power if specifyPower=true"
    annotation (Dialog(group="Input Variables", enable=specifyPower));
  input SI.Power Qs_external[nV]=zeros(nV) "External power source"
    annotation (Dialog(group="Input Variables"));
  input Units.NonDim[nV] rhos_input=zeros(nV) "External Reactivity"
    annotation (Dialog(group="Input Variables"));

  // Neutron Kinetics
  input TRANSFORM.Units.InverseTime[nI] lambda_i={0.0125,0.0318,0.109,0.317,1.35,
      8.64} "Decay constants for each precursor group" annotation (Dialog(tab="Kinetics",
        group="Input Variables: Neutron Kinetics"));
  input TRANSFORM.Units.NonDim[nI] alpha_i={0.0320,0.1664,0.1613,0.4596,0.1335,0.0472}
    "Normalized precursor fractions" annotation (Dialog(tab="Kinetics", group="Input Variables: Neutron Kinetics"));
  input TRANSFORM.Units.NonDim[nI] beta_i=alpha_i*Beta
    "Delayed neutron precursor fractions" annotation (Dialog(tab="Kinetics",
        group="Input Variables: Neutron Kinetics"));
  input TRANSFORM.Units.NonDim Beta=0.0065
    "Effective delay neutron fraction [e.g., Beta = sum(beta_i)]" annotation (
      Dialog(tab="Kinetics", group="Input Variables: Neutron Kinetics"));
  input Units.NonDim nu_bar=2.4 "Neutrons per fission" annotation (Dialog(tab="Kinetics",
        group="Input Variables: Neutron Kinetics"));
  input SI.Energy w_f=200e6*1.6022e-19 "Energy released per fission"
    annotation (Dialog(tab="Kinetics", group="Input Variables: Neutron Kinetics"));
  input SI.Time Lambda=1e-5 "Prompt neutron generation time" annotation (Dialog(
        tab="Kinetics", group="Input Variables: Neutron Kinetics"));

  // Reactivity Feedback
  input TRANSFORM.Units.TempFeedbackCoeff alpha_coolant=-1e-4
    "Temperature feedback coefficient" annotation (Dialog(tab="Kinetics", group=
         "Input Variables: Reactivity Feedback"));
  input SI.Temperature Ts_reference[nV]=fill(500 + 273.15, nV)
    "Temperature feedback reference Temperature" annotation (Dialog(tab="Kinetics",
        group="Input Variables: Reactivity Feedback"));

  // Fission products
  parameter Integer nC=0 "# of fission products"
    annotation (Dialog(tab="Fission Products"));
  parameter Integer nFS=0 "# of fission product sources"
    annotation (Dialog(tab="Fission Products"));
  parameter Real[nC,nC] parents=fill(
      0,
      nC,
      nC)
    "Matrix of parent sources (sum(column) = 1 or 0)for each fission product 'daughter'. Row is daughter, Column is parent."
    annotation (Dialog(tab="Fission Products"));

  input SIadd.NonDim fissionSource[nFS]=fill(0, nFS)
    "Source of fissile material fractional composition (sum=1)"
    annotation (Dialog(tab="Fission Products", group="Input Variables"));
  input SI.MacroscopicCrossSection SigmaF=0.01
    "Macroscopic fission cross-section of fissile material"
    annotation (Dialog(tab="Fission Products", group="Input Variables"));
  input SI.Area[nC] sigmaA_FP = fill(0,nC) "Absorption cross-section for reactivity feedback" annotation (Dialog(tab="Fission Products", group="Input Variables"));

  input Real fissionYield[nC,nFS]=fill(
      0,
      nC,
      nFS)
    "# fission product atoms yielded per fission per fissile source [#/fission]"
    annotation (Dialog(tab="Fission Products", group="Input Variables"));
  input TRANSFORM.Units.InverseTime[nC] lambda_FP=fill(0, nC)
    "Decay constants for each fission product"
    annotation (Dialog(tab="Fission Products", group="Input Variables"));
  input SI.Energy w_FP_decay[nC]=fill(0, nC)
    "Energy released per decay of each fission product [J/decay]"
    annotation (Dialog(tab="Fission Products", group="Input Variables"));
  input SI.Mass[nV,nC] mCs_FP={{0 for j in 1:nC} for i in 1:nV}
    "Fission product concentration in each volume [#]"
    annotation (Dialog(tab="Fission Products", group="Input Variables"));

  // Initialization
  parameter SI.Power Qs_start[nV]=fill(Q_nominal/nV, nV)
    annotation (Dialog(tab="Initialization", enable=not specifyPower));

  // Advanced
  parameter Dynamics energyDynamics=Dynamics.DynamicFreeInitial annotation (
      Dialog(
      tab="Advanced",
      group="Dynamics",
      enable=not specifyPower));

  // Outputs
  output SI.Power Qs[nV](start=Qs_start) "Power determined from kinetics"
    annotation (Dialog(
      tab="Internal Inteface",
      group="Output Variables",
      enable=false));
  output SI.MassFlowRate[nV,nI] mC_gens "Generation rate of precursor groups"
    annotation (Dialog(
      tab="Internal Inteface",
      group="Output Variables",
      enable=false));
  output SI.Power Qs_FP[nV] "Power released from fission product decay"
    annotation (Dialog(
      tab="Internal Inteface",
      group="Output Variables",
      enable=false));
  output SI.MassFlowRate[nV,nC] mC_gens_FP
    "Generation rate of fission products" annotation (Dialog(
      tab="Internal Inteface",
      group="Output Variables",
      enable=false));

  TRANSFORM.Units.NonDim[nV,nC] rhos_FP "Fission product reactivity feedback";
  TRANSFORM.Units.NonDim[nV] rhos "Total reactivity feedback";

initial equation

  if not specifyPower then
    if energyDynamics == Dynamics.FixedInitial then
      Qs = Qs_start;
    elseif energyDynamics == Dynamics.SteadyStateInitial then
      der(Qs) = zeros(nV);
    end if;
  end if;

equation

  rhos = {alpha_coolant* (Ts[i] - Ts_reference[i]) + rhos_input[i] + sum(rhos_FP[i,:]) for i in 1:nV};

  if specifyPower then
    Qs = Qs_input;
  else
    if energyDynamics == Dynamics.SteadyState then
      for i in 1:nV loop
        0 = (rhos[i] - Beta)/Lambda*Qs[i] + w_f/(Lambda*nu_bar)*sum(lambda_i .*
          mCs[i, :]) + Qs_external[i];
      end for;
    else
      for i in 1:nV loop
        der(Qs[i]) = (rhos[i] - Beta)/Lambda*Qs[i] + w_f/(Lambda*nu_bar)*sum(
          lambda_i .* mCs[i, :]) + Qs_external[i];
      end for;
    end if;
  end if;

  mC_gens = {{beta_i[j]*nu_bar/w_f*Qs[i] - lambda_i[j]*mCs[i, j] for j in 1:nI}
    for i in 1:nV};

  // Fission product
  for i in 1:nV loop
    for j in 1:nC loop
      mC_gens_FP[i, j] = Qs[i]/w_f*sum({fissionSource[k]*fissionYield[j, k]
        for k in 1:nFS}) - lambda_FP[j]*mCs_FP[i, j] + sum(lambda_FP .* mCs_FP[
        i, :] .* parents[j, :]) - sigmaA_FP[j]*mCs_FP[i,j]*Qs[i]/(w_f*SigmaF);
      rhos_FP[i,j] = -sigmaA_FP[j]*mCs_FP[i,j]/(nu_bar*SigmaF);
        end for;
  end for;

  Qs_FP = {sum({w_FP_decay[j]*lambda_FP[j]*mCs_FP[i, j] for j in 1:nC}) for i in
        1:nV};

  annotation (
    defaultComponentName="kinetics",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{28,-48.5},{40,-36.5}},
          fillColor={255,0,0},
          fillPattern=FillPattern.Sphere,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Text(
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
          lineColor={0,0,0}),
        Polygon(
          points={{-5,5},{0,-5},{5,5},{-5,5}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={33.5,61},
          rotation=90),
        Rectangle(
          extent={{-0.5,5},{0.5,-5}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={23.5,61},
          rotation=90),
        Rectangle(
          extent={{-0.5,5},{0.5,-5}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={-34.5,61},
          rotation=90),
        Polygon(
          points={{-5,5},{0,-5},{5,5},{-5,5}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={-24.5,61},
          rotation=90),
        Ellipse(
          extent={{-64.5,55},{-52.5,67}},
          fillColor={0,0,255},
          fillPattern=FillPattern.Sphere,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{53.5,55},{65.5,67}},
          fillColor={0,0,255},
          fillPattern=FillPattern.Sphere,
          pattern=LinePattern.None,
          lineColor={0,0,0})}),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end PointKinetics_Drift;
