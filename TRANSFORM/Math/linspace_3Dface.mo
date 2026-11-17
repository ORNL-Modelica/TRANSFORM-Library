within TRANSFORM.Math;
function linspace_3Dface
  "Create a 3-D array from six face values: faces hold their value, the interior is interpolated"
  extends TRANSFORM.Icons.Function;
  input Real x1 "Face value x[1,:,:]";
  input Real x2 "Face value x[end,:,:]";
  input Real x3 "Face value x[:,1,:]";
  input Real x4 "Face value x[:,end,:]";
  input Real x5 "Face value x[:,:,1]";
  input Real x6 "Face value x[:,:,end]";
  input Integer n1 "# of elements in dimension 1";
  input Integer n2 "# of elements in dimension 2";
  input Integer n3 "# of elements in dimension 3";
  output Real y[n1,n2,n3] "3-D array";
protected
  Real l1[n1]=linspace_1D(x1, x2, n1) "Profile between faces x1 and x2";
  Real l2[n2]=linspace_1D(x3, x4, n2) "Profile between faces x3 and x4";
  Real l3[n3]=linspace_1D(x5, x6, n3) "Profile between faces x5 and x6";
  Integer nDiv=(if n1 > 1 then 1 else 0) + (if n2 > 1 then 1 else 0) + (if n3 > 1
       then 1 else 0) "# of dimensions with more than one element";
  Real s "Sum of the face values an element touches";
  Integer m "# of faces an element touches";
algorithm
  if nDiv == 0 then
    y[1, 1, 1] := (x1 + x2 + x3 + x4 + x5 + x6)/6;
  else
    for iX in 1:n1 loop
      for jY in 1:n2 loop
        for kZ in 1:n3 loop
          s := 0;
          m := 0;
          if n1 > 1 and iX == 1 then
            s := s + x1;
            m := m + 1;
          end if;
          if n1 > 1 and iX == n1 then
            s := s + x2;
            m := m + 1;
          end if;
          if n2 > 1 and jY == 1 then
            s := s + x3;
            m := m + 1;
          end if;
          if n2 > 1 and jY == n2 then
            s := s + x4;
            m := m + 1;
          end if;
          if n3 > 1 and kZ == 1 then
            s := s + x5;
            m := m + 1;
          end if;
          if n3 > 1 and kZ == n3 then
            s := s + x6;
            m := m + 1;
          end if;
          if m > 0 then
            y[iX, jY, kZ] := s/m;
          else
            y[iX, jY, kZ] := ((if n1 > 1 then l1[iX] else 0) + (if n2 > 1 then l2[jY]
               else 0) + (if n3 > 1 then l3[kZ] else 0))/nDiv;
          end if;
        end for;
      end for;
    end for;
  end if;
  annotation (Documentation(info="<html>
<p>The 3-D counterpart of <code>linspace_2Dedge</code> with every edge held. Elements on a face take
that face's value. Elements on an edge or a corner, where faces meet, take the mean of the faces
they touch. Each interior element takes the mean of the three linear profiles between opposite
faces, evaluated at its position.</p>
<p>A dimension with one element has no faces of its own: its two face values are not used, and the
array follows the other dimensions as <code>linspace_2Dedge</code> or <code>linspace_1D</code>
would. With one element in every dimension, the result is the mean of the six values.</p>
</html>"));
end linspace_3Dface;
