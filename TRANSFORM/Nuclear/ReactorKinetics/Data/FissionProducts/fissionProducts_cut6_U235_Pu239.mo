within TRANSFORM.Nuclear.ReactorKinetics.Data.FissionProducts;
record fissionProducts_cut6_U235_Pu239
  "List of cut6 fission products/groups of U-235 and Pu-239 fuel"

extends PartialFissionProduct(
extraPropertiesNames={"1-H-3","53-I-135","54-Xe-135","54-Xe-135m","Gas","Noble Metal","Other","Gas-R-XXL","Noble Metal-R-XXL","Other-R-XXL","Gas-R-XL","Noble Metal-R-XL","Other-R-XL","Gas-R-L","Noble Metal-R-L","Other-R-L","Gas-R-M","Noble Metal-R-M","Other-R-M","Gas-R-S","Noble Metal-R-S","Other-R-S","Gas-R-XS","Noble Metal-R-XS","Other-R-XS"},
fissionSourceNames={"U235","Pu239"},
fissionTypes={"thermal","fast"},
C_nominal=fill(1e14, nC),
fissionYield={if k == 1 then fissionYield_t[i,j] else fissionYield_f[i,j] for k in 1:2, j in 1:nFS, i in 1:nC},
lambdas={1.782833500456991e-09, 2.926153244511758e-05, 2.1065742176025565e-05, 0.0007555561157182748, 0.0, 0.0, 0.0, 4.089311785171998e-08, 2.4011858437829502e-06, 2.75219153049062e-07, 8.3049315446593e-05, 0.0002884167423546703, 6.65495105061339e-05, 0.009642571577346873, 0.006515240085323421, 0.01331012899869826, 0.19659422860964668, 0.17464452866666405, 0.2346357854777284, 3.084831511844773, 1.0488243815915193, 1.5430606522422952, 8.933633670371048, 8.528773273128346, 7.689592595005648},
w_decay=1.6022e-16*{5.682, 335.0, 305.0, 0.0, 0.0, 0.0, 0.0, 680.3911818597797, 520.174423826383, 735.1799937881754, 3044.668572763901, 1436.3314278390824, 2729.4463605408464, 4244.522244510382, 3110.2767562622666, 4059.7029852908654, 5703.005527950799, 5263.451088813442, 5295.247246025478, 6164.046086617568, 5844.524274536724, 8318.320751909454, 8350.644227916744, 10399.152449396082, 9903.847054827249},
wG_decay=1.6022e-16*{12.909, 2293.0, 860.0, 526.56217, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
sigmaA_thermal=1e-28*{0.0, 0.0, 2650000.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
sigmaA_fast=1e-28*{0.0, 0.0, 7600.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
parents=[
[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0];
[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0];
[0.0,1.0,0.0,1.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0];
[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0];
[1.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,0.0,0.0,1.0,0.0,0.0,1.0,0.0,0.0,1.0,0.0,0.0,1.0,0.0,0.0,1.0,0.0,0.0];
[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,0.0,0.0,1.0,0.0,0.0,1.0,0.0,0.0,1.0,0.0,0.0,1.0,0.0,0.0,1.0,0.0];
[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,0.0,0.0,1.0,0.0,0.0,1.0,0.0,0.0,1.0,0.0,0.0,1.0,0.0,0.0,1.0];
[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0];
[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0];
[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0];
[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0];
[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0];
[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0];
[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0];
[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0];
[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,0.0,0.0,0.0,0.0,0.0,0.0];
[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,0.0,0.0,0.0,0.0,0.0];
[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,0.0,0.0,0.0,0.0];
[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,0.0,0.0,0.0];
[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,0.0,0.0];
[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,0.0];
[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0];
[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0];
[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0];
[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]]);

parameter Real[nC,nFS] fissionYield_t=0.01*transpose({
{0.0108, 6.39, 6.61, 1.22, 2.317037169164288, 0.5442990690844448, 0.38445740596933253, 0.026199504961953956, 1.6547331066413535, 1.2349030653563835, 2.281875765012477, 11.671645629611307, 6.838250559582991, 20.345134363823874, 11.42683890850185, 48.11747964851092, 10.465515226089448, 14.070428094229461, 59.16335515158688, 0.14516818016653937, 0.90431995010034, 7.678952017472302, 0.039475023334053005, 5.128770571263429e-05, 0.6889210464215098},
{0.0142, 6.33, 7.36, 1.78, 3.6353958437352047, 1.0597037765272654, 0.41770992270848895, 0.019515372125409075, 2.7910831099644615, 3.4785894578630407, 1.3823791096826212, 11.841489403991782, 11.441849097890469, 13.35872492735801, 29.789742251289553, 49.33470711486394, 3.2267283667551756, 20.434617733662876, 42.38191985420865, 0.20001020563956942, 1.3847555786924082, 3.8039593862661456, 0.009769726463548135, 5.4304603800584205e-06, 0.002804734274558833}});

parameter Real[nC,nFS] fissionYield_f=0.01*transpose({
{0.0108, 6.01, 6.32, 1.23, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
{0.0142, 6.24, 7.5, 1.97, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0}});

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info=""));
end fissionProducts_cut6_U235_Pu239;
