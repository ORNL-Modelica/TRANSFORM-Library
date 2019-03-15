within TRANSFORM.Math.Scratch;
model check_spliceTanh_Derivatives2
  extends TRANSFORM.Icons.Example;

    Real pos;
  Real neg;
  Real dy,dy2;
  Real y,y2;

initial equation
  y = neg;
equation

  pos = -2*time + 2;
  neg = time + 1;

  der(y) = dy;

  dy = TRANSFORM.Math.spliceTanh(
    der(pos),
    der(neg),
    time - 0.3,
    0.1);
  //(y2,dy2) = Modelica.Fluid.Utilities.cubicHermite_withDerivative(time-0.3,0.1,0.2,pos,neg,der(pos),der(neg));
(y2,dy2) = Modelica.Fluid.Utilities.regFun3(time,0.1,0.2,der(pos),der(neg),pos,neg);

  annotation (experiment,             __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>Possible method for smoothing transitioning between two crossing curves.</p>
</html>"));
end check_spliceTanh_Derivatives2;
