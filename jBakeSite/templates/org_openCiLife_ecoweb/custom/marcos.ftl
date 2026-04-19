<#function getComponnentInfo>
	<#return {"componnentVersion":2, "name":"WebLegerMacro", "description":"WebLeger Template", "recommandedNamespace":"ecoWeb", "uses":[{"value":"logHelper", "type":"lib"}, {"value":"displayDate", "type":"contentHeader"}, {"value":"displaySiteHeaderTitle", "type":"contentHeader"}]}>
</#function>

<#function init>
	<#return "" />
</#function>

<#function registerDefaultHooks()>
	<#local registerComponnentHooks = true>
	<#if registerComponnentHooks>
		${hookHelper.registerHook("beforePageHeader", "ecoWeb.displayPublicationDate", false)}
		${hookHelper.registerHook("afterBlockBody", "ecoWeb.displayPublicationDate", false)}
		${hookHelper.registerHook("beforePageHeader", "ecoWeb.displayTags", false)}
	</#if>
</#function>

<#function addHeaderScripts()>
	<#if ressourcesHelper??>
		${ressourcesHelper.addHeaderRessource({"tagType":"link", "href":"static/top.css", "rel":"stylesheet", "order":50})}
		${ressourcesHelper.addHeaderRessource({"tagType":"script", "href":"static/top.js", "order":55})}
	<#else>
		<#if logHelper??>
			${logHelper.stackDebugMessage("ecoWeb.addHeaderScripts : ERROR cannot add footer script, missing 'ressourcesHelper' component")}
		</#if>
	</#if>
	<#return "" />
</#function>

<#function addFooterScripts()>
	<#if ressourcesHelper??>
		${ressourcesHelper.addFooterRessource({"tagType":"script", "src":"static/bottom.js", "order":60})}
		${ressourcesHelper.addFooterRessource({"tagType":"link", "href":"static/bottom.css", "rel":"stylesheet", "order":65})}
	<#else>
		<#if logHelper??>
			${logHelper.stackDebugMessage("ecoWeb.addFooterScripts : ERROR cannot add footer script, missing 'ressourcesHelper' component")}
		</#if>
	</#if>
	<#return "" />
</#function>

<#--  inspired by : https://subscription.packtpub.com/book/web_development/9781782163824/1/ch01lvl1sec06/top-9-features-you-need-to-know-about -->


<#macro displayPublicationDate content>
	<#if ((content.displayDate)?? && content.displayDate == "true")>
		<p>Publié le : <em>${content.date?string("dd MMMM yyyy")}</em></p>
	</#if>
</#macro>

<#macro displayTags content, label="Tags">
	<#if (content.tags)?? && (content.tags?size > 0) >
		<#if (label)?? && (label?has_content)>
			<span>Tags : </span>
		</#if>
		<ul class="content_tags">
		<#list content.tags as tag>
			<li>${tag}</li>
		</#list>
		</ul>
	</#if>
</#macro>

<#function retrieveMetaDescription content>
	<#local desc = propertiesHelper.retrieveAndDisplayConfigText("site.header.description")>
	<#if (content.exerpt)??>
		<#local desc = content.exerpt>
	</#if>
	<#return desc />
</#function>

<#function retrieveMetaKeyWord content>
	<#local keywords = propertiesHelper.retrieveAndDisplayConfigText("site.header.keyword")>
	<#return keywords />
</#function>

<#macro imageHero>

	<#local imageProp = propertiesHelper.retrieveAndDisplayConfigText("site.imageHero.image", true)>
	<#if logHelper??>
		${logHelper.stackDebugMessage("ecoWeb.imageHero : site.imageHero.image = " + imageProp)}
	</#if>
	
	<#if !imageProp?has_content>
		<#nested>
	<#else>
		<#local image= common.buildRootPathAwareURL(imageProp)>
		<#local categoryContent=propertiesHelper.retrieveAndDisplayConfigText("site.imageHero.category")>
		<#local orderBy="order">
		
		<section class="imageHeroSection"> 
			<div class="imageHeroContainer"> 
				<img src="${image}"> 
				<div class="imageHeroMask"></div> 
			</div>
			
			<#nested>
			
			<#local imageHeroBlocks = org_openCiLife_blocks?filter(b -> b.status=="published")?filter(b-> sequenceHelper.seq_containsOne(b.category!"__empty_categ__", categoryContent))?sort_by(orderBy)>
			<#if (langHelper)??>
				<#local imageHeroBlocks = imageHeroBlocks?filter(ct -> langHelper.isCorectLang(ct, langHelper.getLang(content)))>
			</#if>
			<#if logHelper??>
				${logHelper.stackDebugMessage("ecoWeb.imageHero : category :" + categoryContent + " (published, filtered by lang if resquired) used with " + imageHeroBlocks?size + " blocks")}
			</#if>
			
			<#list imageHeroBlocks as imageHeroBlock>
				<@block.buildWithCategory imageHeroBlock categoryContent orderBy />
			</#list>
		</section>
	</#if>
</#macro>

<#macro bob block>
	A Basic BOB template !!!!
</#macro>
