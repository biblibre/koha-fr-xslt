﻿<?xml version='1.0'?>
<xsl:stylesheet version="1.0" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template name="datafield">
		<xsl:param name="tag"/>
		<xsl:param name="ind1"><xsl:text> </xsl:text></xsl:param>
		<xsl:param name="ind2"><xsl:text> </xsl:text></xsl:param>
		<xsl:param name="subfields"/>
		<xsl:element name="datafield">
			<xsl:attribute name="tag">
				<xsl:value-of select="$tag"/>
			</xsl:attribute>
			<xsl:attribute name="ind1">
				<xsl:value-of select="$ind1"/>
			</xsl:attribute>
			<xsl:attribute name="ind2">
				<xsl:value-of select="$ind2"/>
			</xsl:attribute>
			<xsl:copy-of select="$subfields"/>
		</xsl:element>
	</xsl:template>

  <xsl:variable name="ascii"> !"#$%&amp;'()*+,-./0123456789:;&lt;=&gt;?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~</xsl:variable>
  <xsl:variable name="latin1">&#160;&#161;&#162;&#163;&#164;&#165;&#166;&#167;&#168;&#169;&#170;&#171;&#172;&#173;&#174;&#175;&#176;&#177;&#178;&#179;&#180;&#181;&#182;&#183;&#184;&#185;&#186;&#187;&#188;&#189;&#190;&#191;&#192;&#193;&#194;&#195;&#196;&#197;&#198;&#199;&#200;&#201;&#202;&#203;&#204;&#205;&#206;&#207;&#208;&#209;&#210;&#211;&#212;&#213;&#214;&#215;&#216;&#217;&#218;&#219;&#220;&#221;&#222;&#223;&#224;&#225;&#226;&#227;&#228;&#229;&#230;&#231;&#232;&#233;&#234;&#235;&#236;&#237;&#238;&#239;&#240;&#241;&#242;&#243;&#244;&#245;&#246;&#247;&#248;&#249;&#250;&#251;&#252;&#253;&#254;&#255;</xsl:variable>
  <!-- Characters that usually don't need to be escaped -->
  <xsl:variable name="safe">!'()*-.0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz~</xsl:variable>
  <xsl:variable name="hex" >0123456789ABCDEF</xsl:variable>

  <xsl:template name="url-encode">
    <xsl:param name="str"/>
    <xsl:if test="$str">
      <xsl:variable name="first-char" select="substring($str,1,1)"/>
      <xsl:choose>
        <xsl:when test="contains($safe,$first-char)">
          <xsl:value-of select="$first-char"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="codepoint">
            <xsl:choose>
              <xsl:when test="contains($ascii,$first-char)">
                <xsl:value-of select="string-length(substring-before($ascii,$first-char)) + 32"/>
              </xsl:when>
              <xsl:when test="contains($latin1,$first-char)">
                <xsl:value-of select="string-length(substring-before($latin1,$first-char)) + 160"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:message terminate="no">Warning: string contains a character that is out of range! Substituting "?".</xsl:message>
                <xsl:text>63</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
        <xsl:variable name="hex-digit1" select="substring($hex,floor($codepoint div 16) + 1,1)"/>
        <xsl:variable name="hex-digit2" select="substring($hex,$codepoint mod 16 + 1,1)"/>
        <xsl:value-of select="concat('%',$hex-digit1,$hex-digit2)"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="string-length($str) &gt; 1">
        <xsl:call-template name="url-encode">
          <xsl:with-param name="str" select="substring($str,2)"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:if>
  </xsl:template>

<xsl:template name="tag_205">
<!--    <xsl:if test="marc:datafield[@tag=205]/marc:subfield[@code='a' or @code='b']"> -->
    <span class="results_summary">
      <xsl:for-each select="marc:datafield[@tag=205]">
      <xsl:value-of select="marc:subfield[@code='a']"/>
        <xsl:if test="marc:subfield[@code='b']">
         <xsl:for-each select="marc:subfield[@code='b']">
         <xsl:text>, </xsl:text><xsl:value-of select="."/>
         </xsl:for-each>
       </xsl:if>
         <xsl:if test ="position() = last()"><xsl:text> - </xsl:text></xsl:if>
      </xsl:for-each>
    </span>
