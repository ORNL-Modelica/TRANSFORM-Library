within TRANSFORM.UsersGuide.Conventions;
class References "Citing a source"
  extends Modelica.Icons.Information;
  annotation (Documentation(info="<html>
<p>A statement taken from a source cites it precisely enough that a reader can check a coefficient against the place it came from.</p>
<ul>
<li>Every source has a key in square brackets: the first author's surname and the year, as in <code>[Rennels2012]</code>. A letter is added if two keys would clash.</li>
<li>The same source has the same key in every class, so one search finds every class that uses it.</li>
<li>The entry for a source sits under the heading \"References\", which is always the last heading on the page. It gives the key, the authors, the title in italics, the publisher or journal, the year, and a DOI or stable link if one exists.</li>
<li>The locator (equation, table, example or page number) goes where the source is used: in the text, or in a comment at the code line.</li>
<li>A bare link is not a citation.</li>
<li>Where the class was compared with an independent implementation, a second line says so, starting \"Cross-checked against:\".</li>
</ul>
<h4>On the page</h4>
<p>In the text, with <code>n</code> standing for the equation number:</p>
<pre>&lt;p&gt;... the loss coefficient of a rounded bend [Rennels2012, Eq. n].&lt;/p&gt;</pre>
<p>Under the last heading:</p>
<pre>&lt;h4&gt;References&lt;/h4&gt;
&lt;p&gt;[Rennels2012] Rennels, D. C. and Hudson, H. M. &lt;i&gt;Pipe Flow: A Practical
and Comprehensive Guide&lt;/i&gt;. Wiley, 2012.&lt;/p&gt;
&lt;p&gt;Cross-checked against: Bell, C. &lt;i&gt;fluids&lt;/i&gt;,
&lt;code&gt;fluids.fittings.bend_rounded(method=&quot;Rennels&quot;)&lt;/code&gt;.&lt;/p&gt;</pre>
<h4>In the code</h4>
<p>A comment with the key and the locator, where one class uses several sources or the line would otherwise be hard to trace:</p>
<pre>// [Rennels2012], Eq. n
K = ...;</pre>
</html>"));
end References;
