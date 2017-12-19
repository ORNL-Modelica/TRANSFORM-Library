within TRANSFORM.HeatExchangers.Utilities.Functions;
function logMean_der

//   For small differences a numerically safe approximation is used.
  input Real dTx "Temperature difference 1";
  input Real dTy "Temperature difference 2";
  input Real small_dT =  1.0 "small x or y";
  input Real tol=0.05 "small difference x-y";
  input Real dx "derivatives of Temperature difference 1";
  input Real dy "derivatives of Temperature difference 2";
  output Real dlmTd "derivative of logarithmic mean";
protected
  Real x "absolute value of dTx";
  Real y "absolute value of dTy";
  Real xmy2;
  Real lxy;
  Real lxy2;
  Real minder;
  Real maxder;
  Real minder2;
algorithm
  x := abs(dTx);
  y := abs(dTy);
  lxy := Modelica.Math.log(x/max(Modelica.Constants.small, y));
  lxy2 := lxy*lxy;
  if sign(dTx) <> sign(dTy) then // crossed T-gradients, no use of log-mean
    if dTx < dTy then
      minder := dx;
      maxder := dy;
    else
      minder := dy;
      maxder := dx;
    end if;
    dlmTd := TRANSFORM.Math.spliceTanh_der(0.5*max(dTx,dTy),0, min(dTx,dTy)+small_dT/4,small_dT/4,
             maxder/2, 0, minder, 0);
  else
  if (x > small_dT) and (y > small_dT) and abs(x-y) > tol*max(x,y) then
    dlmTd :=  (1/lxy - (x-y)/(x*lxy2))*dx + ((x-y)/(y*lxy2)-1/lxy)*dy
        "standard logmean expression";
  elseif (abs(x-y) < tol*max(x,y)) then
    xmy2 := (x - y)*(x - y);
    dlmTd := ((dx + dy)*(1 - ((1 - xmy2/(2.0*x*y))*
    xmy2)/(12.0*x*y)))/2.0 + (((dy*(1 - xmy2/(2.0*x*y))*xmy2)/(12.0*x*y*y) -
    ((dx - dy)*(1 - xmy2/(2.0*x*y))*(x - y))/(6.0*x*y) - (((dy*xmy2)/(2.0*x*y
    *y) - ((dx - dy)*(x - y))/(x*y) + (dx*xmy2)/(2.0*x*x*y))*xmy2)/(12.0*x*y)
     + (dx*(1 - xmy2/(2.0*x*y))*xmy2)/(12.0*x*x*y))*(x + y))/2.0;
    elseif ((x < small_dT) or (y < small_dT)) and min(x,y)>0 then
      minder2 := if x < y then dx else dy;
      dlmTd := TRANSFORM.Math.spliceTanh_der(
        sign(dTx)*(x - y)/Modelica.Math.log(x/y),
        0.5*(dTx + dTy),
        min(x, y) - small_dT/2,
        small_dT/2,
        sign(dTx)*(1/lxy - (x - y)/(x*lxy2))*dx + ((x - y)/(y*lxy2) - 1/lxy)*dy,
        (dx + dy)/2,
        minder2,
        0);
    else
      dlmTd := 0.5*(dx + dy);
    end if;
  end if;

end logMean_der;