<!--    </xsl:if> -->
</xsl:template>

	<xsl:template name="tag_210">
<!--    <xsl:if test="marc:datafield[@tag=210]/marc:subfield[@code='c' or @code='d']"> -->
      <span class="results_summary">
      <xsl:for-each select="marc:datafield[@tag=210]">
        <xsl:for-each select="marc:subfield[@code='c']">
        <xsl:value-of select="."/>
         <xsl:if test="position() != last()"><xsl:text> : </xsl:text></xsl:if>
        </xsl:for-each>
      <xsl:if test="marc:subfield[@code='d']">
        <xsl:if test="marc:subfield[@code='c']">, </xsl:if>
        <xsl:value-of select="marc:subfield[@code='d']"/>
      </xsl:if>
      <xsl:if test="marc:subfield[@code='h']"> <!-- depuis mi-avril 2107 -->
        <xsl:if test="marc:subfield[@code='c']">, </xsl:if>
        <xsl:value-of select="marc:subfield[@code='h']"/>
      </xsl:if>
      <xsl:if test="position() != last()"><xsl:text> - </xsl:text></xsl:if>
      </xsl:for-each>
      <xsl:text>. </xsl:text>
      </span>
<!--	  </xsl:if> -->
  </xsl:template>

	<xsl:template name="tag_215">
    <xsl:for-each select="marc:datafield[@tag=215]">
  	  <span class="results_summary">
        <span class="label">Description : </span> 
        <xsl:if test="marc:subfield[@code='a']">
          <xsl:value-of select="marc:subfield[@code='a']"/>
        </xsl:if>
        <xsl:if test="marc:subfield[@code='c']"> :
          <xsl:value-of select="marc:subfield[@code='c']"/>
        </xsl:if>
        <xsl:if test="marc:subfield[@code='d']"> ;
          <xsl:value-of select="marc:subfield[@code='d']"/>
        </xsl:if>
        <xsl:if test="marc:subfield[@code='e']"> +
          <xsl:value-of select="marc:subfield[@code='e']"/>
        </xsl:if>
      </span>
    </xsl:for-each>
  </xsl:template>

<xsl:template name="tag_225">
<!--    <xsl:if test="marc:datafield[@tag=225]/marc:subfield[@code='a']"> -->
      <xsl:for-each select="marc:datafield[@tag=225]">
      <span class="results_summary"> <xsl:text>(</xsl:text>
      <xsl:value-of select="marc:subfield[@code='a']"/>
        <xsl:if test="marc:subfield[@code='h']">
        <xsl:text>. </xsl:text><xsl:value-of select="marc:subfield[@code='h']"/>
        </xsl:if>
        <xsl:if test="marc:subfield[@code='i']">
         <xsl:choose>
         <xsl:when test="marc:subfield[@code='h']">
         <xsl:text>, </xsl:text>
         </xsl:when>
         <xsl:otherwise>
         <xsl:text>. </xsl:text>
         </xsl:otherwise>
         </xsl:choose>
        <xsl:value-of select="marc:subfield[@code='i']"/>
        </xsl:if>
       <xsl:text>)</xsl:text>
       <xsl:if test="position() = last()"><xsl:text>. </xsl:text></xsl:if>
	</span>
      </xsl:for-each>
<!--    </xsl:if> -->
</xsl:template>

<xsl:template name="tag_463"><!-- titre revue pour les articles ...et autre -->
<xsl:variable name="support" select="marc:datafield[@tag=099]/marc:subfield[@code='t']" />
    <xsl:if test="$support = 'Article'">
      <span class="result_summary">
        <span class="results_summary">Article dans : </span><span class="valeur">
        <xsl:for-each select="marc:datafield[@tag=463]">
        <a><xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?q="<xsl:value-of select="marc:subfield[@code='t']"/>"&amp;limit=typedoc%3A"REVUE"</xsl:attribute><xsl:value-of select="marc:subfield[@code='t']"/></a>&#xA0;
        <xsl:value-of select="marc:subfield[@code='v']"/>
        </xsl:for-each>
        </span>
      </span>
    </xsl:if>
