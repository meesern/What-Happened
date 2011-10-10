<?xml version='1.0'?>
<!-- May need this to use unicode in xsl
<!DOCTYPE xsl:stylesheet [
<!ENTITY % allent SYSTEM "http://www.w3.org/2003/entities/2007/w3centities-f.ent">
%allent;
]>
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:m="http://www.w3.org/1998/Math/MathML"
                version='1.0'>

<xsl:template match="usecases">
<html>
  <head>
  <style type="text/css">
  ul    {
        list-style: none;
  }

  h3    {
        font-size: 0.8em;
  }

  .from-Joe  {
}
  .from-Website  {
        margin-left: 15em;
}
  .from-InfoSys  {
        margin-left: 15em;
}
  .from-ObjContainer  {
        margin-left: 30em;
}
  .from-table-1-lights  {
}
  .from-Joes-phone {
}
  .from-table-1-camera  {
}
  .from-waiter  {
}
  .from-kitchen-camera  {
}
  .from-kitchen-sounder  {
}

  .Joe  {
	border: solid thin hsla(211,90%,40%,1);
  background: #6db3f2; /* Old browsers */
background: -moz-linear-gradient(top, hsla(208,84%,69%,1) 0%, hsla(209,82%,63%,1) 50%, hsla(211,86%,58%,1) 51%, hsla(217,76%,49%,1) 100%); /* FF3.6+ */
background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,hsla(208,84%,69%,1)), color-stop(50%,hsla(209,82%,63%,1)), color-stop(51%,hsla(211,86%,58%,1)), color-stop(100%,hsla(217,76%,49%,1))); /* Chrome,Safari4+ */
background: -webkit-linear-gradient(top, hsla(208,84%,69%,1) 0%,hsla(209,82%,63%,1) 50%,hsla(211,86%,58%,1) 51%,hsla(217,76%,49%,1) 100%); /* Chrome10+,Safari5.1+ */
background: -o-linear-gradient(top, hsla(208,84%,69%,1) 0%,hsla(209,82%,63%,1) 50%,hsla(211,86%,58%,1) 51%,hsla(217,76%,49%,1) 100%); /* Opera11.10+ */
background: -ms-linear-gradient(top, hsla(208,84%,69%,1) 0%,hsla(209,82%,63%,1) 50%,hsla(211,86%,58%,1) 51%,hsla(217,76%,49%,1) 100%); /* IE10+ */
filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#6db3f2', endColorstr='#1e69de',GradientType=0 ); /* IE6-9 */
background: linear-gradient(top, hsla(208,84%,69%,1) 0%,hsla(209,82%,63%,1) 50%,hsla(211,86%,58%,1) 51%,hsla(217,76%,49%,1) 100%); /* W3C */
  }
  .Website  {
	border: solid thin hsla(80,90%,40%,1);
background: #bfd255; /* Old browsers */
background: -moz-linear-gradient(top, hsla(69,58%,58%,1) 0%, hsla(78,63%,45%,1) 50%, hsla(80,100%,33%,1) 51%, hsla(77,64%,49%,1) 100%); /* FF3.6+ */
background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,hsla(69,58%,58%,1)), color-stop(50%,hsla(78,63%,45%,1)), color-stop(51%,hsla(80,100%,33%,1)), color-stop(100%,hsla(77,64%,49%,1))); /* Chrome,Safari4+ */
background: -webkit-linear-gradient(top, hsla(69,58%,58%,1) 0%,hsla(78,63%,45%,1) 50%,hsla(80,100%,33%,1) 51%,hsla(77,64%,49%,1) 100%); /* Chrome10+,Safari5.1+ */
background: -o-linear-gradient(top, hsla(69,58%,58%,1) 0%,hsla(78,63%,45%,1) 50%,hsla(80,100%,33%,1) 51%,hsla(77,64%,49%,1) 100%); /* Opera11.10+ */
background: -ms-linear-gradient(top, hsla(69,58%,58%,1) 0%,hsla(78,63%,45%,1) 50%,hsla(80,100%,33%,1) 51%,hsla(77,64%,49%,1) 100%); /* IE10+ */
filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#bfd255', endColorstr='#9ecb2d',GradientType=0 ); /* IE6-9 */
background: linear-gradient(top, hsla(69,58%,58%,1) 0%,hsla(78,63%,45%,1) 50%,hsla(80,100%,33%,1) 51%,hsla(77,64%,49%,1) 100%); /* W3C */
  }
  .InfoSys  {
	border: solid thin hsla(44,90%,40%,1);
background: #fceabb; /* Old browsers */
background: -moz-linear-gradient(top, hsla(43,91%,86%,1) 0%, hsla(44,97%,65%,1) 50%, hsla(44,100%,49%,1) 51%, hsla(44,93%,78%,1) 100%); /* FF3.6+ */
background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,hsla(43,91%,86%,1)), color-stop(50%,hsla(44,97%,65%,1)), color-stop(51%,hsla(44,100%,49%,1)), color-stop(100%,hsla(44,93%,78%,1))); /* Chrome,Safari4+ */
background: -webkit-linear-gradient(top, hsla(43,91%,86%,1) 0%,hsla(44,97%,65%,1) 50%,hsla(44,100%,49%,1) 51%,hsla(44,93%,78%,1) 100%); /* Chrome10+,Safari5.1+ */
background: -o-linear-gradient(top, hsla(43,91%,86%,1) 0%,hsla(44,97%,65%,1) 50%,hsla(44,100%,49%,1) 51%,hsla(44,93%,78%,1) 100%); /* Opera11.10+ */
background: -ms-linear-gradient(top, hsla(43,91%,86%,1) 0%,hsla(44,97%,65%,1) 50%,hsla(44,100%,49%,1) 51%,hsla(44,93%,78%,1) 100%); /* IE10+ */
filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#fceabb', endColorstr='#fbdf93',GradientType=0 ); /* IE6-9 */
background: linear-gradient(top, hsla(43,91%,86%,1) 0%,hsla(44,97%,65%,1) 50%,hsla(44,100%,49%,1) 51%,hsla(44,93%,78%,1) 100%); /* W3C */
  }
  .ObjContainer  {
	border: solid thin hsla(318,90%,40%,1);
background: #cb60b3; /* Old browsers */
background: -moz-linear-gradient(top, hsla(313,51%,58%,1) 0%, hsla(316,50%,52%,1) 50%, hsla(318,100%,33%,1) 51%, hsla(320,70%,54%,1) 100%); /* FF3.6+ */
background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,hsla(313,51%,58%,1)), color-stop(50%,hsla(316,50%,52%,1)), color-stop(51%,hsla(318,100%,33%,1)), color-stop(100%,hsla(320,70%,54%,1))); /* Chrome,Safari4+ */
background: -webkit-linear-gradient(top, hsla(313,51%,58%,1) 0%,hsla(316,50%,52%,1) 50%,hsla(318,100%,33%,1) 51%,hsla(320,70%,54%,1) 100%); /* Chrome10+,Safari5.1+ */
background: -o-linear-gradient(top, hsla(313,51%,58%,1) 0%,hsla(316,50%,52%,1) 50%,hsla(318,100%,33%,1) 51%,hsla(320,70%,54%,1) 100%); /* Opera11.10+ */
background: -ms-linear-gradient(top, hsla(313,51%,58%,1) 0%,hsla(316,50%,52%,1) 50%,hsla(318,100%,33%,1) 51%,hsla(320,70%,54%,1) 100%); /* IE10+ */
filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#cb60b3', endColorstr='#db36a4',GradientType=0 ); /* IE6-9 */
background: linear-gradient(top, hsla(313,51%,58%,1) 0%,hsla(316,50%,52%,1) 50%,hsla(318,100%,33%,1) 51%,hsla(320,70%,54%,1) 100%); /* W3C */
  }
  .table-1-lights  {
	border: solid thin hsla(320,90%,40%,1);
background: #fcecfc; /* Old browsers */
background: -moz-linear-gradient(top, hsla(300,73%,96%,1) 0%, hsla(318,91%,82%,1) 50%, hsla(320,97%,76%,1) 51%, hsla(318,100%,75%,1) 100%); /* FF3.6+ */
background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,hsla(300,73%,96%,1)), color-stop(50%,hsla(318,91%,82%,1)), color-stop(51%,hsla(320,97%,76%,1)), color-stop(100%,hsla(318,100%,75%,1))); /* Chrome,Safari4+ */
background: -webkit-linear-gradient(top, hsla(300,73%,96%,1) 0%,hsla(318,91%,82%,1) 50%,hsla(320,97%,76%,1) 51%,hsla(318,100%,75%,1) 100%); /* Chrome10+,Safari5.1+ */
background: -o-linear-gradient(top, hsla(300,73%,96%,1) 0%,hsla(318,91%,82%,1) 50%,hsla(320,97%,76%,1) 51%,hsla(318,100%,75%,1) 100%); /* Opera11.10+ */
background: -ms-linear-gradient(top, hsla(300,73%,96%,1) 0%,hsla(318,91%,82%,1) 50%,hsla(320,97%,76%,1) 51%,hsla(318,100%,75%,1) 100%); /* IE10+ */
filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#fcecfc', endColorstr='#ff7cd8',GradientType=0 ); /* IE6-9 */
background: linear-gradient(top, hsla(300,73%,96%,1) 0%,hsla(318,91%,82%,1) 50%,hsla(320,97%,76%,1) 51%,hsla(318,100%,75%,1) 100%); /* W3C */

}
  .Joes-phone {
	border: solid thin hsla(21,90%,40%,1);
background: #feccb1; /* Old browsers */
background: -moz-linear-gradient(top, hsla(21,98%,85%,1) 0%, hsla(21,87%,57%,1) 50%, hsla(21,94%,47%,1) 51%, hsla(21,95%,68%,1) 100%); /* FF3.6+ */
background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,hsla(21,98%,85%,1)), color-stop(50%,hsla(21,87%,57%,1)), color-stop(51%,hsla(21,94%,47%,1)), color-stop(100%,hsla(21,95%,68%,1))); /* Chrome,Safari4+ */
background: -webkit-linear-gradient(top, hsla(21,98%,85%,1) 0%,hsla(21,87%,57%,1) 50%,hsla(21,94%,47%,1) 51%,hsla(21,95%,68%,1) 100%); /* Chrome10+,Safari5.1+ */
background: -o-linear-gradient(top, hsla(21,98%,85%,1) 0%,hsla(21,87%,57%,1) 50%,hsla(21,94%,47%,1) 51%,hsla(21,95%,68%,1) 100%); /* Opera11.10+ */
background: -ms-linear-gradient(top, hsla(21,98%,85%,1) 0%,hsla(21,87%,57%,1) 50%,hsla(21,94%,47%,1) 51%,hsla(21,95%,68%,1) 100%); /* IE10+ */
filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#feccb1', endColorstr='#fb955e',GradientType=0 ); /* IE6-9 */
background: linear-gradient(top, hsla(21,98%,85%,1) 0%,hsla(21,87%,57%,1) 50%,hsla(21,94%,47%,1) 51%,hsla(21,95%,68%,1) 100%); /* W3C */
}

  .table-1-camera  {
	border: solid thin hsla(353,90%,40%,1);
background: #efc5ca; /* Old browsers */
background: -moz-linear-gradient(top, hsla(353,57%,85%,1) 0%, hsla(353,60%,56%,1) 50%, hsla(353,65%,44%,1) 51%, hsla(353,78%,75%,1) 100%); /* FF3.6+ */
background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,hsla(353,57%,85%,1)), color-stop(50%,hsla(353,60%,56%,1)), color-stop(51%,hsla(353,65%,44%,1)), color-stop(100%,hsla(353,78%,75%,1))); /* Chrome,Safari4+ */
background: -webkit-linear-gradient(top, hsla(353,57%,85%,1) 0%,hsla(353,60%,56%,1) 50%,hsla(353,65%,44%,1) 51%,hsla(353,78%,75%,1) 100%); /* Chrome10+,Safari5.1+ */
background: -o-linear-gradient(top, hsla(353,57%,85%,1) 0%,hsla(353,60%,56%,1) 50%,hsla(353,65%,44%,1) 51%,hsla(353,78%,75%,1) 100%); /* Opera11.10+ */
background: -ms-linear-gradient(top, hsla(353,57%,85%,1) 0%,hsla(353,60%,56%,1) 50%,hsla(353,65%,44%,1) 51%,hsla(353,78%,75%,1) 100%); /* IE10+ */
filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#efc5ca', endColorstr='#f18e99',GradientType=0 ); /* IE6-9 */
background: linear-gradient(top, hsla(353,57%,85%,1) 0%,hsla(353,60%,56%,1) 50%,hsla(353,65%,44%,1) 51%,hsla(353,78%,75%,1) 100%); /* W3C */
}
  .waiter  {
	border: solid thin hsla(197,90%,40%,1);
background: #b7deed; /* Old browsers */
background: -moz-linear-gradient(top, hsla(197,60%,82%,1) 0%, hsla(196,80%,69%,1) 50%, hsla(194,77%,51%,1) 51%, hsla(197,60%,82%,1) 100%); /* FF3.6+ */
background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,hsla(197,60%,82%,1)), color-stop(50%,hsla(196,80%,69%,1)), color-stop(51%,hsla(194,77%,51%,1)), color-stop(100%,hsla(197,60%,82%,1))); /* Chrome,Safari4+ */
background: -webkit-linear-gradient(top, hsla(197,60%,82%,1) 0%,hsla(196,80%,69%,1) 50%,hsla(194,77%,51%,1) 51%,hsla(197,60%,82%,1) 100%); /* Chrome10+,Safari5.1+ */
background: -o-linear-gradient(top, hsla(197,60%,82%,1) 0%,hsla(196,80%,69%,1) 50%,hsla(194,77%,51%,1) 51%,hsla(197,60%,82%,1) 100%); /* Opera11.10+ */
background: -ms-linear-gradient(top, hsla(197,60%,82%,1) 0%,hsla(196,80%,69%,1) 50%,hsla(194,77%,51%,1) 51%,hsla(197,60%,82%,1) 100%); /* IE10+ */
filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#b7deed', endColorstr='#b7deed',GradientType=0 ); /* IE6-9 */
background: linear-gradient(top, hsla(197,60%,82%,1) 0%,hsla(196,80%,69%,1) 50%,hsla(194,77%,51%,1) 51%,hsla(197,60%,82%,1) 100%); /* W3C */
}
  .kitchen-camera  {
	border: solid thin hsla(67,90%,40%,1);
background: #e6f0a3; /* Old browsers */
background: -moz-linear-gradient(top, hsla(68,72%,79%,1) 0%, hsla(67,78%,56%,1) 50%, hsla(67,71%,50%,1) 51%, hsla(67,85%,60%,1) 100%); /* FF3.6+ */
background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,hsla(68,72%,79%,1)), color-stop(50%,hsla(67,78%,56%,1)), color-stop(51%,hsla(67,71%,50%,1)), color-stop(100%,hsla(67,85%,60%,1))); /* Chrome,Safari4+ */
background: -webkit-linear-gradient(top, hsla(68,72%,79%,1) 0%,hsla(67,78%,56%,1) 50%,hsla(67,71%,50%,1) 51%,hsla(67,85%,60%,1) 100%); /* Chrome10+,Safari5.1+ */
background: -o-linear-gradient(top, hsla(68,72%,79%,1) 0%,hsla(67,78%,56%,1) 50%,hsla(67,71%,50%,1) 51%,hsla(67,85%,60%,1) 100%); /* Opera11.10+ */
background: -ms-linear-gradient(top, hsla(68,72%,79%,1) 0%,hsla(67,78%,56%,1) 50%,hsla(67,71%,50%,1) 51%,hsla(67,85%,60%,1) 100%); /* IE10+ */
filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#e6f0a3', endColorstr='#dbf043',GradientType=0 ); /* IE6-9 */
background: linear-gradient(top, hsla(68,72%,79%,1) 0%,hsla(67,78%,56%,1) 50%,hsla(67,71%,50%,1) 51%,hsla(67,85%,60%,1) 100%); /* W3C */
}
  .kitchen-sounder  {
	border: solid thin hsla(37,90%,40%,1);
background: #f3e2c7; /* Old browsers */
background: -moz-linear-gradient(top, hsla(37,65%,87%,1) 0%, hsla(37,42%,58%,1) 50%, hsla(37,42%,51%,1) 51%, hsla(37,55%,81%,1) 100%); /* FF3.6+ */
background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,hsla(37,65%,87%,1)), color-stop(50%,hsla(37,42%,58%,1)), color-stop(51%,hsla(37,42%,51%,1)), color-stop(100%,hsla(37,55%,81%,1))); /* Chrome,Safari4+ */
background: -webkit-linear-gradient(top, hsla(37,65%,87%,1) 0%,hsla(37,42%,58%,1) 50%,hsla(37,42%,51%,1) 51%,hsla(37,55%,81%,1) 100%); /* Chrome10+,Safari5.1+ */
background: -o-linear-gradient(top, hsla(37,65%,87%,1) 0%,hsla(37,42%,58%,1) 50%,hsla(37,42%,51%,1) 51%,hsla(37,55%,81%,1) 100%); /* Opera11.10+ */
background: -ms-linear-gradient(top, hsla(37,65%,87%,1) 0%,hsla(37,42%,58%,1) 50%,hsla(37,42%,51%,1) 51%,hsla(37,55%,81%,1) 100%); /* IE10+ */
filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#f3e2c7', endColorstr='#e9d4b3',GradientType=0 ); /* IE6-9 */
background: linear-gradient(top, hsla(37,65%,87%,1) 0%,hsla(37,42%,58%,1) 50%,hsla(37,42%,51%,1) 51%,hsla(37,55%,81%,1) 100%); /* W3C */
}
  .name {
        font-size: 1.0em;
	width: 25em;
	padding: .5em .8em;
	color: #ffffff;
	text-shadow: 1px 1px 1px #000;
	-webkit-border-radius: .7em;
	-moz-border-radius: .7em;
	border-radius: .7em;
	-webkit-box-shadow: 2px 2px 3px #999; 
	box-shadow: 2px 2px 2px #bbb;
}
  li {
        padding: 1px;
  }
  li p {
        width: 20em;
	border: solid thin #333;
        padding: 1.0em 1.4em;
	-webkit-border-radius: .7em;
	-moz-border-radius: .7em;
	border-radius: .7em;
        font-size: 0.9em;
        background: white;
        margin-bottom: -1px;
  }
  body {
        background: #eee;
  }
  </style>
  </head>
  <body>
    <xsl:apply-templates/>
  </body>
</html>
</xsl:template>

<xsl:template match="section">
  <hr/>
  <div class="section">
  <ul class="msg-list">
    <xsl:apply-templates/>
  </ul>
  </div>
</xsl:template>

<xsl:template match="message">
  <li>
    <xsl:attribute name="class">from-<xsl:value-of select="@from"/></xsl:attribute>
    <h3>
      <span><xsl:attribute name="class">name <xsl:value-of select="@from"/></xsl:attribute> <xsl:value-of select="@from"/></span> <span class='to'> --> </span> <span><xsl:attribute name="class">name <xsl:value-of select="@to"/></xsl:attribute><xsl:value-of select="@to"/></span>
    </h3>
    <p>
      <xsl:apply-templates/>
    </p>
  </li>
</xsl:template>

</xsl:stylesheet>
