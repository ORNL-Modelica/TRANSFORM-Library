within TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix;
model PointKinetics_L1_powerBased_sparseMatrix
  import TRANSFORM;
  import TRANSFORM.Types.Dynamics;
  import TRANSFORM.Math.fillArray_1D;
  parameter SI.Power Q_nominal=1e6
    "Total nominal reactor power (fission + decay)";
  parameter Boolean specifyPower=false
    "=true to specify power (i.e., no der(P) equation)";
  replaceable record Data =
      TRANSFORM.Nuclear.ReactorKinetics.Data.PrecursorGroups.precursorGroups_6_TRACEdefault
    constrainedby
    TRANSFORM.Nuclear.ReactorKinetics.Data.PrecursorGroups.PartialPrecursorGroup
    "Neutron Precursor Data" annotation (choicesAllMatching=true);
  Data data;
  replaceable record Data_DH =
      TRANSFORM.Nuclear.ReactorKinetics.Data.DecayHeat.decayHeat_0
    constrainedby
    TRANSFORM.Nuclear.ReactorKinetics.Data.DecayHeat.PartialDecayHeat_powerBased
    "Decay-Heat Data" annotation (choicesAllMatching=true);
  Data_DH data_DH;
  // Inputs
  input SI.Power Q_fission_input=Q_nominal
    "Fission power (if specifyPower=true)"
    annotation (Dialog(group="Inputs", enable=specifyPower));
  input SI.Power Q_external=0 "Power from external source of neutrons"
    annotation (Dialog(group="Inputs"));
  input TRANSFORM.Units.NonDim rho_input=0 "External Reactivity"
    annotation (Dialog(group="Inputs"));
  // Reactivity Feedback
  parameter Integer nFeedback=0
    "# of reactivity feedbacks (alpha*(val-val_ref)"
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
  final parameter Integer nC=data.nC "# of delayed-neutron precursors groups";
  input Units.InverseTime dlambdas[nC]=fill(0, nC)
    "Change in decay constants for each precursor group" annotation (Dialog(tab=
         "Parameter Change", group="Inputs: Neutron Kinetics"));
  input Units.NonDim dalphas[nC]=fill(0, nC)
    "Change in normalized precursor fractions [betas = alphas*Beta]"
    annotation (Dialog(tab="Parameter Change", group="Inputs: Neutron Kinetics"));
  input TRANSFORM.Units.NonDim dBeta=0
    "Change in effective delayed neutron fraction [e.g., Beta = sum(beta_i)]"
    annotation (Dialog(tab="Parameter Change", group="Inputs: Neutron Kinetics"));
  input SI.Time dLambda=0 "Change in prompt neutron generation time"
    annotation (Dialog(tab="Parameter Change", group="Inputs: Neutron Kinetics"));
  Units.InverseTime lambdas[nC]=lambdas_start + dlambdas
    "Decay constants for each precursor group";
  Units.NonDim alphas[nC]=alphas_start + dalphas
    "Normalized precursor fractions [beta_i = alpha_i*Beta]";
  TRANSFORM.Units.NonDim Beta=Beta_start + dBeta
    "Effective delayed neutron fraction [e.g., Beta = sum(beta_i)]";
  SI.Time Lambda=Lambda_start + dLambda "Prompt neutron generation time";
  // Decay-heat
  final parameter Integer nDH=data_DH.nC "# of decay-heat groups"
    annotation (Dialog(tab="Kinetics", group="Decay-Heat"));
  input Units.InverseTime dlambdas_dh[nDH]=fill(0, nDH)
    "Change in decay constant"
    annotation (Dialog(tab="Parameter Change", group="Inputs: Decay-Heat"));
  input Units.NonDim defs_dh[nDH]=fill(0, nDH)
    "Change in effective energy fraction"
    annotation (Dialog(tab="Parameter Change", group="Inputs: Decay-Heat"));
  TRANSFORM.Units.InverseTime lambdas_dh[nDH]=lambdas_dh_start + dlambdas_dh
    "Decay constant";
  Units.NonDim efs_dh[nDH]=efs_dh_start + defs_dh "Effective energy fraction";
  // Initialization
  final parameter Units.InverseTime lambdas_start[nC]=data.lambdas
    "Decay constants for each precursor group"
    annotation (Dialog(tab="Kinetics", group="Neutron Kinetics"));
  final parameter Units.NonDim alphas_start[nC]=data.alphas
    "Normalized precursor fractions [betas = alphas*Beta]"
    annotation (Dialog(tab="Kinetics", group="Neutron Kinetics"));
  final parameter TRANSFORM.Units.NonDim Beta_start=data.Beta
    "Effective delayed neutron fraction [e.g., Beta = sum(beta_i)]"
    annotation (Dialog(tab="Kinetics", group="Neutron Kinetics"));
  parameter SI.Time Lambda_start=1e-5 "Prompt neutron generation time"
    annotation (Dialog(tab="Kinetics", group="Neutron Kinetics"));
  final parameter Units.NonDim betas_start[nC]=alphas_start*Beta_start
    "Delayed neutron precursor fractions";
  final parameter TRANSFORM.Units.InverseTime lambdas_dh_start[nDH]=data_DH.lambdas
    "Decay constant" annotation (Dialog(tab="Kinetics", group="Decay-Heat"));
  final parameter Units.NonDim efs_dh_start[nDH]=data_DH.efs
    "Effective energy fraction"
    annotation (Dialog(tab="Kinetics", group="Decay-Heat"));
  parameter SI.Power Q_fission_start=Q_nominal/(1 + sum(efs_dh_start))
    "Initial reactor fission power"
    annotation (Dialog(tab="Initialization"));
  parameter SI.Power[nC] Cs_start={betas_start[j]/(lambdas_start[j]*
      Lambda_start)*Q_fission_start for j in 1:nC}
    "Power of the initial delayed-neutron precursor concentrations"
    annotation (Dialog(tab="Initialization", enable=not use_history));
  parameter SI.Energy Es_start[nDH]={Q_fission_start*efs_dh_start[j]/
      lambdas_dh_start[j] for j in 1:nDH}
    "Initial decay heat group energy"
    annotation (Dialog(tab="Initialization", enable=not use_history));
  parameter Boolean use_history=false "=true to provide power history"
    annotation (Dialog(tab="Kinetics", group="Decay-Heat"));
  parameter SI.Power[:,2] history=fill(
      0,
      0,
      2) "Power history up to simulation time=0, [t,Q]" annotation (Dialog(
      tab="Kinetics",
      group="Decay-Heat",
      enable=use_history));
  parameter Boolean includeDH=false
    "=true if power history includes decay heat" annotation (Dialog(
      tab="Kinetics",
      group="Decay-Heat",
      enable=use_history));
  final parameter SI.Power Cs_start_history[nC](fixed=false);
  final parameter SI.Energy Es_start_history[nDH](fixed=false);
  // Advanced
  parameter Dynamics energyDynamics=Dynamics.DynamicFreeInitial
    "Formulation of nuclear kinetics balances"
    annotation (Dialog(tab="Advanced", group="Dynamics"));
  parameter Dynamics traceDynamics=energyDynamics
    "Formulation of neutron precursor balances"
    annotation (Dialog(tab="Advanced", group="Dynamics"));
  parameter Dynamics decayheatDynamics=energyDynamics
    "Formulation of decay-heat balances"
    annotation (Dialog(tab="Advanced", group="Dynamics"));
  Units.NonDim betas[nC]=alphas*Beta "Delayed neutron precursor fractions";
  TRANSFORM.Units.NonDim[nFeedback] rhos_feedback "Linear reactivity feedback";
  TRANSFORM.Units.NonDim rho "Total reactivity feedback";
  SI.Power Q_total "Total power determined from kinetics and decay-heat";
  SI.Power Q_fission(start=Q_fission_start)
    "Fission power determined from kinetics, excluding decay-heat";
  SI.Power Qs_decay[nDH] "Decay-heat per group";
  SI.Power Q_decay=sum(Qs_decay[:]) "Total decay-heat";
  TRANSFORM.Units.NonDim eta=Q_decay/max(1, Q_fission)
    "Ratio of decay heat to fisson power";
  SI.Power Cs[nC](start=if use_history then {Cs_start_history[j] for j in 1:nC}
         else Cs_start) "Power of the delayed-neutron precursor concentration";
  SI.Energy Es[nDH](start=if use_history then {Es_start_history[j] for j in 1:
        nDH} else Es_start) "Energy of the decay-heat precursor group";
  TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Reactivity.FissionProducts_sparseMatrix
                                                               fissionProducts(
    nu_bar=nu_bar,
    w_f=w_f,
    SigmaF=SigmaF,
    use_noGen=use_noGen,
    i_noGen=i_noGen,
    nC_add=nC_add,
    Q_fission=Q_fission,
    V=V,
    mCs_add=mCs_add,
    Vs_add=Vs_add,
    traceDynamics=fissionProductDynamics,
    redeclare record Data = Data_FP,
    Q_fission_start=Q_fission_start,
    mCs_start=mCs_start_FP,
    sigmasA_add=sigmasA_add)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  replaceable record Data_FP =
      TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Data.FissionProducts.fissionProducts_0
    constrainedby
    TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Data.FissionProducts.PartialFissionProduct
    "Fission Product Data" annotation (choicesAllMatching=true,Dialog(tab="Fission Products"));
  final parameter Integer nFP=fissionProducts.data.nC "# of fission products";

  input TRANSFORM.Units.NonDim nu_bar=2.4 "Neutrons per fission"
    annotation (Dialog(tab="Kinetics", group="Input: Fission Sources"));
  input SI.Energy w_f=200e6*1.6022e-19 "Energy released per fission"
    annotation (Dialog(tab="Kinetics", group="Input: Fission Sources"));
  input SI.MacroscopicCrossSection SigmaF=1
    "Macroscopic fission cross-section of fissile material"
    annotation (Dialog(tab="Kinetics", group="Input: Fission Sources"));

  input SI.Volume V=0.1 "Volume for fisson product concentration basis"
    annotation (Dialog(tab="Fission Products",group="Inputs"));
  parameter SIadd.ExtraPropertyExtrinsic mCs_start_FP[nFP]=zeros(nFP) "Number of fission product atoms per group per volume"
     annotation (Dialog(tab="Fission Products",group="Initialization"));

  parameter Dynamics fissionProductDynamics=traceDynamics
    "Formulation of fission product balances"
    annotation (Evaluate=true, Dialog(tab="Fission Products", group="Advanced"));

  parameter Integer nC_add=0
    "# of additional substances (i.e., trace fluid substances)"  annotation (Dialog(tab="Fission Products",group="Inputs: Additional Reactivity"));
  input SIadd.ExtraPropertyExtrinsic mCs_add[nC_add]=fill(0, nC_add)
    "Number of atoms"  annotation (Evaluate=true,Dialog(tab="Fission Products",group="Inputs: Additional Reactivity"));
  input SI.Volume Vs_add=0.1 "Volume for fisson product concentration basis"
    annotation (Dialog(tab="Fission Products",group="Inputs: Additional Reactivity"));
  input SI.Area sigmasA_add[nC_add]=fill(0, nC_add)
    "Microscopic absorption cross-section for reactivity feedback"
    annotation (Dialog(tab="Fission Products",group="Inputs: Additional Reactivity"));

  parameter Boolean toggle_ReactivityFP=true
    "=true to include fission product reacitivity feedback"
    annotation (Dialog(tab="Fission Products",group="Advanced"));

  parameter Boolean use_noGen=false
    "=true to set mC_gen = 0 for indices in i_noGen" annotation (Evaluate=true,Dialog(tab="Fission Products",group="Advanced"));
  parameter Integer i_noGen[:]=fissionProducts.data.actinideIndex "Index of fission product to be held constant" annotation (Evaluate=true,Dialog(tab="Fission Products",group="Advanced"));

