within TRANSFORM.Nuclear.ReactorKinetics;
model PointKinetics_L1_atomBased_external_new
  import TRANSFORM;

  import TRANSFORM.Types.Dynamics;
  import TRANSFORM.Math.fillArray_1D;

  parameter Integer nV=1 "# of discrete volumes";

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

  // Inputs
  input SI.Power Qs_fission_input=Q_nominal
    "Fission power (if specifyPower=true)"
    annotation (Dialog(group="Inputs", enable=specifyPower));
  input Units.InverseTime Ns_external=0
    "Rate of neutrons added from an external neutron source"
    annotation (Dialog(group="Inputs"));
  input Units.NonDim rhos_input=0 "External Reactivity"
    annotation (Dialog(group="Inputs"));
  input SI.Volume[nV] Vs
    "Volume for atom concentration basis"
    annotation (Dialog(group="Inputs"));
  input SIadd.ExtraPropertyExtrinsic[nV,nC] mCs
    "# of neutron precursors in each volume [atoms]"
    annotation (Dialog(group="Inputs"));
  input SIadd.ExtraPropertyExtrinsic[nV,nFP] mCs_FP={{0 for j in 1:nFP} for i in 1:nV}
    "Fission product number in each volume [atoms]"
    annotation (Dialog(group="Inputs"));

  // Reactivity Feedback
  parameter Integer nFeedback=0
    "# of reactivity feedbacks (alpha*(val-val_ref)"
    annotation (Dialog(tab="Kinetics", group="Inputs: Reactivity Feedback"));
  input Real alphas_feedback[nFeedback]=fill(
      0,
      nFeedback) "Reactivity feedback coefficient (e.g., temperature [1/K])"
    annotation (Dialog(tab="Kinetics", group="Inputs: Reactivity Feedback"));
  input Real vals_feedback[nFeedback]=vals_feedback_reference
    "Variable value for reactivity feedback (e.g. fuel temperature)"
    annotation (Dialog(tab="Kinetics", group="Inputs: Reactivity Feedback"));
  input Real vals_feedback_reference[nFeedback]=fill(
      1,
      nFeedback)
    "Reference value for reactivity feedback (e.g. fuel reference temperature)"
    annotation (Dialog(tab="Kinetics", group="Inputs: Reactivity Feedback"));

  // Neutron Kinetics
  final parameter Integer nC=data.nC "# of delayed-neutron precursors groups";
  input Units.InverseTime dlambdas[nC]=fill(0, nC)
    "Change in decay constants for each precursor group"
    annotation (Dialog(tab="Parameter Change", group="Inputs: Neutron Kinetics"));
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

  // Initialization
   final parameter Units.InverseTime lambdas_start[nC]=data.lambdas
     "Decay constants for each precursor group"
     annotation (Dialog(tab="Initialization", group="Neutron Kinetics"));
   final parameter Units.NonDim alphas_start[nC]=data.alphas
     "Normalized precursor fractions [betas = alphas*Beta]"
     annotation (Dialog(tab="Initialization", group="Neutron Kinetics"));
   final parameter TRANSFORM.Units.NonDim Beta_start=data.Beta
     "Effective delayed neutron fraction [e.g., Beta = sum(beta_i)]"
     annotation (Dialog(tab="Initialization", group="Neutron Kinetics"));
  parameter SI.Time Lambda_start=1e-5 "Prompt neutron generation time"
    annotation (Dialog(tab="Kinetics", group="Neutron Kinetics"));

  final parameter Units.NonDim betas_start[nC]=alphas_start*Beta_start
    "Delayed neutron precursor fractions";

  parameter SI.Power Qs_fission_start=Q_nominal "Initial reactor fission power per volume"
    annotation (Dialog(tab="Initialization"));

  // Advanced
  parameter Dynamics energyDynamics=Dynamics.DynamicFreeInitial
    "Formulation of nuclear kinetics balances"
    annotation (Dialog(tab="Advanced", group="Dynamics"));

  Units.NonDim betas[nC]=alphas*Beta "Delayed neutron precursor fractions";

  TRANSFORM.Units.NonDim[nFeedback] rhos_feedback
    "Linear reactivity feedback";
  TRANSFORM.Units.NonDim rhos "Total reactivity feedback";

  SI.Power Qs[nV] "Power determined from kinetics and decay-heat per volume";
  SI.Power Q_total=sum(Qs) "Total power output, including decay-heat";

  SI.Power Qs_fission(start=Qs_fission_start)
    "Fission power determined from kinetics";
  SI.Power Q_fission_total=Qs_fission
    "Total fission power output, excluding decay-heat";

  SI.Power Qs_decay[nV,nFP] "Decay-heat per fission product per volume";
  SI.Power Qs_decay_total[nV]={sum(Qs_decay[i, :]) for i in 1:nV}
    "Total decay-heat per volume";
  SI.Power Q_decay_total=sum(Qs_decay_total) "Total decay-heat";

