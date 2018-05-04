within TRANSFORM.Nuclear.ReactorKinetics;
model PointKinetics_L1_powerBasedold
  import TRANSFORM;

  import TRANSFORM.Types.Dynamics;
  import TRANSFORM.Math.fillArray_1D;

  parameter Integer nV=1 "# of discrete volumes";
  parameter SI.Power Q_nominal=1e6 "Total nominal reactor power (fission + decay)";
  parameter Boolean specifyPower=false
    "=true to specify power (i.e., no der(P) equation)";

  // Inputs
  input SI.Power Qs_fission_input[nV]=fill(Q_nominal/nV, nV)
    "Fission power (if specifyPower=true)"
    annotation (Dialog(group="Inputs", enable=specifyPower));
  input SI.Power Qs_external[nV]=zeros(nV)
    "Power from external source of neutrons" annotation (Dialog(group="Inputs"));
  input Units.NonDim[nV] rhos_input=zeros(nV) "External Reactivity"
    annotation (Dialog(group="Inputs"));

  // Neutron Kinetics
  parameter Integer nI=6 "# of delayed-neutron precursors groups"
    annotation (Dialog(tab="Initialization", group="Neutron Kinetics"));
  input Units.InverseTime dlambdas[nI]=fill(0, nI)
    "Change in decay constants for each precursor group"
    annotation (Dialog(tab="Kinetics", group="Inputs: Neutron Kinetics"));
  input Units.NonDim dalphas[nI]=fill(0, nI)
    "Change in normalized precursor fractions [betas = alphas*Beta]"
    annotation (Dialog(tab="Kinetics", group="Inputs: Neutron Kinetics"));
  input TRANSFORM.Units.NonDim dBeta=0
    "Change in effective delayed neutron fraction [e.g., Beta = sum(beta_i)]"
    annotation (Dialog(tab="Kinetics", group="Inputs: Neutron Kinetics"));
  input SI.Time dLambda=0 "Change in prompt neutron generation time"
    annotation (Dialog(tab="Kinetics", group="Inputs: Neutron Kinetics"));

  Units.InverseTime lambdas[nI]=lambdas_start + dlambdas
    "Decay constants for each precursor group";
  Units.NonDim alphas[nI]=alphas_start + dalphas
    "Normalized precursor fractions [beta_i = alpha_i*Beta]";
  TRANSFORM.Units.NonDim Beta=Beta_start + dBeta
    "Effective delayed neutron fraction [e.g., Beta = sum(beta_i)]";
  SI.Time Lambda=Lambda_start + dLambda "Prompt neutron generation time";

  // Reactivity Feedback
  parameter Integer nFeedback=1
    "# of reactivity feedbacks (alpha*(val-val_ref)"
    annotation (Dialog(tab="Kinetics", group="Inputs: Reactivity Feedback"));
  input Real alphas_feedback[nV,nFeedback]=fill(
      -1e-4,
      nV,
      nFeedback) "Reactivity feedback coefficient (e.g., temperature [1/K])"
    annotation (Dialog(tab="Kinetics", group="Inputs: Reactivity Feedback"));
  input Real vals_feedback[nV,nFeedback]=vals_feedback_reference
    "Variable value for reactivity feedback (e.g. fuel temperature)"
    annotation (Dialog(tab="Kinetics", group="Inputs: Reactivity Feedback"));
  input Real vals_feedback_reference[nV,nFeedback]=fill(
      500 + 273.15,
      nV,
      nFeedback)
    "Reference value for reactivity feedback (e.g. fuel reference temperature)"
    annotation (Dialog(tab="Kinetics", group="Inputs: Reactivity Feedback"));

  // Decay-heat
  parameter Integer nDH=0 "# of decay-heat groups"
    annotation (Dialog(tab="Initialization",group="Decay-Heat"));
  input Units.InverseTime dlambdas_dh[nDH]=fill(0, nDH)
    "Change in decay constant"
    annotation (Dialog(tab="Kinetics", group="Inputs: Decay-Heat"));
  input Units.NonDim defs_dh[nDH]=fill(0, nDH)
    "Change in effective energy fraction"
    annotation (Dialog(tab="Kinetics", group="Inputs: Decay-Heat"));

  Units.InverseTime lambda_dh[nDH]=lambda_dh_start + dlambdas_dh
    "Decay constant";
  Units.NonDim efs_dh[nDH]=efs_dh_start + defs_dh "Effective energy fraction";

  // Initialization
  parameter Units.InverseTime lambdas_start[nI]=fill(1, nI)
    "Decay constants for each precursor group"
    annotation (Dialog(tab="Initialization", group="Neutron Kinetics"));
  parameter Units.NonDim alphas_start[nI]=fill(1/nI, nI)
    "Normalized precursor fractions [betas = alphas*Beta]"
    annotation (Dialog(tab="Initialization", group="Neutron Kinetics"));
  parameter TRANSFORM.Units.NonDim Beta_start=0.0065
    "Effective delayed neutron fraction [e.g., Beta = sum(beta_i)]"
    annotation (Dialog(tab="Initialization", group="Neutron Kinetics"));
  parameter SI.Time Lambda_start=1e-5 "Prompt neutron generation time"
    annotation (Dialog(tab="Initialization", group="Neutron Kinetics"));

  final parameter Units.NonDim betas_start[nI]=alphas_start*Beta_start
    "Delayed neutron precursor fractions";

  parameter Units.InverseTime lambda_dh_start[nDH]=fill(1, nDH)
    "Decay constant"
    annotation (Dialog(tab="Initialization", group="Decay-Heat"));
  parameter Units.NonDim efs_dh_start[nDH]=fill(0, nDH)
    "Effective energy fraction"
    annotation (Dialog(tab="Initialization", group="Decay-Heat"));

  parameter SI.Power Qs_fission_start[nV]=fill(Q_nominal/nV, nV)/(1 + sum(
      efs_dh_start)) "Initial reactor fission power per volume"
    annotation (Dialog(tab="Initialization"));
  parameter SI.Power[nV,nI] Cs_start={{betas_start[j]/(lambdas_start[j]*
      Lambda_start)*Qs_fission_start[i] for j in 1:nI} for i in 1:nV}
    "Power of the initial delayed-neutron precursor concentrations"
    annotation (Dialog(tab="Initialization",enable=not use_history));

  parameter SI.Energy Es_start[nV,nDH]={{Qs_fission_start[i]*efs_dh_start[j]/
      lambda_dh_start[j] for j in 1:nDH} for i in 1:nV}
    "Initial decay heat group energy per product volume"
    annotation (Dialog(tab="Initialization",enable=not use_history));

  parameter Boolean use_history = false "=true to provide power history" annotation(Dialog(tab="Initialization",group="Decay-Heat"));
  parameter SI.Power[:,2] history = fill(0,0,2) "Power history up to simulation time=0, [t,Q]" annotation(Dialog(tab="Initialization",group="Decay-Heat",enable=use_history));
  parameter Boolean includeDH = false "=true if power history includes decay heat" annotation(Dialog(tab="Initialization",group="Decay-Heat",enable=use_history));

  final parameter SI.Power Cs_start_history[nI](fixed=false);
  final parameter SI.Energy Es_start_history[nDH](fixed=false);

  // Advanced
  parameter Dynamics energyDynamics=Dynamics.DynamicFreeInitial "Formulation of nuclear kinetics balances"
    annotation (Dialog(tab="Advanced", group="Dynamics"));
  parameter Dynamics traceDynamics=energyDynamics "Formulation of neutron precursor balances"
    annotation (Dialog(tab="Advanced", group="Dynamics"));
  parameter Dynamics decayDynamics=energyDynamics "Formulation of decay-heat balances"
    annotation (Dialog(tab="Advanced", group="Dynamics"));

  Units.NonDim betas[nI]=alphas*Beta "Delayed neutron precursor fractions";

  TRANSFORM.Units.NonDim[nV,nFeedback] rhos_feedback
    "Linear reactivity feedback";
  TRANSFORM.Units.NonDim[nV] rhos "Total reactivity feedback";

  SI.Power Qs[nV] "Power determined from kinetics and decay-heat per volume";
  SI.Power Q_total=sum(Qs) "Total power output, including decay-heat";

  SI.Power Qs_fission[nV](start=Qs_fission_start)
    "Fission power determined from kinetics";
  SI.Power Q_fission_total=sum(Qs_fission)
    "Total fission power output, excluding decay-heat";

  SI.Power Qs_decay[nV,nDH] "Decay-heat per group per volume";
  SI.Power Qs_decay_total[nV] = {sum(Qs_decay[i,:]) for i in 1:nV} "Total decay-heat per volume";
  SI.Power Q_decay_total = sum(Qs_decay_total) "Total decay-heat";

  SIadd.NonDim etas[nV] = Qs_decay_total./Qs_fission "Ratio of decay heat to fisson power per volume";
  SIadd.NonDim eta = Q_decay_total/Q_fission_total "Ratio of decay heat to fisson power";

  SI.Power[nV,nI] Cs(start=if use_history then {{Cs_start_history[j] for j in 1:nI} for i in 1:nV} else Cs_start)
    "Power of the delayed-neutron precursor concentration";
  SI.Energy Es[nV,nDH](start=if use_history then {{Es_start_history[j] for j in
            1:nDH} for i in 1:nV} else Es_start)
    "Energy of the decay-heat precursor group";