</xsl:template>

  <xsl:template name="tag_4xx">
    <xsl:if test="marc:datafield[@tag=461]">
      <span class="results_summary">
      <span class="label">Partie de : </span> 
      <xsl:value-of select="marc:subfield[@code='t']"/>
      <xsl:if test="marc:subfield[@code='v']"><xsl:value-of select="marc:subfield[@code='v']"/></xsl:if>
      </span>
    </xsl:if>	
    <xsl:if test="marc:datafield[@tag=454]">
      <span class="results_summary">
      <span class="label">Trad. de : </span> 
      <xsl:value-of select="marc:datafield[@tag=454]"/>
      </span>
    </xsl:if>	
    <xsl:for-each select="marc:datafield[@tag=464]">
    	  <span class="results_summary">
        <span class="label">Inclut : </span> 
        <xsl:if test="marc:subfield[@code='t']">
          <xsl:value-of select="marc:subfield[@code='t']"/>
        </xsl:if>
        <xsl:if test="marc:subfield[@code='e']"> :
          <xsl:value-of select="marc:subfield[@code='e']"/>
        </xsl:if>
        <xsl:if test="marc:subfield[@code='f']"> /
          <xsl:value-of select="marc:subfield[@code='f']"/>
        </xsl:if>
        <xsl:if test="marc:subfield[@code='v']">,
          <xsl:value-of select="marc:subfield[@code='v']"/>
        </xsl:if>
      </span>
    </xsl:for-each>
  </xsl:template>
  
<xsl:template name="tag_856">
 <!--   <xsl:if test="marc:datafield[@tag=856]"> -->
      <xsl:for-each select="marc:datafield[@tag=856]">
     <xsl:if test="not(starts-with(marc:subfield[@code='u'],'http://www.theses.fr') and substring-after(substring-after(substring-after(substring-after(marc:subfield[@code='u'],'/'),'/'),'/'),'/')='document' )"> <!-- test sur le 856_u pour supprimer l'une des 2 url des theses num qui pointe sur tel  -->
     <xsl:if test="marc:subfield[@code='2']"><!-- test sur le 856_2 qui determine les droits d'acces -->
      <span class="results_summary_online_avec_reserve">
        <a>
         <xsl:attribute name="href">
          <xsl:value-of select="marc:subfield[@code='u']"/>
         </xsl:attribute>
         <xsl:attribute name="target">_blank</xsl:attribute>
          <xsl:choose>
           <xsl:when test="marc:subfield[@code='z']"> <!-- note -->
            <xsl:attribute name="title"><xsl:value-of select="marc:subfield[@code='z']"/></xsl:attribute>
           </xsl:when>
          </xsl:choose>
           <xsl:value-of select="marc:subfield[@code='2']"/>
          <xsl:choose>
           <xsl:when test="marc:subfield[@code='q']"> <!-- format -->
            &#xA0;-&#xA0;<xsl:value-of select="marc:subfield[@code='q']"/>
           </xsl:when>
          </xsl:choose>
        </a>
      </span>
      </xsl:if>
     <xsl:if test="not(marc:subfield[@code='2'])"><!-- test sur le 856_2 qui determine les droits d'acces -->
      <span class="results_summary_online_sans_reserve">
        <a>
         <xsl:attribute name="href">
          <xsl:value-of select="marc:subfield[@code='u']"/>
         </xsl:attribute>
         <xsl:attribute name="target">_blank</xsl:attribute>
          <xsl:choose>
           <xsl:when test="marc:subfield[@code='z']"> <!-- note -->
            <xsl:attribute name="title"><xsl:value-of select="marc:subfield[@code='z']"/></xsl:attribute>
           </xsl:when>
          </xsl:choose>
         <xsl:choose> <!-- test sur 856_u pour les theses num pour différencier url vers tel ou vers pdf -->
           <xsl:when test="starts-with(marc:subfield[@code='u'],'http://www.theses.fr') and substring-after(substring-after(substring-after(substring-after(marc:subfield[@code='u'],'/'),'/'),'/'),'/')='abes'">
           Accès libre : document pdf
           </xsl:when>
           <xsl:when test="starts-with(marc:subfield[@code='u'],'http://tel.archives-ouvertes.fr')">
           Accès libre via Thèses En Ligne (TEL)
           </xsl:when>
           <xsl:otherwise>Accès libre</xsl:otherwise>
         </xsl:choose>
          <xsl:choose>
           <xsl:when test="marc:subfield[@code='q']"> <!-- format -->
            &#xA0;-&#xA0;<xsl:value-of select="marc:subfield[@code='q']"/>
           </xsl:when>
          </xsl:choose>
        </a>
      </span>
      </xsl:if>
      </xsl:if>
      </xsl:for-each>