//   SIadd.NonDim etas={Qs_decay_total/ max(1,Qs_fission[i]) for i in 1:nV}
//     "Ratio of decay heat to fisson power per volume";
  SIadd.NonDim eta=Q_decay_total/max(1,Q_fission_total)
    "Ratio of decay heat to fisson power";

  TRANSFORM.Nuclear.ReactorKinetics.Reactivity.FissionProducts_externalBalance_withTritium_withDecayHeat_new
                             fissionProducts(
    nV=nV,
    Qs_fission=Qs_fission,
    Vs=Vs,
    fissionSources_start=fissionSources_start,
    nu_bar_start=nu_bar_start,
    w_f_start=w_f_start,
    SigmaF_start=SigmaF_start,
    dfissionSources=dfissionSources,
    dnu_bar=dnu_bar,
    dw_f=dw_f,
    dSigmaF=dSigmaF,
    dsigmasA=dsigmasA,
    dfissionYields=dfissionYields,
    dlambdas=dlambdas_FP,
    redeclare record Data = Data_FP,
    fissionTypes_start=fissionTypes_start,
    dfissionTypes=dfissionTypes,
    dw_near_decay=dw_near_decay,
    dw_far_decay=dw_far_decay,
    redeclare record Data_TR = Data_TR,
    dsigmasA_TR=dsigmasA_TR,
    dsigmasT_TR=dsigmasT_TR,
    dlambdas_TR=dlambdas_TR,
    mCs_TR=mCs_TR,
    mCs=mCs_FP)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  replaceable record Data_FP =
      TRANSFORM.Nuclear.ReactorKinetics.Data.FissionProducts.fissionProducts_0
    constrainedby
    TRANSFORM.Nuclear.ReactorKinetics.Data.FissionProducts.PartialFissionProduct
    "Fission Product Data" annotation (choicesAllMatching=true);

  final parameter Integer nFP=fissionProducts.data.nC "# of fission products"
    annotation (Dialog(tab="Kinetics"));
  final parameter Integer nFS=fissionProducts.data.nFS "# of fission product sources"
    annotation (Dialog(tab="Kinetics"));
  final parameter Integer nT=fissionProducts.data.nT
    "# of fission product types (e.g., fast/thermal)"
    annotation (Dialog(tab="Kinetics"));

  parameter Units.NonDim fissionSources_start[nFS]=fill(1/nFS, nFS)
    "Source of fissile material fractional composition (sum=1)" annotation (
      Dialog(tab="Kinetics", group=
          "Fission Sources"));
  parameter Units.NonDim fissionTypes_start[nFS,nT]=fill(
      1/nT,
      nFS,
      nT)
    "Fraction of fission from each fission type per fission source, sum(row) = 1"
    annotation (Dialog(tab="Kinetics", group=
          "Fission Sources"));
  parameter Units.NonDim nu_bar_start=2.4 "Neutrons per fission" annotation (
      Dialog(tab="Kinetics", group=
          "Fission Sources"));
  parameter SI.Energy w_f_start=200e6*1.6022e-19 "Energy released per fission"
    annotation (Dialog(tab="Kinetics", group=
          "Fission Sources"));

  parameter SI.MacroscopicCrossSection SigmaF_start=1
    "Macroscopic fission cross-section of fissile material" annotation (Dialog(
        tab="Kinetics", group="Fission Sources"));

  input Units.NonDim dfissionSources[nFS]=fill(0, nFS)
    "Change in source of fissile material fractional composition (sum=1)"
    annotation (Dialog(tab="Parameter Change", group=
          "Inputs: Fission Sources"));
  input Units.NonDim dfissionTypes[nFS,nT]=fill(
      0,
      nFS,
      nT)
    "Change in fraction of fission from each fission type per fission source, sum(row) = 1"
    annotation (Dialog(tab="Parameter Change", group=
          "Inputs: Fission Sources"));
  input Units.NonDim dnu_bar=0 "Change in neutrons per fission" annotation (
      Dialog(tab="Parameter Change", group="Inputs: Fission Sources"));
  input SI.Energy dw_f=0 "Change in energy released per fission" annotation (
      Dialog(tab="Parameter Change", group="Inputs: Fission Sources"));
  input SI.MacroscopicCrossSection dSigmaF=0
    "Change in macroscopic fission cross-section of fissile material"
    annotation (Dialog(tab="Parameter Change", group=
          "Inputs: Fission Sources"));

  input SI.Area dsigmasA[nFP]=fill(0, nFP)
    "Change in microscopic absorption cross-section for reactivity feedback"
    annotation (Dialog(tab="Parameter Change", group="Inputs: Fission Products"));
  input Real dfissionYields[nFP,nFS,nT]=fill(
      0,
      nFP,
      nFS,
      nT)
    "Change in # fission product atoms yielded per fission per fissile source [#/fission]"
    annotation (Dialog(tab="Parameter Change", group="Inputs: Fission Products"));
  input Units.InverseTime dlambdas_FP[nFP]=fill(0, nFP)
    "Change in decay constants for each fission product" annotation (Dialog(tab=
         "Parameter Change", group="Inputs: Fission Products"));

  SIadd.ExtraPropertyFlowRate[nV,nC] mC_gens "Generation rate of neutron precursor groups [atoms/s]";

  input SI.Energy dw_near_decay[nFP]=fill(0, nFP)
    "Change in energy released per decay of each fission product [J/decay] (near field - e.g., beta)"
    annotation (Dialog(tab="Parameter Change", group="Inputs: Decay-Heat"));
  input SI.Energy dw_far_decay[nFP]=fill(0, nFP)
    "Change in energy released per decay of each fission product [J/decay] (far field - e.g., gamma)"
    annotation (Dialog(tab="Parameter Change", group="Inputs: Decay-Heat"));

  replaceable record Data_TR =
      TRANSFORM.Nuclear.ReactorKinetics.Data.Tritium.tritium_0 constrainedby
    TRANSFORM.Nuclear.ReactorKinetics.Data.Tritium.PartialTritium "Tritium Contributors Data"                                                                         annotation (
      choicesAllMatching=true);
  final parameter Integer nTR = fissionProducts.data_TR.nC;
  input SI.Area dsigmasA_TR[nTR]=fill(0, fissionProducts.nTR)
    "Change in microscopic absorption cross-section for reactivity feedback"
    annotation (Dialog(tab="Parameter Change", group="Inputs: Tritium Balance"));
  input SI.Area dsigmasT_TR[nTR]=fill(0, fissionProducts.nTR)
    "Change in microscopic absorption cross-section for tritium generation"
    annotation (Dialog(tab="Parameter Change", group="Inputs: Tritium Balance"));
  input TRANSFORM.Units.InverseTime dlambdas_TR[nTR]=fill(0,
      fissionProducts.nTR) "Decay constants for each tritium contributor"
    annotation (Dialog(tab="Parameter Change", group="Inputs: Tritium Balance"));
  input TRANSFORM.Units.ExtraPropertyExtrinsic mCs_TR[nV,nTR]={{0 for j in 1
      :fissionProducts.nTR} for i in 1:fissionProducts.nV}
    "Amount of each contributor to tritium [atoms]" annotation(Dialog(group="Inputs"));

  input SIadd.NonDim SF_mC_gens[nV] = fill(1/nV,nV) "Shape factor for mC_gens" annotation(Dialog(group="Shape Factors"));
  input SIadd.NonDim SF_Qs_fission[nV] = fill(1/nV,nV) "Shape factor for Qs_fission" annotation(Dialog(group="Shape Factors"));

  TRANSFORM.Nuclear.ReactorKinetics.Data.summary_traceSubstances summary_data(
    redeclare record Data_PG = Data,
    redeclare record Data_FP = Data_FP,
    redeclare record Data_TR = Data_TR)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
