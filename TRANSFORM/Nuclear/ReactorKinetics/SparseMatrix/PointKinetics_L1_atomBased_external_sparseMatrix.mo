within TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix;
model PointKinetics_L1_atomBased_external_sparseMatrix
  import TRANSFORM;
  import TRANSFORM.Types.Dynamics;
  import TRANSFORM.Math.fillArray_1D;

  constant String[:] extraPropertiesNames=cat(
      1,
      data.extraPropertiesNames,
      reactivity.data.extraPropertiesNames) "Names of groups";
  constant Real C_nominal[nC + reactivity.nC]=cat(
      1,
      data.C_nominal,
      reactivity.data.C_nominal)
    "Default for the nominal values for the extra properties";

  parameter Integer nV=1 "# of discrete volumes";
  parameter SI.Power Q_nominal=1e6
    "Total nominal reactor power (fission + decay)";
  parameter Boolean specifyPower=false
    "=true to specify power (i.e., no der(P) equation)";
  replaceable record Data =
      TRANSFORM.Nuclear.ReactorKinetics.Data.PrecursorGroups.precursorGroups_6_TRACEdefault
    constrainedby TRANSFORM.Nuclear.ReactorKinetics.Data.PrecursorGroups.PartialPrecursorGroup
    "Neutron Precursor Data" annotation (choicesAllMatching=true);
  Data data;
  // Inputs
  input SI.Power Q_fission_input=Q_nominal
    "Fission power (if specifyPower=true)"
    annotation (Dialog(group="Inputs", enable=specifyPower));
  input TRANSFORM.Units.InverseTime N_external=0
    "Rate of neutrons added from an external neutron source"
    annotation (Dialog(group="Inputs"));
  input TRANSFORM.Units.NonDim rho_input=0 "External Reactivity"
    annotation (Dialog(group="Inputs"));

  input SIadd.ExtraPropertyExtrinsic[nV,nC + reactivity.nC] mCs_all
    "# of tracked substances atoms in each volume | index order is 1) precursors 2) isotopes"
    annotation (Dialog(group="Inputs"));

  SIadd.ExtraPropertyExtrinsic[nV,nC] mCs=mCs_all[:, 1:nC]
    "# of precursor group atoms in each volume";

  // Reactivity Feedback
  parameter Integer nFeedback=0 "# of reactivity feedbacks (alpha*(val-val_ref)"
    annotation (Dialog(tab="Kinetics", group="Inputs: Reactivity Feedback"));
  input Real alphas_feedback[nFeedback]=fill(0, nFeedback)
    "Reactivity feedback coefficient (e.g., temperature [1/K])"
    annotation (Dialog(tab="Kinetics", group="Inputs: Reactivity Feedback"));
  input Real vals_feedback[nFeedback]=vals_feedback_reference
    "Variable value for reactivity feedback (e.g. fuel temperature)"
    annotation (Dialog(tab="Kinetics", group="Inputs: Reactivity Feedback"));
  input Real vals_feedback_reference[nFeedback]=fill(1, nFeedback)
    "Reference value for reactivity feedback (e.g. fuel reference temperature)"
    annotation (Dialog(tab="Kinetics", group="Inputs: Reactivity Feedback"));
  // Neutron Kinetics
  constant Integer nC=data.nC "# of delayed-neutron precursors groups";
  input TRANSFORM.Units.InverseTime dlambdas[nC]=fill(0, nC)
    "Change in decay constants for each precursor group" annotation (Dialog(tab="Parameter Change",
        group="Inputs: Neutron Kinetics"));
  input TRANSFORM.Units.NonDim dalphas[nC]=fill(0, nC)
    "Change in normalized precursor fractions [betas = alphas*Beta]" annotation (
     Dialog(tab="Parameter Change", group="Inputs: Neutron Kinetics"));
  input TRANSFORM.Units.NonDim dBeta=0
    "Change in effective delayed neutron fraction [e.g., Beta = sum(beta_i)]"
    annotation (Dialog(tab="Parameter Change", group="Inputs: Neutron Kinetics"));
  input SI.Time dLambda=0 "Change in prompt neutron generation time" annotation (
     Dialog(tab="Parameter Change", group="Inputs: Neutron Kinetics"));
  TRANSFORM.Units.InverseTime lambdas[nC]=lambdas_start + dlambdas
    "Decay constants for each precursor group";
  TRANSFORM.Units.NonDim alphas[nC]=alphas_start + dalphas
    "Normalized precursor fractions [beta_i = alpha_i*Beta]";
  TRANSFORM.Units.NonDim Beta=Beta_start + dBeta
    "Effective delayed neutron fraction [e.g., Beta = sum(beta_i)]";
  SI.Time Lambda=Lambda_start + dLambda "Prompt neutron generation time";
  // Initialization
  final parameter TRANSFORM.Units.InverseTime lambdas_start[nC]=data.lambdas
    "Decay constants for each precursor group"
    annotation (Dialog(tab="Initialization", group="Neutron Kinetics"));
  final parameter TRANSFORM.Units.NonDim alphas_start[nC]=data.alphas
    "Normalized precursor fractions [betas = alphas*Beta]"
    annotation (Dialog(tab="Initialization", group="Neutron Kinetics"));
  final parameter TRANSFORM.Units.NonDim Beta_start=data.Beta
    "Effective delayed neutron fraction [e.g., Beta = sum(beta_i)]"
    annotation (Dialog(tab="Initialization", group="Neutron Kinetics"));
  parameter SI.Time Lambda_start=1e-5 "Prompt neutron generation time"
    annotation (Dialog(tab="Kinetics", group="Neutron Kinetics"));
  final parameter TRANSFORM.Units.NonDim betas_start[nC]=alphas_start*Beta_start
    "Delayed neutron precursor fractions";
  parameter SI.Power Q_fission_start=Q_nominal "Initial reactor fission power"
    annotation (Dialog(tab="Initialization"));
  // Advanced
  parameter Dynamics energyDynamics=Dynamics.DynamicFreeInitial
    "Formulation of nuclear kinetics balances"
    annotation (Dialog(tab="Advanced", group="Dynamics"));
  TRANSFORM.Units.NonDim betas[nC]=alphas*Beta
    "Delayed neutron precursor fractions";
  TRANSFORM.Units.NonDim[nFeedback] rhos_feedback "Linear reactivity feedback";
  TRANSFORM.Units.NonDim rho "Total reactivity feedback";
  SI.Power Qs[nV] "Power determined from kinetics and decay-heat per volume";
  SI.Power Q_total=sum(Qs) "Total power output, including decay-heat";
  SI.Power Q_fission(start=Q_fission_start)
    "Fission power determined from kinetics";

  parameter Boolean toggle_Reactivity=true
    "=true to include additional reactivity model feedback"
    annotation (Evaluate=true, Dialog(group="Additional Reactivity"));
  parameter Boolean includeDH=false
    "=true to include near decay heat in total power"
    annotation (Evaluate=true, Dialog(group="Additional Reactivity"));

  replaceable model Reactivity =
      TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Reactivity.Isotopes.Distributed.Isotopes_external_sparseMatrix
    constrainedby
    TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Reactivity.Isotopes.Distributed.PartialIsotopesExternal
    "Additional reactivity contributions" annotation (choicesAllMatching=true,
      Dialog(group="Additional Reactivity"));
  Reactivity reactivity(
    final nV=nV,
    final Q_fission=Q_fission,
    final Q_fission_start=Q_fission_start,
    final SF_Q_fission=SF_Q_fission,
    final mCs=mCs_all[:, nC + 1:end])
    annotation (Placement(transformation(extent={{-96,84},{-84,96}})));

  SIadd.ExtraPropertyFlowRate[nV,nC] mC_gens
    "Generation rate of neutron precursor groups [atoms/s]";
  SIadd.ExtraPropertyExtrinsic[nV,nC + reactivity.nC] mC_gens_all=cat(
      2,
      mC_gens,
      reactivity.mC_gens) "Generation rate of all trace substances [atoms/s]";

  input TRANSFORM.Units.NonDim SF_Q_fission[nV]=fill(1/nV, nV)
    "Shape factor for Q_fission, sum() = 1"
    annotation (Dialog(group="Shape Factors"));

  //   Real w_f_nu_bar=200e6*1.6e-19/2.4;
  SI.Energy w_f_nu_bar; // need to update nus[1] to nus[i]

