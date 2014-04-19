within Buildings.Fluid.Storage;
model StratifiedEnhancedInternalHex
  "A model of a water storage tank with a secondary loop and intenral heat exchanger"
  extends StratifiedEnhanced;

  replaceable package MediumHex =
      Modelica.Media.Interfaces.PartialMedium "Medium in the heat exchanger"
    annotation(Dialog(tab="General", group="Heat exchanger"));

  parameter Modelica.SIunits.Height hHex_a
    "Height of portHex_a of the heat exchanger, measured from tank bottom"
    annotation(Dialog(tab="General", group="Heat exchanger"));

  parameter Modelica.SIunits.Height hHex_b
    "Height of portHex_b of the heat exchanger, measured from tank bottom"
    annotation(Dialog(tab="General", group="Heat exchanger"));

  parameter Integer hexSegMult(min=1) = 2
    "Number of heat exchanger segments in each tank segment"
    annotation(Dialog(tab="General", group="Heat exchanger"));

  parameter Modelica.SIunits.Diameter dExtHex = 0.025
    "Exterior diameter of the heat exchanger pipe"
    annotation(Dialog(group="Heat exchanger"));

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal
    "Heat transfer at nominal conditions"
    annotation(Dialog(tab="General", group="Heat exchanger"));
  parameter Modelica.SIunits.Temperature TTan_nominal
    "Temperature of fluid inside the tank at nominal heat transfer conditions"
    annotation(Dialog(tab="General", group="Heat exchanger"));
  parameter Modelica.SIunits.Temperature THex_nominal
    "Temperature of fluid inside the heat exchanger at nominal heat transfer conditions"
    annotation(Dialog(tab="General", group="Heat exchanger"));
  parameter Real r_nominal(min=0, max=1)=0.5
    "Ratio between coil inside and outside convective heat transfer at nominal heat transfer conditions"
          annotation(Dialog(tab="General", group="Heat exchanger"));

  parameter Modelica.SIunits.MassFlowRate mHex_flow_nominal
    "Nominal mass flow rate through the heat exchanger"
    annotation(Dialog(group="Heat exchanger"));

  parameter Modelica.SIunits.Pressure dpHex_nominal(displayUnit="Pa") = 2500
    "Pressure drop across the heat exchanger at nominal conditions"
    annotation(Dialog(group="Heat exchanger"));

  parameter Boolean computeFlowResistance=true
    "=true, compute flow resistance. Set to false to assume no friction"
    annotation (Dialog(tab="Flow resistance heat exchanger"));

  parameter Boolean from_dp=false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Dialog(tab="Flow resistance heat exchanger"));

  parameter Boolean linearizeFlowResistance=false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation (Dialog(tab="Flow resistance heat exchanger"));

  parameter Real deltaM=0.1
    "Fraction of nominal flow rate where flow transitions to laminar"
    annotation (Dialog(tab="Flow resistance heat exchanger"));

  parameter Modelica.Fluid.Types.Dynamics energyDynamicsHex=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Formulation of energy balance"
    annotation(Evaluate=true, Dialog(tab = "Dynamics heat exchanger", group="Equations"));
  parameter Modelica.Fluid.Types.Dynamics massDynamicsHex=
    energyDynamicsHex "Formulation of mass balance"
    annotation(Evaluate=true, Dialog(tab = "Dynamics heat exchanger", group="Equations"));

  parameter Modelica.SIunits.Length lHex=
    rTan*abs(segHex_a-segHex_b)*Modelica.Constants.pi
    "Approximate length of the heat exchanger"
     annotation(Dialog(tab = "Dynamics heat exchanger", group="Equations"));

  parameter Modelica.SIunits.Area ACroHex=
    (dExtHex^2-(0.8*dExtHex)^2)*Modelica.Constants.pi/4
    "Cross sectional area of the heat exchanger"
    annotation(Dialog(tab = "Dynamics heat exchanger", group="Equations"));

  parameter Modelica.SIunits.SpecificHeatCapacity cHex=490
    "Specific heat capacity of the heat exchanger material"
    annotation(Dialog(tab = "Dynamics heat exchanger", group="Equations"));

  parameter Modelica.SIunits.Density dHex=8000
    "Density of the heat exchanger material"
    annotation(Dialog(tab = "Dynamics heat exchanger", group="Equations"));

  parameter Modelica.SIunits.HeatCapacity CHex=
    ACroHex*lHex*dHex*cHex
    "Capacitance of the heat exchanger without the fluid"
    annotation(Dialog(tab = "Dynamics heat exchanger", group="Equations"));

  Modelica.Fluid.Interfaces.FluidPort_a portHex_a(
    redeclare final package Medium =MediumHex) "Heat exchanger inlet"
   annotation (Placement(transformation(extent={{-110,-48},{-90,-28}}),
                   iconTransformation(extent={{-110,-48},{-90,-28}})));
  Modelica.Fluid.Interfaces.FluidPort_b portHex_b(
     redeclare final package Medium = MediumHex) "Heat exchanger outlet"
   annotation (Placement(transformation(extent={{-110,-90},{-90,-70}}),
        iconTransformation(extent={{-110,-90},{-90,-70}})));

  BaseClasses.IndirectTankHeatExchanger indTanHex(
    final nSeg=nSegHex,
    final CHex=CHex,
    final volHexFlu=volHexFlu,
    final Q_flow_nominal=Q_flow_nominal,
    final TTan_nominal=TTan_nominal,
    final THex_nominal=THex_nominal,
    final r_nominal=r_nominal,
    final dExtHex=dExtHex,
    redeclare final package Medium = Medium,
    redeclare final package MediumHex = MediumHex,
    final dp_nominal=dpHex_nominal,
    final m_flow_nominal=mHex_flow_nominal,
    final energyDynamics=energyDynamicsHex,
    final massDynamics=massDynamicsHex,
    m_flow_small=1e-4*abs(mHex_flow_nominal),
    final computeFlowResistance=computeFlowResistance,
    from_dp=from_dp,
    final linearizeFlowResistance=linearizeFlowResistance,
    final deltaM=deltaM) "Heat exchanger inside the tank"
     annotation (Placement(
        transformation(
        extent={{-10,-15},{10,15}},
        rotation=180,
        origin={-87,32})));

