within TRANSFORM.Nuclear.ReactorKinetics.Reactivity;
model TraceSubstances
  "Trace substances reactivity (i.e., substances in fluid pipes)"

  import Modelica.Fluid.Types.Dynamics;

  // Fission products
  parameter Integer nV=1 "# of discrete volumes";
  parameter Integer nC=0 "# of trace substances";

  input SI.Power Qs_fission[nV]=fill(1e6/nV, nV)
    "Power determined from kinetics. Does not include fission product decay heat"
    annotation (Dialog(group="Inputs"));

  parameter SI.MacroscopicCrossSection SigmaF_start=1
    "Macroscopic fission cross-section of fissile material";
  parameter Units.NonDim nu_bar_start=2.4 "Neutrons per fission";
  parameter SI.Energy w_f_start=200e6*1.6022e-19 "Energy released per fission";

  input SI.MacroscopicCrossSection dSigmaF=0
    "Change in macroscopic fission cross-section of fissile material"
    annotation (Dialog(group="Inputs"));
  input Units.NonDim dnu_bar=0 "Change in neutrons per fission"
    annotation (Dialog(group="Inputs"));
  input SI.Energy dw_f=0 "Change in energy released per fission"
    annotation (Dialog(group="Inputs"));

  SI.MacroscopicCrossSection SigmaF=SigmaF_start+dSigmaF
    "Macroscopic fission cross-section of fissile material";
  Units.NonDim nu_bar=nu_bar_start+dnu_bar
                                          "Neutrons per fission";
  SI.Energy w_f=w_f_start+dw_f "Energy released per fission";

  input SIadd.ExtraPropertyExtrinsic mCs[nV,nC] = fill(0,nV,nC) "Number of atoms" annotation(Dialog(group="Inputs: Trace Substance"));
  input SI.Volume[nV] Vs=fill(0.1, nV)
    "Volume for trace substance concentration basis"
    annotation (Dialog(group="Inputs: Trace Substance"));
  parameter SI.Area sigmasA_start[nC]=fill(0, nC)
    "Microscopic absorption cross-section for reactivity feedback";
  input SI.Area dsigmasA[nC]=fill(0, nC)
    "Change in microscopic absorption cross-section for reactivity feedback"
    annotation (Dialog(group="Inputs: Trace Substance"));
  SI.Area sigmasA[nC]=sigmasA_start+dsigmasA
    "Microscopic absorption cross-section for reactivity feedback";

  SIadd.NeutronFlux phi[nV] "Neutron flux";

  output SIadd.ExtraPropertyFlowRate[nV,nC] mC_gens
    "Generation rate of additional substances [atoms/s] (e.g., Boron in fluid)"
    annotation (Dialog(tab="Outputs", enable=false));
  output SIadd.NonDim rhos[nV,nC] "Additional subtances reactivity feedback"
    annotation (Dialog(tab="Outputs", enable=false));

equation

  // Additional substances from another source
  for i in 1:nV loop
    phi[i] = Qs_fission[i]/(w_f*SigmaF)/Vs[i];
    for j in 1:nC loop
      mC_gens[i, j] =-sigmasA[j]*mCs[i, j]*Qs_fission[i]/(w_f*SigmaF)/Vs[i];
      rhos[i, j] =-sigmasA[j]*mCs[i, j]/(nu_bar*SigmaF)/Vs[i];
    end for;
  end for;

  annotation (defaultComponentName="traceSubstances",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-38,28},{44,-28}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="TS")}));
end TraceSubstances;
