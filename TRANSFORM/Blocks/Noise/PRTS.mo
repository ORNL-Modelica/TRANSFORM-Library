within TRANSFORM.Blocks.Noise;
model PRTS

  parameter Real amplitude=1 "Amplitude of signal";
  parameter SI.Frequency freqHz(start=1) "Frequency of signal";
  parameter Real offset=0 "Offset of output signal";
  parameter SI.Time startTime=0 "Output = offset for time < startTime";
  extends Modelica.Blocks.Interfaces.SO;

  parameter Real bias = 0 "Bias from nominal middle value of signal" annotation (Dialog(group="Sequence"));
  parameter Integer nBits = 3 "Sequence bit length"
    annotation(Dialog(group="Sequence"),
      choices(
        choice=3,
        choice=4,
        choice=5,
        choice=6,
        choice=7,
        choice=8));
  parameter Integer seed[nBits]=cat(1,{-1},fill(1,nBits-2),{0})
    "Seed sequence array of -1, 1, and 0, size(seed) = nBits"
    annotation (Dialog(group="Sequence"));
  parameter Integer generator[nBits]=
    if nBits == 3 then {1,2,2}
    elseif nBits == 4 then {2,1,1,1}
    elseif nBits == 5 then {0,2,1,1,2}
    elseif nBits == 6 then {1,1,1,0,1,1}
    elseif nBits == 7 then {2,1,1,1,1,1,2}
    elseif nBits == 8 then {2,1,2,1,2,1,1,1}
    else fill(0,nBits) "Generator for sequence. size(generator) = nBits" annotation (Dialog(group="Sequence"));

  final parameter Real mls[integer(3^nBits - 1)]=
      TRANSFORM.Math.max_len_seq_ternary(seed, generator, bias);
protected
  Real dy;
  Real i(start=1);

algorithm
  when sample(startTime, 1/freqHz) then
    dy := amplitude*mls[integer(i)];
    i := if i + 1 > integer(3^nBits - 1) then 1 else i + 1;
  end when;

equation

  assert(sum(generator) > 0, "Unsupported nBits and/or generator sequence specified");

  y = offset + (if time < startTime then 0 else dy);

  annotation (defaultComponentName="sequencer",
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
        Line(points={{-80,-40},{-54,-40},{-54,40},{-44,40},{-44,0},{-20,0},{-20,
              -40},{18,-40},{18,40},{46,40},{46,-40},{66,-40}},
                                              color={0,0,0})}),  Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PRTS;
