within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.Cylindrical.SolutionMethods;
model AxVolCentered_2D
  "2-D Axial/Radial | Axially Volume Centered | 2nd Order Central Finite Difference"
  import      Modelica.Units.SI;
  import Modelica.Constants.pi;
  extends BaseClasses.Partial_FDCond_Cylinder;
  SI.Length[nR - 1] dr={rs[i + 1] - rs[i] for i in 1:nR - 1}
    "Radial nodal spacing";
  SI.Length[nZ] dz={if i == 1 then 2*zs[i] else 2*(zs[i] - zs[i - 1]) -
      dz[i - 1] for i in 1:nZ} "Axial nodal spacing";
  Real beta_max = max(dr)/min(dz) "Maximum skewness of dr/dz";
  Real beta_min = min(dr)/max(dz) "Minimum skewness of dr/dz";
equation
  /* 

  Energy Equations with Boundary Conditions specified externally.
  dE/dt = q_r + q_(r+dr) + q_z + q_(z+dz) + q'''*V
  where q = -lambda*A*dT/dx

  Format:
  rho_ij*cp_ij*V_ij*der(T_ij) = 
    q_(i-1/2,j)
  + q_(i+1/2,j)
  + q_(i,j-1/2)
  + q_(i,j+1/2)
  + q'''*V_ij
  
  */
