within TRANSFORM.Blocks.Noise;
model PRBS

  parameter Real amplitude=1 "Amplitude of signal";
  parameter SI.Frequency freqHz(start=1) "Frequency of signal";
  parameter Real offset=0 "Offset of output signal";
  parameter SI.Time startTime=0 "Output = offset for time < startTime";
  extends Modelica.Blocks.Interfaces.SO;

  parameter Integer nBits = 3 "Sequence bit length"
    annotation(Dialog(group="Bit Pairing"),
      choices(
        choice=2,
        choice=3,
        choice=4,
        choice=5,
        choice=6,
        choice=7,
        choice=8,
        choice=9,
        choice=10,
        choice=11,
        choice=12,
        choice=13,
        choice=14,
        choice=15));
  parameter Integer seed[nBits]=cat(1,{1},fill(0,nBits-2),{1})
    "Seed sequence array of 1 and 0, size(seed) = nBits"
    annotation (Dialog(group="Bit Pairing"));
  parameter Integer generator[nBits+1]=
    if nBits == 2 then {1,1,1}
    elseif nBits == 3 then {1,1,0,1}
    elseif nBits == 4 then {1,1,0,0,1}
    elseif nBits == 5 then {1,0,1,0,0,1}
    elseif nBits == 6 then {1,1,0,0,0,0,1}
    elseif nBits == 7 then {1,1,0,0,0,0,0,1}
    elseif nBits == 8 then {1,0,1,1,1,0,0,0,1}
    elseif nBits == 9 then {1,0,0,0,1,0,0,0,0,1}
    elseif nBits == 10 then {1,0,0,1,0,0,0,0,0,0,1}
    elseif nBits == 11 then {1,0,1,0,0,0,0,0,0,0,0,1}
    elseif nBits == 12 then {1,1,1,0,0,0,0,0,1,0,0,0,1}
    elseif nBits == 13 then {1,1,1,0,0,1,0,0,0,0,0,0,0,1}
    elseif nBits == 14 then {1,1,1,0,0,0,0,0,0,0,0,0,1,0,1}
    elseif nBits == 15 then {1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1}
    else fill(0,nBits+1) "Generator for sequence. size(generator) = nBits+1" annotation (Dialog(group="Bit Pairing"));

  final parameter Integer mls[integer(2^nBits - 1)]=
      TRANSFORM.Math.max_len_seq(seed,generator);

protected
  Real dy;
  Real i(start=1);

algorithm
  when sample(startTime, 1/freqHz) then
    dy := amplitude*mls[integer(i)];
    i := if i + 1 > integer(2^nBits - 1) then 1 else i + 1;
  end when;

equation

  assert(sum(generator) > 0, "Unsupported nBits and/or generator sequence specified");

  y = offset + (if time < startTime then 0 else dy);

  annotation (
    defaultComponentName="sequencer",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Line(points={{-80,68},{-80,-80}}, color={192,192,192}),
        Line(points={{-90,-70},{68,-70}}, color={192,192,192}),
        Polygon(
          points={{90,-70},{68,-62},{68,-78},{90,-70}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,-40},{-22,-40},{-22,40},{-6,40},{-6,-40},{18,-40},{18,
              40},{46,40},{46,-40},{66,-40}}, color={0,0,0})}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Predefined generator values that give the max length sequence are taken from: https://en.wikipedia.org/wiki/Linear-feedback_shift_register#Some_polynomials_for_maximal_LFSRs</p>
</html>"));
end PRBS;
