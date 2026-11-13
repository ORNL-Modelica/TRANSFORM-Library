within TRANSFORM.UsersGuide;
class ModelingTips "Modeling tips"
  extends Modelica.Icons.Information;
  annotation (Documentation(info="<html>
<p>Habits that avoid failures which are hard to trace, collected from building and repairing models in TRANSFORM. This page is meant to grow. A tip that proves itself may later become a rule in the Conventions.</p>
<ol>
<li><b>Write geometry as equations, not in an algorithm section.</b> A tool cannot differentiate an algorithm section. A wall whose geometry is computed in one can lose its start temperature, with no warning. A geometry input bound to an array comprehension or to a user function can do the same.</li>
<li><b>Write a guard inline, and choose a bound that changes no physical value.</b> A tool may take a variable's <code>min</code> as proven and remove a guard such as <code>max(T, 0)</code> inside a function. A bound inside the physical range changes real results; choose the one that removes only the false solution.</li>
<li><b>An equation and its inverse use the same smoothing function.</b> Two different smoothings of one relation disagree near the point they smooth.</li>
<li><b>Write a series of conductances linear in the unknown.</b> <code>UA = A/(1/alpha_1 + 1/alpha_2)</code>, not <code>UA = 1/(1/(alpha_1*A) + 1/(alpha_2*A))</code>. The values are equal, but the first is easier for a nonlinear solver when the start value is far from the answer.</li>
<li><b>A fluid node with zero size uses steady-state balances.</b> Dynamic balances on a volume of zero size can keep a model from building.</li>
<li><b>Join two components that each hold a pressure through a flow resistance.</b> When they are joined directly, the tool decides which start value it keeps. If they must be joined directly, give one a fixed start and the other a free start.</li>
<li><b>Check a workaround in every tool the library supports.</b> A guard or a reformulation that works in one tool can do nothing in another.</li>
</ol>
</html>"));
end ModelingTips;
