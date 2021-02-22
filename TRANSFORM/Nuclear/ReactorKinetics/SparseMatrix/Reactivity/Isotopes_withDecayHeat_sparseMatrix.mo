within TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Reactivity;
model Isotopes_withDecayHeat_sparseMatrix
  extends Isotopes_sparseMatrix;
  final parameter SI.Energy w_near_decay_start[nC]=data.w_near_decay
    "Energy released per decay of each isotope [J/decay] (near field - e.g., beta)"
    annotation (Dialog(tab="Initialization", group="Decay-Heat"));
  final parameter SI.Energy w_far_decay_start[nC]=data.w_far_decay
    "Energy released per decay of each isotope [J/decay] (far field - e.g., gamma)"
    annotation (Dialog(tab="Initialization", group="Decay-Heat"));
  input SI.Energy dw_near_decay[nC]=fill(0, nC)
    "Change in energy released per decay of each isotope [J/decay] (near field - e.g., beta)"
    annotation (Dialog(tab="Parameter Change", group="Inputs: Decay-Heat"));
  input SI.Energy dw_far_decay[nC]=fill(0, nC)
    "Change in energy released per decay of each isotope [J/decay] (far field - e.g., gamma)"
    annotation (Dialog(tab="Parameter Change", group="Inputs: Decay-Heat"));
  SI.Energy w_near_decay[nC]=w_near_decay_start+dw_near_decay
    "Energy released per decay of each isotope [J/decay] (near field - e.g., beta)";
  SI.Energy w_far_decay[nC]=w_far_decay_start+dw_far_decay
    "Energy released per decay of each isotope [J/decay] (far field - e.g., gamma)";
  output SI.Power Qs_near
    "Near field (e.g, beta) power released from isotope decay"
    annotation (Dialog(
      tab="Outputs",
      group="Decay-Heat",
      enable=false));
  output SI.Power Qs_far
    "Far field (e.g., gamma) power released from isotope decay"
    annotation (Dialog(
      tab="Outputs",
      group="Decay-Heat",
      enable=false));
protected
  SI.Power Qs_near_i[nC]
    "Near field (e.g, beta) power released from isotope decay (per species)";
  SI.Power Qs_far_i[nC]
    "Far field (e.g., gamma) power released from isotope decay (per species)";
equation
  // Decay power from isotope decay
  Qs_near_i ={w_near_decay[j]*data.lambdas[j]*mCs[j] for j in 1:nC};
  Qs_far_i ={w_far_decay[j]*data.lambdas[j]*mCs[j] for j in 1:nC};
  Qs_near = sum(Qs_near_i[:]);
  Qs_far = sum(Qs_far_i[:]);
  annotation (defaultComponentName="fissionProducts",
Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})));
end Isotopes_withDecayHeat_sparseMatrix;