initial equation

  if not specifyPower then
    if energyDynamics == Dynamics.FixedInitial then
      Qs_fission = Qs_fission_start;
    elseif energyDynamics == Dynamics.SteadyStateInitial then
      der(Qs_fission) = 0;
    end if;
  end if;

equation

  rhos_feedback = {alphas_feedback[j]*(vals_feedback[j] -
    vals_feedback_reference[j]) for j in 1:nFeedback};

  rhos = rhos_input + sum(rhos_feedback[:]) + sum(fissionProducts.rhos[:,:]) + sum(fissionProducts.rhos_TR[:,:]);

  if specifyPower then
    Qs_fission = Qs_fission_input;
  else
    if energyDynamics == Dynamics.SteadyState then
         0 = (rhos - Beta)/Lambda*Qs_fission + sum({fissionProducts.w_f/(Lambda*fissionProducts.nu_bar)*sum(lambdas .*
           mCs[i, :]) for i in 1:nV}) + fissionProducts.w_f/(Lambda*fissionProducts.nu_bar)*Ns_external;
    else
         der(Qs_fission) = (rhos - Beta)/Lambda*Qs_fission + sum({fissionProducts.w_f/(Lambda*fissionProducts.nu_bar)*sum(lambdas .*
           mCs[i, :]) for i in 1:nV}) + fissionProducts.w_f/(Lambda*fissionProducts.nu_bar)*Ns_external;
    end if;
  end if;

  mC_gens = {{betas[j]*fissionProducts.nu_bar/fissionProducts.w_f*Qs_fission*SF_mC_gens[i] - lambdas[j]*mCs[i, j] for j in 1:nC}
    for i in 1:nV};

  for i in 1:nV loop
    Qs_decay[i, :] = fissionProducts.Qs_near_i[i,:];
    Qs[i] = Qs_fission*SF_Qs_fission[i] + sum(Qs_decay[i, :]);
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
end PointKinetics_L1_atomBased_external_new;
