within TRANSFORM.Blocks.Noise;
model PRBS_nBit

  parameter Real amplitude=1 "Amplitude of signal";
  parameter SI.Frequency freqHz(start=1) "Frequency of signal";
  parameter Real offset=0 "Offset of output signal";
  parameter SI.Time startTime=0 "Output = offset for time < startTime";
  extends Modelica.Blocks.Interfaces.SO;

  parameter Integer seed[:]={1,0,1};
  parameter Integer generator[size(seed, 1) + 1]={1,1,0,1};
  final parameter Integer mls[integer(2^(size(seed, 1)) - 1)]=
      TRANSFORM.Math.max_len_seq(seed, generator);
protected
  Real dy;
  Real i(start=1);

algorithm
  when sample(startTime, 1/freqHz) then
    i := if i + 1 > integer(2^(size(seed, 1)) - 1) then 1 else i + 1;
    dy := amplitude*mls[integer(i)];
  end when;

equation
  y = offset + (if time < startTime then 0 else dy);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
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
              40},{46,40},{46,-40},{66,-40}}, color={0,0,0})}),  Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PRBS_nBit;