initial equation
  w_f_nu_bar=sum({reactivity.data.w_f[i]*reactivity.data.sigmasF[i]*
      sum(reactivity.mCs[:, reactivity.data.actinideIndex[i]]) for i in 1:reactivity.data.nA})/sum({reactivity.data.nus[
      1]*reactivity.data.sigmasF[i]*sum(reactivity.mCs[:, reactivity.data.actinideIndex[i]]) for i in 1:
      reactivity.data.nA});

  if not specifyPower then
    if energyDynamics == Dynamics.FixedInitial then
      Q_fission = Q_fission_start;
    elseif energyDynamics == Dynamics.SteadyStateInitial then
      der(Q_fission) = 0;
    end if;
  end if;
equation
  w_f_nu_bar=sum({reactivity.data.w_f[i]*reactivity.data.sigmasF[i]*
      sum(reactivity.mCs[:, reactivity.data.actinideIndex[i]]) for i in 1:reactivity.data.nA})/sum({reactivity.data.nus[
      1]*reactivity.data.sigmasF[i]*sum(reactivity.mCs[:, reactivity.data.actinideIndex[i]]) for i in 1:
      reactivity.data.nA});

  rhos_feedback = {alphas_feedback[j]*(vals_feedback[j] -
    vals_feedback_reference[j]) for j in 1:nFeedback};
  rho = rho_input + sum(rhos_feedback[:]) + (if toggle_Reactivity then sum(
    reactivity.rhos[:, :]) else 0);
  if specifyPower then
    Q_fission = Q_fission_input;
  else
    if energyDynamics == Dynamics.SteadyState then
      0 = (rho - Beta)/Lambda*Q_fission + sum({w_f_nu_bar/Lambda*sum(lambdas .*
        mCs[i, :]) for i in 1:nV}) + w_f_nu_bar/Lambda*N_external;
    else
      der(Q_fission) = (rho - Beta)/Lambda*Q_fission + sum({w_f_nu_bar/Lambda*
        sum(lambdas .* mCs[i, :]) for i in 1:nV}) + w_f_nu_bar/Lambda*N_external;
    end if;
  end if;
  mC_gens = {{betas[j]*1/w_f_nu_bar*Q_fission*SF_Q_fission[i] - lambdas[j]*mCs[i,
    j] for j in 1:nC} for i in 1:nV};
  for i in 1:nV loop
    Qs[i] = Q_fission*SF_Q_fission[i] + (if includeDH then reactivity.Qs_near[i]
       else 0);
  end for;
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
end PointKinetics_L1_atomBased_external_sparseMatrix;