if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then
  /* Center Nodes */
    for i in 2:nR - 1 loop
      for j in 2:nZ - 1 loop
        Vs[i, j] = pi*(rs[i]*(dr[i] + dr[i - 1]) + 0.25*(dr[i]*dr[i] - dr[
          i - 1]*dr[i - 1]))*dz[j];
      0 =-0.5*(lambda[i, j] + lambda[i - 1, j])*2*pi*(rs[i] - 0.5*dr[i - 1])
          *dz[j]*(Ts[i, j] - Ts[i - 1, j])/dr[i - 1] - 0.5*(lambda[i, j] +
          lambda[i + 1, j])*2*pi*(rs[i] + 0.5*dr[i])*dz[j]*(Ts[i, j] - Ts[
          i + 1, j])/dr[i] - 0.5*(lambda[i, j] + lambda[i, j - 1])*pi*(rs[
          i]*(dr[i] + dr[i - 1]) + 0.25*(dr[i]*dr[i] - dr[i - 1]*dr[i - 1]))
          *(Ts[i, j] - Ts[i, j - 1])/(0.5*(dz[j] + dz[j - 1])) - 0.5*(
          lambda[i, j] + lambda[i, j + 1])*pi*(rs[i]*(dr[i] + dr[i - 1]) +
          0.25*(dr[i]*dr[i] - dr[i - 1]*dr[i - 1]))*(Ts[i, j] - Ts[i, j +
          1])/(0.5*(dz[j] + dz[j + 1])) + q_ppp[i, j]*Vs[i, j];
    end for;
  end for;
  /* Inner Edge */
  for i in 1:1 loop
      for j in 2:nZ - 1 loop
      A_inner[j] =2*pi*rs[i]*dz[j];
        Vs[i, j] = pi*(rs[i]*dr[i] + 0.25*dr[i]*dr[i])*dz[j];
        Ts[i, j] = heatPorts_inner[j].T;
      0 =heatPorts_inner[j].Q_flow - 0.5*(lambda[i, j] + lambda[i + 1, j])
          *2*pi*(rs[i] + 0.5*dr[i])*dz[j]*(Ts[i, j] - Ts[i + 1, j])/dr[i] -
          0.5*(lambda[i, j] + lambda[i, j - 1])*pi*(rs[i]*dr[i] + 0.25*dr[
          i]*dr[i])*(Ts[i, j] - Ts[i, j - 1])/(0.5*(dz[j] + dz[j - 1])) -
          0.5*(lambda[i, j] + lambda[i, j + 1])*pi*(rs[i]*dr[i] + 0.25*dr[
          i]*dr[i])*(Ts[i, j] - Ts[i, j + 1])/(0.5*(dz[j] + dz[j + 1])) +
          q_ppp[i, j]*Vs[i, j];
    end for;
  end for;
  /* Outer Edge */
    for i in nR:nR loop
      for j in 2:nZ - 1 loop
      A_outer[j] =2*pi*rs[i]*dz[j];
        Vs[i, j] = pi*(rs[i]*dr[i - 1] - 0.25*dr[i - 1]*dr[i - 1])*dz[j];
        Ts[i, j] = heatPorts_outer[j].T;
      0 =-0.5*(lambda[i, j] + lambda[i - 1, j])*2*pi*(rs[i] - 0.5*dr[i - 1])
          *dz[j]*(Ts[i, j] - Ts[i - 1, j])/dr[i - 1] + heatPorts_outer[j].Q_flow
           - 0.5*(lambda[i, j] + lambda[i, j - 1])*pi*(rs[i]*dr[i - 1] - 0.25
          *dr[i - 1]*dr[i - 1])*(Ts[i, j] - Ts[i, j - 1])/(0.5*(dz[j] +
          dz[j - 1])) - 0.5*(lambda[i, j] + lambda[i, j + 1])*pi*(rs[i]*
          dr[i - 1] - 0.25*dr[i - 1]*dr[i - 1])*(Ts[i, j] - Ts[i, j + 1])/
          (0.5*(dz[j] + dz[j + 1])) + q_ppp[i, j]*Vs[i, j];
    end for;
  end for;
  /* Bottom Edge */
    for i in 2:nR - 1 loop
    for j in 1:1 loop
      A_bottom[i] =pi*(rs[i]*(dr[i] + dr[i - 1]) + 0.25*(dr[i]*dr[i] - dr[
          i - 1]*dr[i - 1]));
        Vs[i, j] = pi*(rs[i]*(dr[i] + dr[i - 1]) + 0.25*(dr[i]*dr[i] - dr[
          i - 1]*dr[i - 1]))*dz[j];
        Ts[i, j] = heatPorts_bottom[i].T;
      0 =-0.5*(lambda[i, j] + lambda[i - 1, j])*2*pi*(rs[i] - 0.5*dr[i - 1])
          *dz[j]*(Ts[i, j] - Ts[i - 1, j])/dr[i - 1] - 0.5*(lambda[i, j] +
          lambda[i + 1, j])*2*pi*(rs[i] + 0.5*dr[i])*dz[j]*(Ts[i, j] - Ts[
          i + 1, j])/dr[i] + heatPorts_bottom[i].Q_flow - 0.5*(lambda[i,
          j] + lambda[i, j + 1])*pi*(rs[i]*(dr[i] + dr[i - 1]) + 0.25*(dr[
          i]*dr[i] - dr[i - 1]*dr[i - 1]))*(Ts[i, j] - Ts[i, j + 1])/(0.5*
          (dz[j] + dz[j + 1])) + q_ppp[i, j]*Vs[i, j];
    end for;
  end for;
  /* Top Edge */
    for i in 2:nR - 1 loop
      for j in nZ:nZ loop
      A_top[i] =pi*(rs[i]*(dr[i] + dr[i - 1]) + 0.25*(dr[i]*dr[i] - dr[i -
          1]*dr[i - 1]));
        Vs[i, j] = pi*(rs[i]*(dr[i] + dr[i - 1]) + 0.25*(dr[i]*dr[i] - dr[
          i - 1]*dr[i - 1]))*dz[j];
        Ts[i, j] = heatPorts_top[i].T;
      0 =-0.5*(lambda[i, j] + lambda[i - 1, j])*2*pi*(rs[i] - 0.5*dr[i - 1])
          *dz[j]*(Ts[i, j] - Ts[i - 1, j])/dr[i - 1] - 0.5*(lambda[i, j] +
          lambda[i + 1, j])*2*pi*(rs[i] + 0.5*dr[i])*dz[j]*(Ts[i, j] - Ts[
          i + 1, j])/dr[i] - 0.5*(lambda[i, j] + lambda[i, j - 1])*pi*(rs[
          i]*(dr[i] + dr[i - 1]) + 0.25*(dr[i]*dr[i] - dr[i - 1]*dr[i - 1]))
          *(Ts[i, j] - Ts[i, j - 1])/(0.5*(dz[j] + dz[j - 1])) +
          heatPorts_top[i].Q_flow + q_ppp[i, j]*Vs[i, j];
    end for;
  end for;
  /* Bottom Inner Corner */
  for i in 1:1 loop
    for j in 1:1 loop
      A_inner[j] =2*pi*rs[i]*dz[j];
      A_bottom[i] =pi*(rs[i]*dr[i] + 0.25*dr[i]*dr[i]);
        Vs[i, j] = pi*(rs[i]*dr[i] + 0.25*dr[i]*dr[i])*dz[j];
        Ts[i, j] = heatPorts_inner[i].T;
      heatPorts_bottom[i].T =Ts[i, j];
      0 =heatPorts_inner[j].Q_flow - 0.5*(lambda[i, j] + lambda[i + 1, j])
          *2*pi*(rs[i] + 0.5*dr[i])*dz[j]*(Ts[i, j] - Ts[i + 1, j])/dr[i] +
          heatPorts_bottom[i].Q_flow - 0.5*(lambda[i, j] + lambda[i, j + 1])
          *pi*(rs[i]*dr[i] + 0.25*dr[i]*dr[i])*(Ts[i, j] - Ts[i, j + 1])/(
          0.5*(dz[j] + dz[j + 1])) + q_ppp[i, j]*Vs[i, j];
    end for;
  end for;
  /* Top Inner Corner */
  for i in 1:1 loop
      for j in nZ:nZ loop
      A_inner[j] =2*pi*rs[i]*dz[j];
      A_top[i] =pi*(rs[i]*dr[i] + 0.25*dr[i]*dr[i]);
        Vs[i, j] = pi*(rs[i]*dr[i] + 0.25*dr[i]*dr[i])*dz[j];
        Ts[i, j] = heatPorts_inner[j].T;
      heatPorts_top[i].T =Ts[i, j];
      0 =heatPorts_inner[j].Q_flow - 0.5*(lambda[i, j] + lambda[i + 1, j])
          *2*pi*(rs[i] + 0.5*dr[i])*dz[j]*(Ts[i, j] - Ts[i + 1, j])/dr[i] -
          0.5*(lambda[i, j] + lambda[i, j - 1])*pi*(rs[i]*dr[i] + 0.25*dr[
          i]*dr[i])*(Ts[i, j] - Ts[i, j - 1])/(0.5*(dz[j] + dz[j - 1])) +
          heatPorts_top[i].Q_flow + q_ppp[i, j]*Vs[i, j];
    end for;
  end for;
  /* Bottom Outer Corner */
    for i in nR:nR loop
    for j in 1:1 loop
      A_outer[j] =2*pi*rs[i]*dz[j];
      A_bottom[i] =pi*(rs[i]*dr[i - 1] - 0.25*dr[i - 1]*dr[i - 1]);
        Vs[i, j] = pi*(rs[i]*dr[i - 1] - 0.25*dr[i - 1]*dr[i - 1])*dz[j];
        Ts[i, j] = heatPorts_outer[j].T;
      heatPorts_bottom[i].T =Ts[i, j];
      0 =-0.5*(lambda[i, j] + lambda[i - 1, j])*2*pi*(rs[i] - 0.5*dr[i - 1])
          *dz[j]*(Ts[i, j] - Ts[i - 1, j])/dr[i - 1] + heatPorts_outer[j].Q_flow
           + heatPorts_bottom[i].Q_flow - 0.5*(lambda[i, j] + lambda[i, j +
          1])*pi*(rs[i]*dr[i - 1] - 0.25*dr[i - 1]*dr[i - 1])*(Ts[i, j] -
          Ts[i, j + 1])/(0.5*(dz[j] + dz[j + 1])) + q_ppp[i, j]*Vs[i, j];
    end for;
  end for;
  /* Top Outer Corner */
    for i in nR:nR loop
      for j in nZ:nZ loop
      A_outer[j] =2*pi*rs[i]*dz[j];
      A_top[i] =pi*(rs[i]*dr[i - 1] - 0.25*dr[i - 1]*dr[i - 1]);
        Vs[i, j] = pi*(rs[i]*dr[i - 1] - 0.25*dr[i - 1]*dr[i - 1])*dz[j];
        Ts[i, j] = heatPorts_outer[j].T;
      heatPorts_top[i].T =Ts[i, j];
      0 =-0.5*(lambda[i, j] + lambda[i - 1, j])*2*pi*(rs[i] - 0.5*dr[i - 1])
          *dz[j]*(Ts[i, j] - Ts[i - 1, j])/dr[i - 1] + heatPorts_outer[j].Q_flow
           - 0.5*(lambda[i, j] + lambda[i, j - 1])*pi*(rs[i]*dr[i - 1] - 0.25
          *dr[i - 1]*dr[i - 1])*(Ts[i, j] - Ts[i, j - 1])/(0.5*(dz[j] +
          dz[j - 1])) + heatPorts_top[i].Q_flow + q_ppp[i, j]*Vs[i, j];
    end for;
  end for;