protected
  final parameter Integer segHex_a = nSeg-integer(hHex_a/segHeight)
    "Tank segment in which port a1 of the heat exchanger is located in"
    annotation(Evaluate=true, Dialog(group="Heat exchanger"));

  final parameter Integer segHex_b = nSeg-integer(hHex_b/segHeight)
    "Tank segment in which port b1 of the heat exchanger is located in"
    annotation(Evaluate=true, Dialog(group="Heat exchanger"));

  final parameter Modelica.SIunits.Height segHeight = hTan/nSeg
    "Height of each tank segment (relative to bottom of same segment)";

  final parameter Modelica.SIunits.Length dHHex = abs(hHex_a-hHex_b)
    "Vertical distance between the heat exchanger inlet and outlet";

  final parameter Modelica.SIunits.Volume volHexFlu=
    Modelica.Constants.pi * (0.8*dExtHex)^2/4 *lHex
    "Volume of the heat exchanger";

  final parameter Integer nSegHexTan = abs(segHex_a-segHex_b) + 1
    "Number of tank segments the heat exchanger resides in";

  final parameter Integer nSegHex = nSegHexTan*hexSegMult
    "Number of heat exchanger segments";
initial equation
  assert(hHex_a >= 0 and hHex_a <= hTan,
    "The parameter hHex_a is outside its valid range.");

  assert(hHex_b >= 0 and hHex_b <= hTan,
    "The parameter hHex_b is outside its valid range.");

  assert(dHHex > 0,
    "The parameters hHex_a and hHex_b must not be equal.");
equation
   for j in 1:nSegHexTan loop
     for i in 1:hexSegMult loop
       connect(indTanHex.port[(j-1)*hexSegMult+i], heaPorVol[segHex_a+j-1])
        annotation (Line(
       points={{-87,41.8},{-20,41.8},{-20,-2.22045e-16},{0,-2.22045e-16}},
       color={191,0,0},
       smooth=Smooth.None));
     end for;
   end for;
  connect(portHex_a, indTanHex.port_a) annotation (Line(
      points={{-100,-38},{-74,-38},{-74,32},{-77,32}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(indTanHex.port_b, portHex_b) annotation (Line(
      points={{-97,32},{-100,32},{-100,20},{-76,20},{-76,-80},{-100,-80}},
      color={0,127,255},
      smooth=Smooth.None));

           annotation (Line(
      points={{-73.2,69},{-70,69},{-70,28},{-16,28},{-16,-2.22045e-16},{0,-2.22045e-16}},
      color={191,0,0},
      smooth=Smooth.None), Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-94,-38},{28,-42}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-70,-50},{28,-54}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-94,-78},{-68,-82}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-72,-50},{-68,-80}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-4,-48},{28,-50}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255}),
        Rectangle(
          extent={{-4,-42},{28,-46}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-22,-44},{-2,-48}},
          pattern=LinePattern.None,
          fillColor={255,85,85},
          fillPattern=FillPattern.Solid)}),
              Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
