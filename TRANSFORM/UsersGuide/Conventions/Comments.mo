within TRANSFORM.UsersGuide.Conventions;
class Comments "Comments in the code"
  extends Modelica.Icons.Information;
  annotation (Documentation(info="<html>
<ol>
<li><b>The description string comes first.</b> Anything a user should see goes in a description string, not in a comment. A tool shows descriptions and hides comments.</li>
<li><b>A comment states what must stay true about the code below it.</b> It does not say what the line does; the line already says that. It does not tell the story of how the line came to be.
<pre>// Written linear in the area: the reciprocal form makes the solver diverge
UA = surfaceArea/(1/alpha_1 + 1/alpha_2);</pre></li>
<li><b>The test for a comment.</b> Would a careful person editing this line undo the choice without the comment? If not, the comment is not needed. If so, it says what breaks, in three lines or fewer.</li>
<li><b>A comment stays true for as long as the line is unchanged.</b> So it holds no dates, no names of people or projects, no tool versions, and no \"was\", \"used to\", \"now\" or \"tried\".</li>
<li><b>A comment sits on its own line, above what it explains.</b> It is not put at the end of a statement or inside a declaration. When a tool rewrites a class after a graphical edit, it can drop a comment inside a declaration and can move one from the end of a statement to a line of its own.</li>
<li><b>A source is cited with its key.</b> <code>// [Rennels2012], Eq. n</code>, as the References page describes.</li>
<li><b>No commented-out code in new code.</b> An idea that is not implemented is written as a sentence: <code>// Idea, not implemented: ...</code></li>
</ol>
<h4>Where the rest goes</h4>
<p>Most of what is worth recording about a change does not belong at the line. Each kind has one home:</p>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>What is recorded</th><th>Home</th></tr>
<tr><td>What must stay true about this line</td><td>A comment at the line</td></tr>
<tr><td>What the class promises, and its limits</td><td>The class's documentation</td></tr>
<tr><td>What changed, the old and new behaviour, what a user must do</td><td>CHANGELOG.md</td></tr>
<tr><td>How it was found, what was tried, measurements, tool versions</td><td>The pull request and the commit message</td></tr>
<tr><td>A lesson that applies to more than one class</td><td><code>TRANSFORM.UsersGuide.ModelingTips</code></td></tr>
</table>
<p>The history of a line is not lost by leaving it out of the comment: the version history leads from any line to the commit and the pull request that changed it.</p>
<h4>Titles above blocks of code</h4>
<p>Titles are optional. The dialog annotations already group the declarations a user sees. If a block is given a title, use the name of its dialog group or of the balance it holds, and keep it true when the block changes.</p>
<h4>Commented-out code and long comments in existing classes</h4>
<p>They are reviewed one class at a time, when that class is edited. Each block is removed, reworded, moved to its home in the table above, or left until its purpose is known. Nothing is removed in bulk: some of it records an idea that was not finished.</p>
</html>"));
end Comments;