<!--    </xsl:if> -->
</xsl:template>


<xsl:template name="tag_930">
<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
<!-- <xsl:if test="marc:datafield[@tag=930]"> -->
    <span class="results_summary_coll">
    <xsl:choose>
    <xsl:when test="count(marc:datafield[@tag=930])>1">
    Collections : 
  </xsl:when>
  <xsl:otherwise>
    Collection : 
    </xsl:otherwise>
</xsl:choose>
    <span style="display:inline-block;vertical-align:top;">
    <xsl:for-each select="marc:datafield[@tag=930]"> 
   <xsl:if test="position()!=1">
    <br />
    </xsl:if>
    <xsl:if test="marc:subfield[@code='l']">
<!--     <xsl:value-of select="translate(marc:subfield[@code='l'], $uppercase, $smallcase)"/>&#xA0; -->
     <xsl:value-of select="marc:subfield[@code='l']"/>&#xA0;
    </xsl:if>
    <xsl:if test="marc:subfield[@code='m']">
     <xsl:value-of select="marc:subfield[@code='m']"/>&#xA0;
    </xsl:if>
    <xsl:if test="marc:subfield[@code='h']">
     <xsl:value-of select="marc:subfield[@code='h']"/>&#xA0;
    </xsl:if>
    <xsl:if test="marc:subfield[@code='d']">
      cote&#xA0;<xsl:value-of select="marc:subfield[@code='d']"/>&#xA0;
    </xsl:if>
   </xsl:for-each>
        </span></span>
