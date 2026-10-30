within TRANSFORM.HeatExchangers.Utilities.Functions;
function logMean
  "Calculation of the log mean temperature difference for a heat exchanger"
  extends Modelica.Icons.Function;
   input Real dTx "Temperature difference 1";
   input Real dTy "Temperature difference 2";
   input Real small_dT =  1.0 "small x or y";
   input Real tol=0.05 "small difference x-y";
   output Real lmTd "Logarithmic mean";
protected
   Real x "absolute value of dTx";
   Real y "absolute value of dTy";
algorithm
   x := abs(dTx);
   y := abs(dTy);
   if sign(dTx) <> sign(dTy) then // crossed T-gradients, no use of log-mean
     lmTd := TRANSFORM.Math.spliceTanh(0.5*max(dTx,dTy),0,min(dTx,dTy)+small_dT/4,small_dT/4);
     // lmTd := 0.5*(abs(max(dTx,dTy)) - abs(min(dTx,dTy)));
     // lmTd := sign(max(dTx,dTy))*0.5*abs(x-y) "sign(max()) must be wrong, always positive";
   else
     if ((x > small_dT) and (y > small_dT) and abs(x-y) > tol*max(x,y)) then
       lmTd := sign(dTx)*(x - y)/Modelica.Math.log(x/y)
         "standard logmean expression";
     elseif (abs(x-y) < tol*max(x,y)) then
       lmTd := (x + y)/2*(1 - (x - y)*(x - y)/(12*x*y)*(1 - (x - y)*(x - y)/(12*x*y)));
     elseif ((x < small_dT) or (y < small_dT)) and min(x,y)>0 then
       lmTd := TRANSFORM.Math.spliceTanh(
         sign(dTx)*(x - y)/Modelica.Math.log(x/y),
         0.5*(dTx + dTy),
         min(x, y) - small_dT/2,
         small_dT/2);
     else
       lmTd := 0.5*(dTx + dTy);
     end if;
   end if;
   annotation(derivative(zeroDerivative=small_dT,zeroDerivative=tol)=logMean_der);
end logMean;