defaultComponentName = "tan",
Documentation(info = "<html>
<p>
This model is an extension of 
<a href=\"Buildings.Fluid.Storage.StratifiedEnhanced\">Buildings.Fluid.Storage.StratifiedEnhanced</a>.
</p>
<p>
The modifications consist of adding a heat exchanger 
and fluid ports to connect to the heat exchanger.
The modifications allow to run a fluid through the tank causing heat transfer to the stored fluid. 
A typical example is a storage tank in a solar hot water system.
</p>
<p>
The heat exchanger model assumes flow through the inside of a helical coil heat exchanger, 
and stagnant fluid on the outside. Parameters are used to describe the 
heat transfer on the inside of the heat exchanger at nominal conditions, and 
geometry of the outside of the heat exchanger. This information is used to compute 
an <i>hA</i>-value for each side of the coil. 
Convection calculations are then performed to identify heat transfer 
between the heat transfer fluid and the fluid in the tank.
</p>
<p>
The location of the heat exchanger can be parameterized as follows:
The parameters <code>hHex_a</code> and <code>hHex_b</code> are the heights
of the heat exchanger ports <code>portHex_a</code> and <code>portHex_b</code>,
measured from the bottom of the tank.
For example, to place the port <code>portHex_b</code> at the bottom of the tank,
set <code>hHexB_b=0</code>.
The parameters <code>hHex_a</code> and <code>hHex_b</code> are then used to provide
a default value for the parameters 
<code>segHex_a</code> and <code>segHex_b</code>, which are the numbers of the tank
segments to which the heat exchanger ports <code>portHex_a</code> and <code>portHex_b</code>
are connected.
</p>
<p>
Optionally, this model computes a dynamic response of the heat exchanger.
This can be configured using the parameters
<code>energyDynamicsHex</code> and 
<code>massDynamicsHex</code>.
For this computation, the fluid volume inside the heat exchanger
and the heat capacity of the heat 
exchanger wall <code>CHex</code> are approximated.
Both depend on the length <code>lHex</code>
of the heat exchanger.
The model provides default values for these
parameters, as well as for the heat exchanger material which is
assumed to be steel. These default values can be overwritten by the user.
The default values for the heat exchanger geometry are computed assuming 
that there is a cylindrical heat exchanger 
made of steel whose diameter is half the diameter of the tank, e.g., 
<i>r<sub>Hex</sub>=r<sub>Tan</sub>/2</i>.
Hence, the length of the heat exchanger is approximated as
<i>l<sub>Hex</sub> = 2 r<sub>Hex</sub> &pi; h = 2 r<sub>Tan</sub>/2 &pi; h</i>,
where <i>h</i> is the distance between the heat exchanger inlet and outlet.
The wall thickness is assumed to be <i>10%</i> of the heat exchanger
outer diameter.
For typical applications, users do not need to change these values.
</p>
<h4>Implementation</h4>
<p>
The heat exchanger is implemented in
<a href=\"Buildings.Fluid.Storage.BaseClasses.IndirectTankHeatExchanger\">
Buildings.Fluid.Storage.BaseClasses.IndirectTankHeatExchanger</a>.
</p>
</html>",
revisions = "<html>
<ul>
<li>
April 18, 2014 by Michael Wetter:<br/>
Added missing ceiling function in computation of <code>botHexSeg</code>.
Without this function, this parameter can take on zero, which is wrong
because the Modelica uses one-based arrays.

Revised the model as the old version required the port<sub>a</sub>
of the heat exchanger to be located higher than port<sub>b</sub>. 
This makes sense if the heat exchanger is used to heat up the tank, 
but not if it is used to cool down a tank, such as in a cooling plant.
The following parameters were changed:
<ol>
<li>Changed <code>hexTopHeight</code> to <code>hHex_a</code>.</li>
<li>Changed <code>hexBotHeight</code> to <code>hHex_b</code>.</li>
<li>Changed <code>topHexSeg</code> to <code>segHex_a</code>,
 and made it protected as this is deduced from <code>hHex_a</code>.</li>
<li>Changed <code>botHexSeg</code> to <code>segHex_b</code>,
 and made it protected as this is deduced from <code>hHex_b</code>.</li>
</ol>
The names of the following ports have been changed:
<ol>
<li>Changed <code>port_a1</code> to <code>portHex_a</code>.</li>
<li>Changed <code>port_b1</code> to <code>portHex_b</code>.</li>
</ol>
The conversion script should update old instances of 
this model automatically in Dymola for all of the above changes.
</li>
<li>
May 10, 2013 by Michael Wetter:<br/>
Removed <code>m_flow_nominal_tank</code> which was not used.
</li>
<li>
January 29, 2013 by Peter Grant:<br/>
First implementation.
</li>
</ul>
</html>"));
end StratifiedEnhancedInternalHex;
