within TRANSFORM.HeatAndMassTransfer.Volumes;
model Volume_Closed

  extends TRANSFORM.Icons.UnderConstruction;

  import Modelica.Fluid.Types.Dynamics;

  parameter Dynamics massDynamics=Dynamics.DynamicFreeInitial
    "Formulation of mass balances"
    annotation (Dialog(tab="Assumptions", group="Dynamics"));
  parameter SI.AbsolutePressure p_start = 1e5 "Pressure"
    annotation (Dialog(tab="Initialization",group="Start Value: Pressure"));

  input SI.Volume V "Volume" annotation(Dialog(group="Inputs"));
  input SI.Temperature T "Temperature" annotation(Dialog(group="Inputs"));
  input SI.MolarFlowRate n_gen = 0 "Internal mole generation" annotation(Dialog(group="Inputs"));

  SI.Concentration C "Concentration";
  Units.Mole n "Moles in volume";

 SI.AbsolutePressure p(stateSelect=StateSelect.prefer,start=p_start) "Pressure";

  Interfaces.MolePort_State port "Flow across boundary" annotation (Placement(
        transformation(extent={{-10,-110},{10,-90}}), iconTransformation(extent=
           {{-10,-110},{10,-90}})));

initial equation
  if massDynamics == Dynamics.SteadyStateInitial then
    der(n) = 0;
  elseif massDynamics == Dynamics.FixedInitial then
    p = p_start;
  end if;

equation

  // Total Quantities
  C = p/(Modelica.Constants.R*T);
  n = C*V;

 // Mass Balance
 if massDynamics == Dynamics.SteadyState then
     0  =port.n_flow  + n_gen;
 else
     der(n)  =port.n_flow  + n_gen;
 end if;

  // Port Definitions
  port.C = C;

  annotation (defaultComponentName="volume",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Polygon(
          points={{0,79},{-20,75},{-40,69},{-52,55},{-58,47},{-68,37},{-72,25},{
              -76,11},{-78,-3},{-76,-19},{-76,-31},{-76,-41},{-70,-53},{-64,-61},
              {-48,-65},{-30,-71},{-18,-71},{-2,-73},{8,-77},{22,-77},{32,-75},{
              42,-69},{54,-63},{56,-61},{66,-49},{68,-41},{70,-39},{72,-23},{76,
              -9},{78,-1},{78,15},{74,27},{66,37},{54,45},{44,53},{36,69},{26,77},
              {0,79}},
          lineColor={0,0,0},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-58,47},{-68,37},{-72,25},{-76,11},{-78,-3},{-76,-19},{-76,-31},
              {-76,-41},{-70,-53},{-64,-61},{-48,-65},{-30,-71},{-18,-71},{-2,-73},
              {8,-77},{22,-77},{32,-75},{42,-69},{54,-63},{42,-65},{40,-65},{30,
              -67},{20,-69},{18,-69},{10,-69},{2,-65},{-12,-61},{-22,-61},{-30,-59},
              {-40,-53},{-50,-43},{-56,-31},{-58,-23},{-58,-13},{-60,-1},{-60,7},
              {-60,19},{-58,29},{-56,31},{-52,39},{-48,47},{-44,57},{-40,69},{-58,
              47}},
          lineColor={0,0,0},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,122},{150,82}},
          textString="%name",
          lineColor={0,0,255})}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Interface and base class for a solid volume able to store energy. The following boundary flow and source terms are part of the energy balance and must be specified in an extending class: </p>
<ul>
<li>Qb_flow: heat flow rate across boundary</li>
<li>Q_gen: internal heat generation, e.g. q_ppp*Volume</li>
</ul>
<p>The component volume, V, is an input that needs to be set in the extending class to complete the model. </p>
</html>"));
end Volume_Closed;
