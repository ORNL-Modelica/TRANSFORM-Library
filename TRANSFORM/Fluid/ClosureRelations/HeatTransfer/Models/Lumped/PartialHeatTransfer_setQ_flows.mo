within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.Lumped;
partial model PartialHeatTransfer_setQ_flows

  extends PartialHeatTransfer_setT(final flagIdeal=0);

  import Modelica.Constants.sigma;

  parameter Boolean use_RadHT=false "=true to turn on radiative heat transfer"
    annotation (Evaluate=true);
  input SI.Emissivity epsilon=1 "Emissivity"
    annotation (Dialog(group="Inputs", enable=use_RadHT));
  input SI.Emissivity epsilons[nSurfaces]=fill(
      epsilon,
      nSurfaces) "if non-uniform then set"
    annotation (Dialog(group="Inputs", enable=use_RadHT));

  SI.HeatFlowRate Q_flows_radHT[nSurfaces]
    "Radiation heat transfer flow rate";
  SI.HeatFlowRate Qs_add[nSurfaces]=zeros(nSurfaces)
    "Additional sources of heat transfer";

equation

  if use_RadHT then
      for i in 1:nSurfaces loop
        Q_flows_radHT[i] = (Ts_wall[i] - T_fluid)*(surfaceAreas[i]
          *sigma*epsilons[i]*(Ts_wall[i]^2 - T_fluid^2)*(Ts_wall[i]
           - T_fluid));
      end for;
  else
    Q_flows_radHT = zeros(nSurfaces);
  end if;

    for i in 1:nSurfaces loop
      Q_flows[i] = CFs[i]*alphas[i]*surfaceAreas[i]*(Ts_wall[i]
         - T_fluid) + Qs_add[i] + Q_flows_radHT[i];
  end for;


  annotation (defaultComponentName="heatTransfer",Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialHeatTransfer_setQ_flows;
