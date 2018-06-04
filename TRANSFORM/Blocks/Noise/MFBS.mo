within TRANSFORM.Blocks.Noise;
model MFBS

  parameter Real amplitude=1 "Amplitude of signal";
  parameter SI.Time period "Period for repeating sequence";
  parameter Real offset=0 "Offset of output signal";
  parameter SI.Time startTime=0 "Output = offset for time < startTime";
  extends Modelica.Blocks.Interfaces.SO;

  parameter Integer weights[:]={1,1,1,1,1,1,1};
  parameter Integer harmonics[size(weights, 1)]={1,2,4,8,16,32,64};

  final parameter SI.Time mls_t[:]= TRANSFORM.Math.max_len_seq__sine_time(weights, harmonics);
  final parameter Real mls0 = mls_t[end];

protected
  Real dy;
  Integer i(start=0);
  Integer j(start=0);
  SI.Time tseq(start=0);

initial equation
  dy = amplitude*mls0;

algorithm
  when sample(startTime, period) then
    j :=j + 1;
    i := 0;
  end when;

  when tseq/period >= mls_t[i+1] then
    i := i + 1;
    dy := amplitude*(mls0 + (if mod(i, 2) == 0 then 0 else -mls0));
  end when;

equation
  if time < startTime then
    tseq = 0;
  else
    tseq = time - startTime - (j - 1)*period;
  end if;

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
        Line(points={{-80,-40},{-70,-40},{-70,40},{-56,40},{-56,-40},{-38,-40},{
              -38,40},{-32,40},{-32,-40},{18,-40},{18,40},{46,40},{46,-40},{66,-40}},
            color={0,0,0})}),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end MFBS;
