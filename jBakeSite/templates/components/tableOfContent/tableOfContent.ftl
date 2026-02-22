<#function getComponnentInfo>
	<#return {"componnentVersion":1, "name":"tableOfContent", "description":"Add subContent in content", "recommandedNamespace":"toc", "version":"0.1.0", "require":[{"value":"toc", "type":"contentHeader"}, {"value":"block", "type":"componnent"}], "uses":[{"value":"langHelper", "type":"lib"}, {"value":"logHelper", "type":"lib"}]}>
</#function>

<#function init>
	<#return "" />
</#function>

<#-- build aa table of content
param : content : content to search for include content
-->
<#macro build theContent>
	<#if (theContent.toc)??>
		<#local displayToc=theContent.toc>
		<#if displayToc?has_content>
			<#if logHelper??>
		 		${logHelper.stackDebugMessage("ToC : display TOC for ${content.uri} with value " + common.toString(displayToc))}
		 	</#if>
		 	<#if block??>
				<#local subTemplateName = "defaultTocSubTemplate">
				<#if (displayToc.subTemplate??)>
					<#local subTemplateName=displayToc.subTemplate>
				</#if>
				<#local subTemplateInterpretation = "<@${subTemplateName} displayToc block.getBlocks(theContent) />"?interpret>
				<@subTemplateInterpretation/>
			</#if>
		</#if>
	</#if>
</#macro>

<#macro defaultTocSubTemplate displayToc blocks>
	<@blockTocUlLiWithLinkSubTemplate displayToc blocks blocksOrderBy />
</#macro>

<#macro blockTocUlLiWithLinkSubTemplate displayToc blocks>
	<#if logHelper??>
 		${logHelper.stackDebugMessage("ToC : Building a Lu/LI ToC")}
 	</#if>
	<div class="toc">
		<#local endTag="">
		<@displayTocTitle displayToc />
		
		<ul class="toc_list">
		<#list blocks as blockForToc>
			<#local uri = buildTocUri(blockForToc)>
			<#if uri?has_content>
				<a href="${uri}">
				<#local endTag="</a>">
			</#if>
			<li class="toc_item">${blockForToc.title}</li>
			${endTag}
		</#list>
		</ul>
	</div>
</#macro>

<#macro blockTocSelectSubTemplate displayToc blocks>
	<#if logHelper??>
 		${logHelper.stackDebugMessage("ToC : Building a Select ToC")}
 	</#if>
	<div class="toc" role="navigation" aria-label="Table des matières">
		<#local endTag="">
		<select id="toc-select" class="toc_list toc-select">
		<option value="">--${displayToc.title!"Naviguation"}--</option>
		<#list blocks as blockForToc>
			<#local uri = buildTocUri(blockForToc)>
			<option value="${uri}" class="toc_item">${blockForToc.title}</option>
			${endTag}
		</#list>
		</select>
	</div>
</#macro>

<#macro displayTocTitle displayToc>
	<#local tocTitle = displayToc.title!"">
	<#if tocTitle?has_content>
		<h3 class="toc_title">${tocTitle}</h3>
	</#if>
</#macro>

<#function buildTocUri block>
	<#local uri = "">
	<#if (block.anchorId)??>
		<#local uri = "#" + block.anchorId>
	<#else>
		<#local uri = "#" + common.generatedAnchorId(block.title)>
	</#if>
	<#return uri>
</#function>