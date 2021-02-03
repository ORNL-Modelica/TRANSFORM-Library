within TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix;
model PointKinetics_L1_atomBased_external_sparseMatrix_modular
  import TRANSFORM;
  import TRANSFORM.Types.Dynamics;
  import TRANSFORM.Math.fillArray_1D;

  constant String[:] extraPropertiesNames=cat(1,kinetics.data.extraPropertiesNames,fissionProducts.data.extraPropertiesNames) "Names of groups";
  constant Real C_nominal[nC]=cat(1,kinetics.data.C_nominal,fissionProducts.data.C_nominal) "Default for the nominal values for the extra properties";

  constant Integer nC=nPG + fissionProducts.data.nC "# of total components tracked";
  constant Integer nPG = kinetics.data.nC "# of precursor groups";
  constant Integer nFP = fissionProducts.data.nC "# of fission products";

  parameter Integer nV=1 "# of discrete volumes";
  parameter SI.Power Q_nominal=1e6
    "Total nominal reactor power (fission + decay)";
  parameter Boolean specifyPower=false
    "=true to specify power (i.e., no der(P) equation)";

   replaceable record Data_PG =
      TRANSFORM.Nuclear.ReactorKinetics.Data.PrecursorGroups.precursorGroups_6_TRACEdefault
     constrainedby
    TRANSFORM.Nuclear.ReactorKinetics.Data.PrecursorGroups.PartialPrecursorGroup
     "Neutron Precursor Data" annotation (choicesAllMatching=true);

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
    annotation (Dialog(group="Inputs")); // FP only
  input SIadd.ExtraPropertyExtrinsic[nV,nC] mCs
    "# of neutron precursors in each volume [atoms]"
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
  input TRANSFORM.Units.InverseTime dlambdas[nPG]=fill(0, nPG)
    "Change in decay constants for each precursor group" annotation (Dialog(tab=
         "Parameter Change", group="Inputs: Neutron Kinetics"));
  input TRANSFORM.Units.NonDim dalphas[nPG]=fill(0, nPG)
    "Change in normalized precursor fractions [betas = alphas*Beta]"
    annotation (Dialog(tab="Parameter Change", group="Inputs: Neutron Kinetics"));
  input TRANSFORM.Units.NonDim dBeta=0
    "Change in effective delayed neutron fraction [e.g., Beta = sum(beta_i)]"
    annotation (Dialog(tab="Parameter Change", group="Inputs: Neutron Kinetics"));
  input SI.Time dLambda=0 "Change in prompt neutron generation time"
    annotation (Dialog(tab="Parameter Change", group="Inputs: Neutron Kinetics"));

  // Initialization
  parameter SI.Time Lambda_start=1e-5 "Prompt neutron generation time"
    annotation (Dialog(tab="Kinetics", group="Neutron Kinetics"));
  parameter SI.Power Q_fission_start=Q_nominal
    "Initial reactor fission power"
    annotation (Dialog(tab="Initialization"));

  // Advanced
  parameter Dynamics energyDynamics=Dynamics.DynamicFreeInitial
    "Formulation of nuclear kinetics balances"
    annotation (Dialog(tab="Advanced", group="Dynamics"));

  input TRANSFORM.Units.NonDim nu_bar=2.4 "Neutrons per fission"
    annotation (Dialog(tab="Kinetics", group="Input: Fission Sources"));
  input SI.Energy w_f=200e6*1.6022e-19 "Energy released per fission"
    annotation (Dialog(tab="Kinetics", group="Input: Fission Sources"));
  input SI.MacroscopicCrossSection SigmaF=1
    "Macroscopic fission cross-section of fissile material"
    annotation (Dialog(tab="Kinetics", group="Input: Fission Sources"));

  // Fission Product
  replaceable record Data_FP =
      SparseMatrix.Data.FissionProducts.fissionProducts_0 constrainedby
    SparseMatrix.Data.FissionProducts.PartialFissionProduct
    "Fission Product Data" annotation (choicesAllMatching=true);

  input SI.Area dsigmasA[nFP]=fill(0, nFP)
    "Change in microscopic absorption cross-section for reactivity feedback"
    annotation (Dialog(tab="Parameter Change", group="Inputs: Fission Products"));
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
    "=true to set mC_gen = 0 for fission product indices in i_noGen" annotation (Evaluate=true);
  parameter Integer i_noGen[:]=fissionProducts.data.actinideIndex "Index of fission product to be held constant";

  PointKinetics_L1_atomBased_external_modular kinetics(
    nV=nV,
    Q_nominal=Q_nominal,
    specifyPower=specifyPower,
    redeclare record Data = Data_PG,
    Q_fission_input=Q_fission_input,
    N_external=N_external,
    rho_input=rho_input + sum(fissionProducts.rhos[:, :]),
    mCs=mCs_PG,
    nFeedback=nFeedback,
    alphas_feedback=alphas_feedback,
    vals_feedback=vals_feedback,
    vals_feedback_reference=vals_feedback_reference,
    dlambdas=dlambdas,
    dalphas=dalphas,
    dBeta=dBeta,
    dLambda=dLambda,
    Lambda_start=Lambda_start,
    Q_fission_start=Q_fission_start,
    energyDynamics=energyDynamics,
    SF_Q_fission=SF_Q_fission,
    nu_bar=nu_bar,
    w_f=w_f,
    SigmaF=SigmaF)
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));

  TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Reactivity.FissionProducts_external_withDecayHeat_sparseMatrix
    fissionProducts(
    nV=nV,
    nu_bar=nu_bar,
    w_f=w_f,
    SigmaF=SigmaF,
    Q_fission=kinetics.Q_fission,
    Vs=Vs,
    redeclare record Data = Data_FP,
    mCs=mCs_FP,
    use_noGen=use_noGen,
    i_noGen=i_noGen,
    dw_near_decay=dw_near_decay,
    dw_far_decay=dw_far_decay,
    SF_Q_fission=SF_Q_fission)
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));

  SIadd.ExtraPropertyExtrinsic[nV,nPG] mCs_PG = mCs[:,1:nPG];
  SIadd.ExtraPropertyExtrinsic[nV,nFP] mCs_FP = mCs[:,nPG+1:nC];

  SI.Power Qs_decay[nV]={sum(fissionProducts.Qs_near_i[i, :]) for i in 1:nV}
    "Total decay-heat per volume";
  SI.Power Q_decay=sum(Qs_decay) "Total decay-heat";

  SI.Power Qs[nV] = {kinetics.Qs[i] + Qs_decay[i] for i in 1:nV} "Power determined from kinetics and decay-heat per volume";
  SI.Power Q_total=sum(Qs) "Total power output, including decay-heat";

  SIadd.NonDim eta=Q_decay/max(1, kinetics.Q_fission)
    "Ratio of decay heat to fisson power";

  SIadd.ExtraPropertyFlowRate[nV,nC] mC_gens = cat(2,kinetics.mC_gens,fissionProducts.mC_gens) "Generation rate of neutron precursor groups [atoms/s]";

equation

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
end PointKinetics_L1_atomBased_external_sparseMatrix_modular;