initial equation
  (Cs_start_history,Es_start_history) =
    TRANSFORM.Nuclear.ReactorKinetics.Functions.Initial_powerBased_powerHistory(
    history,
    lambdas_start,
    alphas_start,
    Beta_start,
    Lambda_start,
    lambdas_dh_start,
    efs_dh_start,
    includeDH=includeDH);
  if not specifyPower then
    if energyDynamics == Dynamics.FixedInitial then
      Q_fission =Q_fission_start;
    elseif energyDynamics == Dynamics.SteadyStateInitial then
      der(Q_fission) = 0;
    end if;
  end if;
  if traceDynamics == Dynamics.FixedInitial then
    if use_history then
      Cs = {Cs_start_history[j] for j in 1:nC};
    else
      Cs = Cs_start;
    end if;
  elseif traceDynamics == Dynamics.SteadyStateInitial then
    der(Cs) = fill(0, nC);
  end if;
  if decayheatDynamics == Dynamics.FixedInitial then
    if use_history then
      Es = {Es_start_history[j] for j in 1:nDH};
    else
      Es = Es_start;
    end if;
  elseif decayheatDynamics == Dynamics.SteadyStateInitial then
    der(Es) = fill(0, nDH);
  end if;
equation
  rhos_feedback = {alphas_feedback[j]*(vals_feedback[j] -
    vals_feedback_reference[j]) for j in 1:nFeedback};
  rho = rho_input + sum(rhos_feedback[:]) + (if toggle_ReactivityFP then + sum(fissionProducts.rhos[:]) else 0) + sum(
    fissionProducts.rhos_add[:]);
  // rho = rho_input + sum(rhos_feedback[:]) + (if toggle_ReactivityFP then -sum(
  //   fissionProducts.rhos_start) + sum(fissionProducts.rhos[:]) else 0) + sum(
  //   fissionProducts.rhos_add[:]);
  if specifyPower then
    Q_fission = Q_fission_input;
  else
    if energyDynamics == Dynamics.SteadyState then
      0 =(rho - Beta)/Lambda*Q_fission + sum(lambdas .* Cs[:]) + Q_external/
        Lambda;
    else
      der(Q_fission) =(rho - Beta)/Lambda*Q_fission + sum(lambdas .* Cs[:]) +
        Q_external/Lambda;
    end if;
  end if;
  if traceDynamics == Dynamics.SteadyState then
    zeros(nC) =betas ./ Lambda*Q_fission - lambdas .* Cs[:];
  else
    der(Cs[:]) =betas ./ Lambda*Q_fission - lambdas .* Cs[:];
  end if;
  Qs_decay[:] =lambdas_dh .* Es[:];
  Q_total = Q_fission + sum(Qs_decay[:]);
  if decayheatDynamics == Dynamics.SteadyState then
    for j in 1:nDH loop
      0 =efs_dh[j]*Q_fission - lambdas_dh[j]*Es[j];
    end for;
  else
    for j in 1:nDH loop
      der(Es[j]) =efs_dh[j]*Q_fission - lambdas_dh[j]*Es[j];
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
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>For point kinetics leave nV = 1</p>
</html>"));
end PointKinetics_L1_powerBased_sparseMatrix;
