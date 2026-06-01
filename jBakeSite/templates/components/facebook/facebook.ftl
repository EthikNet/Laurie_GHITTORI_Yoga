<#function getComponnentInfo>
	<#return {"componnentVersion":2, "name":"facebook", "description":"To integrate FaceBook in website", "recommandedNamespace":"facebook", "version":"0.2.0", "require":[{"value":"propertiesHelper", "type":"lib"}, {"value":"component.fairlytics.key", "type":"config"}]}>
</#function>

<#global pageUseFacebook=false />

<#function init>
	<#return "" />
</#function>

<#function registerDefaultHooks()>
	<#return "" />
</#function>

<#function addHeaderScripts()>
	<#return "" />
</#function>

<#function addFooterScripts()>
	<#if pageUseFacebook>
		<#if ressourcesHelper??>
			${ressourcesHelper.addFooterRessource({"tagType":"script", "src":"templates/components/facebook/copyToAssets/noAgregation/facebook.js", "order":40})}
		<#else>
			<#if logHelper??>
				${logHelper.stackDebugMessage("facebook.addFooterScripts : ERROR cannot add footer script, missing 'ressourcesHelper' component")}
			</#if>
		</#if>
		<#else>
		<#if logHelper??>
			${logHelper.stackDebugMessage("facebook.addFooterScripts : Facebook component are not use in this page, no script added")}
		</#if>
	</#if>
	<#return "" />
</#function>

<#macro buildNews content>
	<@buildfaceBook "timeline" "${webleger.component.meta.facebook.container.url}"/>
</#macro>

<#macro buildEvent content>
	<@buildfaceBook "events" "${webleger.component.meta.facebook.container.url}" />
</#macro>

<#macro buildfaceBook tabs href>
	<#if logHelper??>
		${logHelper.stackDebugMessage("facebook.buildfaceBook : adding facebook component. page already contain Facebook component ? " + pageUseFacebook?string("yes","no"))}
	</#if>
	<#global pageUseFacebook=true />
	<div class="faceBookContainer">
    	<div class="fb-page" 
    		data-href="${href}" 
    		data-tabs="${tabs}" 
    		data-width="${webleger.component.meta.facebook.container.width.desktop}" 
    		data-height="${webleger.component.meta.facebook.container.height.desktop}" 
    		data-small-header="false" 
    		data-adapt-container-width="false" 
    		data-hide-cover="false" 
    		data-show-facepile="true">
    			<blockquote cite="${webleger.component.meta.facebook.container.url}" 
    				class="fb-xfbml-parse-ignore">
    					<a href="${webleger.component.meta.facebook.container.url}">${webleger.component.meta.facebook.container.name}</a>
    			</blockquote>
    	</div>
	</div>
</#macro>