<!--    </xsl:if> -->
 </xsl:template>

 <xsl:template name="tag_940">
  <br /><span class="results_summary_dispo"><span class="in_order">
  <xsl:text>En commande : </xsl:text>
  <xsl:for-each select="marc:datafield[@tag=940]">
    <xsl:if test="marc:subfield[@code='k']">
      <xsl:value-of select="marc:subfield[@code='k']"/>
    </xsl:if>
    <xsl:if test="marc:subfield[@code='i']">
      (<xsl:value-of select="marc:subfield[@code='i']"/>)
    </xsl:if>
    <xsl:if test="not (position() = last())">
      <xsl:text> ; </xsl:text>
    </xsl:if>
  </xsl:for-each>
  </span></span>
 </xsl:template>

  <xsl:template name="RelatorCode">
       <xsl:if test="marc:subfield[@code=4]">
	    <xsl:choose>
	      <xsl:when test="node()='070'"><xsl:text>, coauteur</xsl:text></xsl:when>
	      <xsl:when test="node()='651'"><xsl:text>, directeur de publication</xsl:text></xsl:when>
	      <xsl:when test="node()='730'"><xsl:text>, traducteur</xsl:text></xsl:when>
              <xsl:when test="node()='080'"><xsl:text>, préfacier</xsl:text></xsl:when>
	      <xsl:when test="node()='340'"><xsl:text>, éditeur</xsl:text></xsl:when>
	      <xsl:when test="node()='440'"><xsl:text>, illustrateur</xsl:text></xsl:when>
	      <xsl:when test="node()='557'"><xsl:text>, organisateur</xsl:text></xsl:when>
	      <xsl:when test="node()='727'"><xsl:text>, directeur de thèse</xsl:text></xsl:when>
	      <xsl:when test="node()='295'"><xsl:text>, établissement de soutenance</xsl:text></xsl:when>
	      <xsl:otherwise><xsl:text></xsl:text></xsl:otherwise>
	    </xsl:choose>
	  </xsl:if>
  </xsl:template>

	<xsl:template name="subfieldSelect">
		<xsl:param name="codes"/>
		<xsl:param name="delimeter"><xsl:text> </xsl:text></xsl:param>
		<xsl:param name="subdivCodes"/>
		<xsl:param name="subdivDelimiter"/>
		<xsl:variable name="str">
			<xsl:for-each select="marc:subfield">
				<xsl:if test="contains($codes, @code)">
                    <xsl:if test="contains($subdivCodes, @code)">
                        <xsl:value-of select="$subdivDelimiter"/>
                    </xsl:if>
					<xsl:value-of select="text()"/><xsl:value-of select="$delimeter"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:value-of select="substring($str,1,string-length($str)-string-length($delimeter))"/>
	</xsl:template>

	<xsl:template name="buildSpaces">
		<xsl:param name="spaces"/>
		<xsl:param name="char"><xsl:text> </xsl:text></xsl:param>
		<xsl:if test="$spaces>0">
			<xsl:value-of select="$char"/>
			<xsl:call-template name="buildSpaces">
				<xsl:with-param name="spaces" select="$spaces - 1"/>
				<xsl:with-param name="char" select="$char"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="chopSpecialCharacters">
        <xsl:param name="title" />
        <xsl:variable name="ntitle"
             select="translate($title, '&#x0098;&#x009C;&#xC29C;&#xC29B;&#xC298;&#xC288;&#xC289;','')"/>
        <xsl:value-of select="$ntitle" />
    </xsl:template>

	<xsl:template name="chopPunctuation">
		<xsl:param name="chopString"/>
		<xsl:variable name="length" select="string-length($chopString)"/>
		<xsl:choose>
			<xsl:when test="$length=0"/>
			<xsl:when test="contains('.:,;/ ', substring($chopString,$length,1))">
				<xsl:call-template name="chopPunctuation">
					<xsl:with-param name="chopString" select="substring($chopString,1,$length - 1)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="not($chopString)"/>
			<xsl:otherwise><xsl:value-of select="$chopString"/></xsl:otherwise>
		</xsl:choose>
