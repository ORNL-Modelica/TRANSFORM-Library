within TRANSFORM.Nuclear.ReactorKinetics.Reactivity;
model FissionProducts_externalBalance_withTritium_withDecayHeat
  extends FissionProducts_externalBalance_withTritium;
  parameter SI.Energy w_near_decay_start[nC]=data.w_near_decay
    "Energy released per decay of each fission product [J/decay] (near field - e.g., beta)"
    annotation (Dialog(tab="Initialization", group="Decay-Heat"));
  parameter SI.Energy w_far_decay_start[nC]=data.w_far_decay
    "Energy released per decay of each fission product [J/decay] (far field - e.g., gamma)"
    annotation (Dialog(tab="Initialization", group="Decay-Heat"));
  input SI.Energy dw_near_decay[nC]=fill(0, nC)
    "Change in energy released per decay of each fission product [J/decay] (near field - e.g., beta)"
    annotation (Dialog(tab="Parameter Change", group="Inputs: Decay-Heat"));
  input SI.Energy dw_far_decay[nC]=fill(0, nC)
    "Change in energy released per decay of each fission product [J/decay] (far field - e.g., gamma)"
    annotation (Dialog(tab="Parameter Change", group="Inputs: Decay-Heat"));
  SI.Energy w_near_decay[nC]=w_near_decay_start+dw_near_decay
    "Energy released per decay of each fission product [J/decay] (near field - e.g., beta)";
  SI.Energy w_far_decay[nC]=w_far_decay_start+dw_far_decay
    "Energy released per decay of each fission product [J/decay] (far field - e.g., gamma)";
  output SI.Power Qs_near[nV]
    "Near field (e.g, beta) power released from fission product decay"
    annotation (Dialog(
      tab="Outputs",
      group="Decay-Heat",
      enable=false));
  output SI.Power Qs_far[nV]
    "Far field (e.g., gamma) power released from fission product decay"
    annotation (Dialog(
      tab="Outputs",
      group="Decay-Heat",
      enable=false));
protected
  SI.Power Qs_near_i[nV,nC]
    "Near field (e.g, beta) power released from fission product decay (per species per volume)";
  SI.Power Qs_far_i[nV,nC]
    "Far field (e.g., gamma) power released from fission product decay (per species per volume)";
equation
  // Decay power from fission product decay
  Qs_near_i ={{w_near_decay[j]*lambdas[j]*mCs[i, j] for j in 1:nC} for i in 1:
    nV};
  Qs_far_i ={{w_far_decay[j]*lambdas[j]*mCs[i, j] for j in 1:nC} for i in 1:nV};
  Qs_near = {sum(Qs_near_i[i, :]) for i in 1:nV};
  Qs_far = {sum(Qs_far_i[i, :]) for i in 1:nV};
  annotation (defaultComponentName="fissionProducts",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})));
end FissionProducts_externalBalance_withTritium_withDecayHeat;