else
  /* Center Nodes */
    for i in 2:nR - 1 loop
      for j in 2:nZ - 1 loop
        Vs[i, j] = pi*(rs[i]*(dr[i] + dr[i - 1]) + 0.25*(dr[i]*dr[i] - dr[
          i - 1]*dr[i - 1]))*dz[j];
        d[i, j]*cp[i, j]*Vs[i, j]*der(Ts[i, j]) = -0.5*(lambda[i, j] +
          lambda[i - 1, j])*2*pi*(rs[i] - 0.5*dr[i - 1])*dz[j]*(Ts[i, j] -
          Ts[i - 1, j])/dr[i - 1] - 0.5*(lambda[i, j] + lambda[i + 1, j])*
          2*pi*(rs[i] + 0.5*dr[i])*dz[j]*(Ts[i, j] - Ts[i + 1, j])/dr[i] -
          0.5*(lambda[i, j] + lambda[i, j - 1])*pi*(rs[i]*(dr[i] + dr[i -
          1]) + 0.25*(dr[i]*dr[i] - dr[i - 1]*dr[i - 1]))*(Ts[i, j] - Ts[
          i, j - 1])/(0.5*(dz[j] + dz[j - 1])) - 0.5*(lambda[i, j] +
          lambda[i, j + 1])*pi*(rs[i]*(dr[i] + dr[i - 1]) + 0.25*(dr[i]*
          dr[i] - dr[i - 1]*dr[i - 1]))*(Ts[i, j] - Ts[i, j + 1])/(0.5*(
          dz[j] + dz[j + 1])) + q_ppp[i, j]*Vs[i, j];
    end for;
  end for;
  /* Inner Edge */
  for i in 1:1 loop
      for j in 2:nZ - 1 loop
      A_inner[j] =2*pi*rs[i]*dz[j];
        Vs[i, j] = pi*(rs[i]*dr[i] + 0.25*dr[i]*dr[i])*dz[j];
        Ts[i, j] = heatPorts_inner[j].T;
        d[i, j]*cp[i, j]*Vs[i, j]*der(Ts[i, j]) = heatPorts_inner[j].Q_flow
           - 0.5*(lambda[i, j] + lambda[i + 1, j])*2*pi*(rs[i] + 0.5*dr[i])
          *dz[j]*(Ts[i, j] - Ts[i + 1, j])/dr[i] - 0.5*(lambda[i, j] +
          lambda[i, j - 1])*pi*(rs[i]*dr[i] + 0.25*dr[i]*dr[i])*(Ts[i, j] -
          Ts[i, j - 1])/(0.5*(dz[j] + dz[j - 1])) - 0.5*(lambda[i, j] +
          lambda[i, j + 1])*pi*(rs[i]*dr[i] + 0.25*dr[i]*dr[i])*(Ts[i, j] -
          Ts[i, j + 1])/(0.5*(dz[j] + dz[j + 1])) + q_ppp[i, j]*Vs[i, j];
    end for;
  end for;
  /* Outer Edge */
    for i in nR:nR loop
      for j in 2:nZ - 1 loop
      A_outer[j] =2*pi*rs[i]*dz[j];
        Vs[i, j] = pi*(rs[i]*dr[i - 1] - 0.25*dr[i - 1]*dr[i - 1])*dz[j];
        Ts[i, j] = heatPorts_outer[j].T;
        d[i, j]*cp[i, j]*Vs[i, j]*der(Ts[i, j]) = -0.5*(lambda[i, j] +
          lambda[i - 1, j])*2*pi*(rs[i] - 0.5*dr[i - 1])*dz[j]*(Ts[i, j] -
          Ts[i - 1, j])/dr[i - 1] + heatPorts_outer[j].Q_flow - 0.5*(
          lambda[i, j] + lambda[i, j - 1])*pi*(rs[i]*dr[i - 1] - 0.25*dr[
          i - 1]*dr[i - 1])*(Ts[i, j] - Ts[i, j - 1])/(0.5*(dz[j] + dz[j -
          1])) - 0.5*(lambda[i, j] + lambda[i, j + 1])*pi*(rs[i]*dr[i - 1]
           - 0.25*dr[i - 1]*dr[i - 1])*(Ts[i, j] - Ts[i, j + 1])/(0.5*(dz[
          j] + dz[j + 1])) + q_ppp[i, j]*Vs[i, j];
    end for;
  end for;
  /* Bottom Edge */
    for i in 2:nR - 1 loop
    for j in 1:1 loop
      A_bottom[i] =pi*(rs[i]*(dr[i] + dr[i - 1]) + 0.25*(dr[i]*dr[i] - dr[
          i - 1]*dr[i - 1]));
        Vs[i, j] = pi*(rs[i]*(dr[i] + dr[i - 1]) + 0.25*(dr[i]*dr[i] - dr[
          i - 1]*dr[i - 1]))*dz[j];
        Ts[i, j] = heatPorts_bottom[i].T;
        d[i, j]*cp[i, j]*Vs[i, j]*der(Ts[i, j]) = -0.5*(lambda[i, j] +
          lambda[i - 1, j])*2*pi*(rs[i] - 0.5*dr[i - 1])*dz[j]*(Ts[i, j] -
          Ts[i - 1, j])/dr[i - 1] - 0.5*(lambda[i, j] + lambda[i + 1, j])*
          2*pi*(rs[i] + 0.5*dr[i])*dz[j]*(Ts[i, j] - Ts[i + 1, j])/dr[i] +
          heatPorts_bottom[i].Q_flow - 0.5*(lambda[i, j] + lambda[i, j + 1])
          *pi*(rs[i]*(dr[i] + dr[i - 1]) + 0.25*(dr[i]*dr[i] - dr[i - 1]*
          dr[i - 1]))*(Ts[i, j] - Ts[i, j + 1])/(0.5*(dz[j] + dz[j + 1])) +
          q_ppp[i, j]*Vs[i, j];
    end for;
  end for;
  /* Top Edge */
    for i in 2:nR - 1 loop
      for j in nZ:nZ loop
      A_top[i] =pi*(rs[i]*(dr[i] + dr[i - 1]) + 0.25*(dr[i]*dr[i] - dr[i -
          1]*dr[i - 1]));
        Vs[i, j] = pi*(rs[i]*(dr[i] + dr[i - 1]) + 0.25*(dr[i]*dr[i] - dr[
          i - 1]*dr[i - 1]))*dz[j];
        Ts[i, j] = heatPorts_top[i].T;
        d[i, j]*cp[i, j]*Vs[i, j]*der(Ts[i, j]) = -0.5*(lambda[i, j] +
          lambda[i - 1, j])*2*pi*(rs[i] - 0.5*dr[i - 1])*dz[j]*(Ts[i, j] -
          Ts[i - 1, j])/dr[i - 1] - 0.5*(lambda[i, j] + lambda[i + 1, j])*
          2*pi*(rs[i] + 0.5*dr[i])*dz[j]*(Ts[i, j] - Ts[i + 1, j])/dr[i] -
          0.5*(lambda[i, j] + lambda[i, j - 1])*pi*(rs[i]*(dr[i] + dr[i -
          1]) + 0.25*(dr[i]*dr[i] - dr[i - 1]*dr[i - 1]))*(Ts[i, j] - Ts[
          i, j - 1])/(0.5*(dz[j] + dz[j - 1])) + heatPorts_top[i].Q_flow +
          q_ppp[i, j]*Vs[i, j];
    end for;
  end for;
  /* Bottom Inner Corner */
  for i in 1:1 loop
    for j in 1:1 loop
      A_inner[j] =2*pi*rs[i]*dz[j];
      A_bottom[i] =pi*(rs[i]*dr[i] + 0.25*dr[i]*dr[i]);
        Vs[i, j] = pi*(rs[i]*dr[i] + 0.25*dr[i]*dr[i])*dz[j];
        Ts[i, j] = heatPorts_inner[i].T;
      heatPorts_bottom[i].T =Ts[i, j];
        d[i, j]*cp[i, j]*Vs[i, j]*der(Ts[i, j]) = heatPorts_inner[j].Q_flow
           - 0.5*(lambda[i, j] + lambda[i + 1, j])*2*pi*(rs[i] + 0.5*dr[i])
          *dz[j]*(Ts[i, j] - Ts[i + 1, j])/dr[i] + heatPorts_bottom[i].Q_flow
           - 0.5*(lambda[i, j] + lambda[i, j + 1])*pi*(rs[i]*dr[i] + 0.25*
          dr[i]*dr[i])*(Ts[i, j] - Ts[i, j + 1])/(0.5*(dz[j] + dz[j + 1]))
           + q_ppp[i, j]*Vs[i, j];
    end for;
  end for;
  /* Top Inner Corner */
  for i in 1:1 loop
      for j in nZ:nZ loop
      A_inner[j] =2*pi*rs[i]*dz[j];
      A_top[i] =pi*(rs[i]*dr[i] + 0.25*dr[i]*dr[i]);
        Vs[i, j] = pi*(rs[i]*dr[i] + 0.25*dr[i]*dr[i])*dz[j];
        Ts[i, j] = heatPorts_inner[j].T;
      heatPorts_top[i].T =Ts[i, j];
        d[i, j]*cp[i, j]*Vs[i, j]*der(Ts[i, j]) = heatPorts_inner[j].Q_flow
           - 0.5*(lambda[i, j] + lambda[i + 1, j])*2*pi*(rs[i] + 0.5*dr[i])
          *dz[j]*(Ts[i, j] - Ts[i + 1, j])/dr[i] - 0.5*(lambda[i, j] +
          lambda[i, j - 1])*pi*(rs[i]*dr[i] + 0.25*dr[i]*dr[i])*(Ts[i, j] -
          Ts[i, j - 1])/(0.5*(dz[j] + dz[j - 1])) + heatPorts_top[i].Q_flow
           + q_ppp[i, j]*Vs[i, j];
    end for;
  end for;
  /* Bottom Outer Corner */
    for i in nR:nR loop
    for j in 1:1 loop
      A_outer[j] =2*pi*rs[i]*dz[j];
      A_bottom[i] =pi*(rs[i]*dr[i - 1] - 0.25*dr[i - 1]*dr[i - 1]);
        Vs[i, j] = pi*(rs[i]*dr[i - 1] - 0.25*dr[i - 1]*dr[i - 1])*dz[j];
        Ts[i, j] = heatPorts_outer[j].T;
      heatPorts_bottom[i].T =Ts[i, j];
        d[i, j]*cp[i, j]*Vs[i, j]*der(Ts[i, j]) = -0.5*(lambda[i, j] +
          lambda[i - 1, j])*2*pi*(rs[i] - 0.5*dr[i - 1])*dz[j]*(Ts[i, j] -
          Ts[i - 1, j])/dr[i - 1] + heatPorts_outer[j].Q_flow +
          heatPorts_bottom[i].Q_flow - 0.5*(lambda[i, j] + lambda[i, j + 1])
          *pi*(rs[i]*dr[i - 1] - 0.25*dr[i - 1]*dr[i - 1])*(Ts[i, j] - Ts[
          i, j + 1])/(0.5*(dz[j] + dz[j + 1])) + q_ppp[i, j]*Vs[i, j];
    end for;
  end for;
  /* Top Outer Corner */
    for i in nR:nR loop
      for j in nZ:nZ loop
      A_outer[j] =2*pi*rs[i]*dz[j];
      A_top[i] =pi*(rs[i]*dr[i - 1] - 0.25*dr[i - 1]*dr[i - 1]);
        Vs[i, j] = pi*(rs[i]*dr[i - 1] - 0.25*dr[i - 1]*dr[i - 1])*dz[j];
        Ts[i, j] = heatPorts_outer[j].T;
      heatPorts_top[i].T =Ts[i, j];
        d[i, j]*cp[i, j]*Vs[i, j]*der(Ts[i, j]) = -0.5*(lambda[i, j] +
          lambda[i - 1, j])*2*pi*(rs[i] - 0.5*dr[i - 1])*dz[j]*(Ts[i, j] -
          Ts[i - 1, j])/dr[i - 1] + heatPorts_outer[j].Q_flow - 0.5*(
          lambda[i, j] + lambda[i, j - 1])*pi*(rs[i]*dr[i - 1] - 0.25*dr[
          i - 1]*dr[i - 1])*(Ts[i, j] - Ts[i, j - 1])/(0.5*(dz[j] + dz[j -
          1])) + heatPorts_top[i].Q_flow + q_ppp[i, j]*Vs[i, j];
    end for;
  end for;
end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), Documentation(info="<html>
<p><span style=\"font-family: MS Shell Dlg 2;\">Below is a representative stencil for the distribution of the nodes and associated stencil. </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Note that the nodes lie are &apos;volume centered&apos; in the axial direction but still lie along the boundaries in the radial direction. </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">This governs the ability, or lack thereof, to use predefined boundary conditions.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">For example, this stencil WILL directly interface with &apos;DynamicPipe&apos; because that requires volume centered Q_flow and T values which this method satisfies.</span></p>
<p><img src=\"modelica://TRANSFORM/../Resources/Images/Thermal/Conduction/FiniteDifference/FD_AxVolCentered_2DCyl.PNG\"/></p>
</html>"));
end AxVolCentered_2D;