initial equation

  (Cs_start_history,Es_start_history) =
    TRANSFORM.Nuclear.ReactorKinetics.Functions.Initial_powerBased_powerHistory(
    history,
    lambdas_start,
    alphas_start,
    Beta_start,
    Lambda_start,
    lambda_dh_start,
    efs_dh_start,
    includeDH=includeDH);

  if not specifyPower then
    if energyDynamics == Dynamics.FixedInitial then
      Qs_fission =Qs_fission_start;
    elseif energyDynamics == Dynamics.SteadyStateInitial then
      der(Qs_fission) = zeros(nV);
    end if;
  end if;

  if traceDynamics == Dynamics.FixedInitial then
    if use_history then
      Cs = {{Cs_start_history[j] for j in 1:nI} for i in 1:nV};
    else
      Cs = Cs_start;
    end if;
  elseif traceDynamics == Dynamics.SteadyStateInitial then
    der(Cs) = fill(
      0,
      nV,
      nI);
  end if;

   if decayDynamics == Dynamics.FixedInitial then
    if use_history then
      Es = {{Es_start_history[j] for j in 1:nDH} for i in 1:nV};
    else
      Es =Es_start;
    end if;

   elseif decayDynamics == Dynamics.SteadyStateInitial then
    der(Es) = fill(
      0,
      nV,
      nDH);
   end if;

