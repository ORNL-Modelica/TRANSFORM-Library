within TRANSFORM.Fluid.Valves.BaseClasses;
model PartialValveBase

    import Modelica.Fluid.Types.CvTypes;
  parameter CvTypes CvData=CvTypes.OpPoint
    "Selection of flow coefficient"
    annotation (Evaluate=true, Dialog(group="Flow coefficient"));
  parameter SI.VolumeFlowRate Av=0 "Av (metric) flow coefficient"
                                   annotation (Dialog(enable=CvData ==
          Modelica.Fluid.Types.CvTypes.Av,
        group="Flow coefficient"));

  parameter Real Kv(unit="m3/h") = 0 "Kv (metric) flow coefficient" annotation (
     Dialog(enable=CvData == Modelica.Fluid.Types.CvTypes.Kv,
        group="Flow coefficient"));
  parameter Real Cv=0 "Cv (US) flow coefficient in USG/min" annotation (Dialog(
        enable=CvData == Modelica.Fluid.Types.CvTypes.Cv,
        group="Flow coefficient"));
  parameter SI.Pressure dp_nom=0.1e5 "Nominal pressure drop"
    annotation (Dialog(group="Nominal operating point"));
  parameter SI.MassFlowRate m_flow_nom=0 "Nominal mass flowrate" annotation (
      Dialog(group="Nominal operating point"));
  parameter SI.Density d_nom=998.56  "Nominal inlet density" annotation (Dialog(group="Nominal operating point"));
  parameter Boolean CheckValve=false "Reverse flow stopped"
    annotation (Dialog(tab="Advanced"));
  parameter Real b=0.01 "Regularization factor"
    annotation (Dialog(tab="Advanced"));
  replaceable function valveCharacteristic =
      Modelica.Fluid.Valves.BaseClasses.ValveCharacteristics.linear
    constrainedby
    Modelica.Fluid.Valves.BaseClasses.ValveCharacteristics.baseFun
    "Inherent flow characteristic"
    annotation(choicesAllMatching=true);

    constant Real Kv2Av = sqrt(998.56)/3600/sqrt(1e5) "Conversion factor";
    constant Real Cv2Av = sqrt(998.56)*3.7854/1000/60/sqrt(1e5/14.5037) "Conversion factor";

protected
    parameter SI.VolumeFlowRate Av_internal(fixed=false,start=0)
    "Av (metric) flow coefficient";

initial equation

  if  CvData == CvTypes.Av then
    Av_internal = Av;
  elseif CvData == CvTypes.Kv then
    Av_internal = Kv2Av*Kv
      "Conversion includes s/h & sqrt(water density * bar/Pa)";
  elseif CvData == CvTypes.Cv then
    Av_internal = Cv2Av*Cv
      "Conversion w. gal/m3/min & sqrt(psi/Pa)";
  elseif CvData == CvTypes.OpPoint then
    Av_internal = m_flow_nom/sqrt(d_nom*dp_nom);
  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialValveBase;