<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template name="addClassRtl">
    <xsl:variable name="lang" select="marc:subfield[@code='7']" />
    <xsl:if test="$lang = 'ha' or $lang = 'Hebrew' or $lang = 'fa' or $lang = 'Arabe'">
      <xsl:attribute name="class">rtl</xsl:attribute>
    </xsl:if>
  </xsl:template>

  <xsl:template name="tag_title">
    <xsl:param name="tag" />
    <xsl:param name="label" />
    <xsl:if test="marc:datafield[@tag=$tag]">
      <span class="results_summary">
        <span class="label"><xsl:value-of select="$label"/>: </span>
        <xsl:for-each select="marc:datafield[@tag=$tag]">
          <xsl:value-of select="marc:subfield[@code='a']" />
          <xsl:if test="marc:subfield[@code='d']">
            <xsl:text> : </xsl:text>
            <xsl:value-of select="marc:subfield[@code='e']"/>
          </xsl:if>
          <xsl:if test="marc:subfield[@code='e']">
            <xsl:for-each select="marc:subfield[@code='e']">
              <xsl:text> </xsl:text>
              <xsl:value-of select="."/>
            </xsl:for-each>
          </xsl:if>
          <xsl:if test="marc:subfield[@code='f']">
            <xsl:text> / </xsl:text>
            <xsl:value-of select="marc:subfield[@code='f']"/>
          </xsl:if>
          <xsl:if test="marc:subfield[@code='h']">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="marc:subfield[@code='h']"/>
          </xsl:if>
          <xsl:if test="marc:subfield[@code='i']">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="marc:subfield[@code='i']"/>
          </xsl:if>
          <xsl:if test="marc:subfield[@code='v']">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="marc:subfield[@code='v']"/>
          </xsl:if>
          <xsl:if test="marc:subfield[@code='x']">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="marc:subfield[@code='x']"/>
          </xsl:if>
          <xsl:if test="marc:subfield[@code='z']">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="marc:subfield[@code='z']"/>
          </xsl:if>
        </xsl:for-each>
      </span>
    </xsl:if>
  </xsl:template>


  <xsl:template name="tag_subject">
    <xsl:param name="tag" />
    <xsl:param name="label" />
    <xsl:if test="marc:datafield[@tag=$tag]">
      <span class="results_summary">
        <span class="label"><xsl:value-of select="$label"/>: </span>
        <xsl:for-each select="marc:datafield[@tag=$tag]">
          <a>
            <xsl:choose>
              <xsl:when test="marc:subfield[@code=9]">
                <xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?q=an:<xsl:value-of select="marc:subfield[@code=9]"/></xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?q=su:<xsl:value-of select="marc:subfield[@code='a']"/></xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:call-template name="chopPunctuation">
              <xsl:with-param name="chopString">
                <xsl:call-template name="subfieldSelect">
                    <xsl:with-param name="codes">abcdjpvxyz</xsl:with-param>
                    <xsl:with-param name="subdivCodes">jpxyz</xsl:with-param>
                    <xsl:with-param name="subdivDelimiter">-- </xsl:with-param>
                </xsl:call-template>
              </xsl:with-param>
            </xsl:call-template>
          </a>
          <xsl:if test="not (position()=last())">
            <xsl:text> | </xsl:text>
          </xsl:if>
        </xsl:for-each>
      </span>
    </xsl:if>
  </xsl:template>


  <xsl:template name="tag_7xx">
    <xsl:param name="tag" />
    <xsl:param name="label" />
    <xsl:if test="marc:datafield[@tag=$tag]">
      <span class="results_summary">
        <span class="label"><xsl:value-of select="$label" />: </span>
        <xsl:for-each select="marc:datafield[@tag=$tag]">
          <span>
            <xsl:call-template name="addClassRtl" />
            <a>
              <xsl:choose>
                <xsl:when test="marc:subfield[@code=9]">
                  <xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?q=an:<xsl:value-of select="marc:subfield[@code=9]"/></xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="href">/cgi-bin/koha/catalogue/search.pl?q=au:<xsl:value-of select="marc:subfield[@code='a']"/><xsl:text> </xsl:text><xsl:value-of select="marc:subfield[@code='b']"/></xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:if test="marc:subfield[@code='a']">
                <xsl:value-of select="marc:subfield[@code='a']"/>
              </xsl:if>
              <xsl:if test="marc:subfield[@code='b']">
                <xsl:text>, </xsl:text>
                <xsl:value-of select="marc:subfield[@code='b']"/>
              </xsl:if>
              <xsl:if test="marc:subfield[@code='c']">
                <xsl:text>, </xsl:text>
                <xsl:value-of select="marc:subfield[@code='c']"/>
              </xsl:if>
              <xsl:if test="marc:subfield[@code='d']">
                <xsl:text> </xsl:text>
                <xsl:value-of select="marc:subfield[@code='d']"/>
              </xsl:if>
              <xsl:if test="marc:subfield[@code='f']">
                <span dir="ltr">
                <xsl:text> (</xsl:text>
                <xsl:value-of select="marc:subfield[@code='f']"/>
                <xsl:text>)</xsl:text>
                </span>
              </xsl:if>
              <xsl:if test="marc:subfield[@code='g']">
                <xsl:text> </xsl:text>
                <xsl:value-of select="marc:subfield[@code='g']"/>
              </xsl:if>
              <xsl:if test="marc:subfield[@code='p']">
                <xsl:text> </xsl:text>
                <xsl:value-of select="marc:subfield[@code='p']"/>
              </xsl:if>
            </a>
          </span>
          <xsl:if test="not (position() = last())">
            <xsl:text> ; </xsl:text>
          </xsl:if>
        </xsl:for-each>
      </span>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
