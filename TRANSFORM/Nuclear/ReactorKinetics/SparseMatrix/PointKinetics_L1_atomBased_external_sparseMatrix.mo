within TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix;
model PointKinetics_L1_atomBased_external_sparseMatrix
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
  input SI.Power Q_fission_input=Q_nominal
    "Fission power (if specifyPower=true)"
    annotation (Dialog(group="Inputs", enable=specifyPower));
  input TRANSFORM.Units.InverseTime N_external=0
    "Rate of neutrons added from an external neutron source"
    annotation (Dialog(group="Inputs"));
  input TRANSFORM.Units.NonDim rho_input=0 "External Reactivity"
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
  input TRANSFORM.Units.InverseTime dlambdas[nC]=fill(0, nC)
    "Change in decay constants for each precursor group" annotation (Dialog(tab=
         "Parameter Change", group="Inputs: Neutron Kinetics"));
  input TRANSFORM.Units.NonDim dalphas[nC]=fill(0, nC)
    "Change in normalized precursor fractions [betas = alphas*Beta]"
    annotation (Dialog(tab="Parameter Change", group="Inputs: Neutron Kinetics"));
  input TRANSFORM.Units.NonDim dBeta=0
    "Change in effective delayed neutron fraction [e.g., Beta = sum(beta_i)]"
    annotation (Dialog(tab="Parameter Change", group="Inputs: Neutron Kinetics"));
  input SI.Time dLambda=0 "Change in prompt neutron generation time"
    annotation (Dialog(tab="Parameter Change", group="Inputs: Neutron Kinetics"));
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
  final parameter TRANSFORM.Units.NonDim betas_start[nC]=alphas_start*
      Beta_start "Delayed neutron precursor fractions";
  parameter SI.Power Q_fission_start=Q_nominal
    "Initial reactor fission power"
    annotation (Dialog(tab="Initialization"));
  // Advanced
  parameter Dynamics energyDynamics=Dynamics.DynamicFreeInitial
    "Formulation of nuclear kinetics balances"
    annotation (Dialog(tab="Advanced", group="Dynamics"));
  TRANSFORM.Units.NonDim betas[nC]=alphas*Beta
    "Delayed neutron precursor fractions";
  TRANSFORM.Units.NonDim[nFeedback] rhos_feedback
    "Linear reactivity feedback";
  TRANSFORM.Units.NonDim rho "Total reactivity feedback";
  SI.Power Qs[nV] "Power determined from kinetics and decay-heat per volume";
  SI.Power Q_total=sum(Qs) "Total power output, including decay-heat";
  SI.Power Q_fission(start=Q_fission_start)
    "Fission power determined from kinetics";
  SI.Power Qs_decay[nV,nFP] "Decay-heat per fission product per volume";
  SI.Power Qs_decay_V[nV]={sum(Qs_decay[i, :]) for i in 1:nV}
    "Total decay-heat per volume";
  SI.Power Q_decay=sum(Qs_decay_V) "Total decay-heat";
  SIadd.NonDim eta=Q_decay/max(1, Q_fission)
    "Ratio of decay heat to fisson power";
  TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Reactivity.FissionProducts_external_withDecayHeat_sparseMatrix
    fissionProducts(
    nV=nV,
    nC=nFP,
    Q_fission=Q_fission,
    Vs=Vs,
    nu_bar=nu_bar,
    w_f=w_f,
    SigmaF=SigmaF,
    redeclare record Data = Data_FP,
    mCs=mCs_FP,
    use_noGen=use_noGen,
    i_noGen=i_noGen,
    dw_near_decay=dw_near_decay,
    dw_far_decay=dw_far_decay,
    SF_Q_fission=SF_Q_fission)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  replaceable record Data_FP =
      TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Data.Isotopes.Isotopes_null
                                                          constrainedby
    TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Data.Isotopes.PartialIsotopes
    "Fission Product Data" annotation (choicesAllMatching=true);
  constant Integer nFP=fissionProducts.data.nC "# of fission products"
    annotation (Dialog(tab="Kinetics"));

  input TRANSFORM.Units.NonDim nu_bar=2.4 "Neutrons per fission"
    annotation (Dialog(tab="Kinetics", group="Input: Fission Sources"));
  input SI.Energy w_f=200e6*1.6022e-19 "Energy released per fission"
    annotation (Dialog(tab="Kinetics", group="Input: Fission Sources"));
  input SI.MacroscopicCrossSection SigmaF=1
    "Macroscopic fission cross-section of fissile material"
    annotation (Dialog(tab="Kinetics", group="Input: Fission Sources"));

  SIadd.ExtraPropertyFlowRate[nV,nC] mC_gens "Generation rate of neutron precursor groups [atoms/s]";
  input SI.Energy dw_near_decay[nFP]=fill(0, nFP)
    "Change in energy released per decay of each fission product [J/decay] (near field - e.g., beta)"
    annotation (Dialog(tab="Parameter Change", group="Inputs: Decay-Heat"));
  input SI.Energy dw_far_decay[nFP]=fill(0, nFP)
    "Change in energy released per decay of each fission product [J/decay] (far field - e.g., gamma)"
    annotation (Dialog(tab="Parameter Change", group="Inputs: Decay-Heat"));

  input TRANSFORM.Units.NonDim SF_Q_fission[nV]=fill(1/nV, nV)
    "Shape factor for Q_fission, sum() = 1"                                                     annotation(Dialog(group=
          "Shape Factors"));

  parameter Boolean use_noGen=false
    "=true to set mC_gen = 0 for indices in i_noGen" annotation (Evaluate=true);
  parameter Integer i_noGen[:]=fissionProducts.data.actinideIndex "Index of fission product to be held constant";

initial equation
  if not specifyPower then
    if energyDynamics == Dynamics.FixedInitial then
      Q_fission = Q_fission_start;
    elseif energyDynamics == Dynamics.SteadyStateInitial then
      der(Q_fission) = 0;
    end if;
  end if;
equation
  rhos_feedback = {alphas_feedback[j]*(vals_feedback[j] -
    vals_feedback_reference[j]) for j in 1:nFeedback};
  rho = rho_input + sum(rhos_feedback[:]) + sum(fissionProducts.rhos[:, :]);// + sum(fissionProducts.rhos_TR[:, :]);
  if specifyPower then
    Q_fission = Q_fission_input;
  else
    if energyDynamics == Dynamics.SteadyState then
         0 =(rho - Beta)/Lambda*Q_fission + sum({fissionProducts.w_f/(Lambda*
        fissionProducts.nu_bar)*sum(lambdas .* mCs[i, :]) for i in 1:nV}) +
        fissionProducts.w_f/(Lambda*fissionProducts.nu_bar)*N_external;
    else
      der(Q_fission) = (rho - Beta)/Lambda*Q_fission + sum({fissionProducts.w_f/
        (Lambda*fissionProducts.nu_bar)*sum(lambdas .* mCs[i, :]) for i in 1:nV})
         + fissionProducts.w_f/(Lambda*fissionProducts.nu_bar)*N_external;
    end if;
  end if;
  mC_gens ={{betas[j]*fissionProducts.nu_bar/fissionProducts.w_f*Q_fission*
    SF_Q_fission[i] - lambdas[j]*mCs[i, j] for j in 1:nC} for i in 1:nV};
  for i in 1:nV loop
    Qs_decay[i, :] = fissionProducts.Qs_near_i[i,:];
    Qs[i] =Q_fission*SF_Q_fission[i] + sum(Qs_decay[i, :]);
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
