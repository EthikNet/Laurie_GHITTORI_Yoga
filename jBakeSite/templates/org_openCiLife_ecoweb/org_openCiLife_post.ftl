<#include "header.ftl">
	
	<#if hookHelper?? && hookHelper.hasContributors("beforePageHeader")>
		<div id="beforePageHeader" class="${webleger.site.beforePageHeader.class}">
		<@hookHelper.hook "beforePageHeader" content/>
		</div>
	</#if>
	
	<div class="pageContent">
	
	<#if hookHelper?? && hookHelper.hasContributors("beforeBody")>
		<div id="beforeBody" class="${webleger.site.beforeBody.class}">
		<@hookHelper.hook "beforeBody" content/>
		</div>
	</#if>
	<#if (content.body)??>
		<#if (content.subTemplate)??>
			<#assign subTemplateInterpretation = "<@${content.subTemplate} content />"?interpret>
			<@subTemplateInterpretation/>
		<#else>
			${content.body}
		</#if>
	</#if>
	
	<#if hookHelper?? && hookHelper.hasContributors("afterBody")>
		<div id="afterBody" class="${webleger.site.afterBody.class}">
		<@hookHelper.hook "afterBody" content/>
		</div>
	</#if>
	
	</div>
<#include "footer.ftl">