equation

  rhos_feedback = {{alphas_feedback[i, j]*(vals_feedback[i, j] -
    vals_feedback_reference[i, j]) for j in 1:nFeedback} for i in 1:nV};

  rhos = {sum(rhos_feedback[i, :]) + rhos_input[i] for i in 1:nV};

  if specifyPower then
    Qs_fission =Qs_fission_input;
  else
    if energyDynamics == Dynamics.SteadyState then
      for i in 1:nV loop
        0 =(rhos[i] - Beta)/Lambda*Qs_fission[i] + sum(lambdas .* Cs[i, :]) +
          Qs_external[i]/Lambda;
      end for;
    else
      for i in 1:nV loop
        der(Qs_fission[i]) =(rhos[i] - Beta)/Lambda*Qs_fission[i] + sum(lambdas .*
          Cs[i, :]) + Qs_external[i]/Lambda;
      end for;
    end if;
  end if;

  if traceDynamics == Dynamics.SteadyState then
    for i in 1:nV loop
      zeros(nI) =betas ./ Lambda*Qs_fission[i] - lambdas .* Cs[i, :];
    end for;
  else
    for i in 1:nV loop
      der(Cs[i, :]) =betas ./ Lambda*Qs_fission[i] - lambdas .* Cs[i, :];
    end for;
  end if;

   for i in 1:nV loop
    Qs_decay[i, :] = lambda_dh .* Es[i, :];
    Qs[i] = Qs_fission[i] + sum(Qs_decay[i, :]);
   end for;

   if decayDynamics == Dynamics.SteadyState then
     for i in 1:nV loop
       for j in 1:nDH loop
         0 =efs_dh[j]*Qs_fission[i] - lambda_dh[j]*Es[i, j];
       end for;
     end for;
   else
     for i in 1:nV loop
       for j in 1:nDH loop
        der(Es[i, j]) =efs_dh[j]*Qs_fission[i] - lambda_dh[j]*Es[i, j];
       end for;
     end for;
   end if;

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
end PointKinetics_L1_powerBasedold;