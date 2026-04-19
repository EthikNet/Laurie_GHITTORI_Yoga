<#if (config.site_langs_default)??>
	<#setting locale=config.site_langs_default>
</#if>
<#import "../components/includes/includes.ftl" as commonInc>
<@commonInc.buildIncludes "components"/>
<#assign alteredContent = commonInc.propagateContentChain(content) />
<!DOCTYPE html>
<html lang="<#if (langHelper)??>${langHelper.getLangForHtmlHeader(alteredContent)}<#elseif (config.site_langs_default)??>${config.site_langs_default}<#else>fr</#if>">
  <head>
    <meta charset="utf-8"/>
    <title><#if (alteredContent.title)??><#escape x as x?xml>${alteredContent.title}</#escape><#else>${propertiesHelper.retrieveAndDisplayConfigText("site.header.title")}</#if></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="${ecoWeb.retrieveMetaDescription(alteredContent)}">
    <meta name="author" content="${propertiesHelper.retrieveAndDisplayConfigText("site.header.author")}">
    <meta name="keywords" content="${ecoWeb.retrieveMetaKeyWord(alteredContent)}">
    <meta name="generator" content="JBake">
    <#if (alteredContent.uri)??>
    	<link rel="canonical" href="${common.getCanonicalUrl()}" />
    </#if>
    <#if alteredContent.type == "org_openCiLife_block" || ((alteredContent.status)?? && alteredContent.status == "draft")>
    	<meta name="robots" content="noindex, nofollow" />
    <#else>
    	<#assign robotsVal = propertiesHelper.retrieveAndDisplayConfigText("site.header.robots")>
    	<#if robotsVal?has_content>
    		<meta name="robots" content="${robotsVal}" />
    	</#if>
    </#if>
    <meta property="og:title" content="<#if (alteredContent.title)??><#escape x as x?xml>${alteredContent.title}</#escape><#else>${propertiesHelper.retrieveAndDisplayConfigText("site.header.title")}</#if>" />
	<meta property="og:type" content="website" />
	<meta property="og:url" content="${common.getCanonicalUrl()}" />
	<#if (alteredContent.contentImage)??>
		<meta property="og:image" content="${common.buildAbsoluteURL(alteredContent.contentImage)}" />
	<#else>
		<meta property="og:image" content="${common.buildRootPathAwareURL(propertiesHelper.retrieveAndDisplayConfigText("site.logoLeft.file"))}" />
	</#if>
	<#if (alteredContent.excerpt)??>
		<meta name="og:description" content="${alteredContent.excerpt}">
	<#else>
		<meta name="og:description" content="${ecoWeb.retrieveMetaDescription(alteredContent)}">
	</#if>
	<meta name="og:locale" content="<#if (langHelper)??>${langHelper.getLangForHtmlHeader(alteredContent)}<#elseif (config.site_langs_default)??>${config.site_langs_default}<#else>fr</#if>">
	<meta name="og:site_name " content="${propertiesHelper.retrieveAndDisplayConfigText("site.header.title")}">
	
	<meta name="twitter:card" content="summary_large_image">
    
    <#if ressourcesHelper??>
    	<@ressourcesHelper.buildExternalInjectionHeader config.site_script_header />
    </#if>
	
	<#-- <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.1/css/all.css" integrity="sha384-50oBUHEmvpQ+1lW4y57PTFmhCaXp0ML5d60M1M7uH2+nqUivzIebhndOJK28anvf" crossorigin="anonymous"> -->

    <#-- Fav and touch icons -->
    <#--<link rel="apple-touch-icon-precomposed" sizes="144x144" href="../assets/ico/apple-touch-icon-144-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="../assets/ico/apple-touch-icon-114-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="../assets/ico/apple-touch-icon-72-precomposed.png">
    <link rel="apple-touch-icon-precomposed" href="../assets/ico/apple-touch-icon-57-precomposed.png">-->
    <link rel="shortcut icon" href="${common.buildRootPathAwareURL(propertiesHelper.retrieveAndDisplayConfigText("site.header.iconShortcut"))}">
  </head>
  <#assign pageSpecificClass = alteredContent.type>
  <#if alteredContent?? && (alteredContent.pageSpecificClass)??>
  	<#assign pageSpecificClass = pageSpecificClass + " " + alteredContent.pageSpecificClass>
  <#else>
    <#assign pageSpecificClass = pageSpecificClass + " ${webleger.site.body.class} ">
  </#if>
  <body class="${pageSpecificClass}">
  <div id="up"></div>
    <div id="wrap">
    	<@ecoWeb.imageHero>
	    <#if (alteredContent.displayPreHeader!"true") != "false">
	    	<div id="preHeader" class="container preHeader ${webleger.site.preheader.class}">
	    		<#if block??>
		    		<div id="preHeader_blocks" class="blocks">
		    			<@block.buildWithCategory content config.site_header_category/>
					</div>
				</#if>
	    	</div>
	    </#if>
    	<#if (alteredContent.displaySiteHeaderTitle!"true") != "false">
    	<div id="header" class="container header ${webleger.site.header.class}" role="banner">
			<div id="pageTitle">
				<#if propertiesHelper.hasConfigValue("site.logoLeft.file")>
				<a href="${config.site_host}/index.html">
					<img src="${common.buildRootPathAwareURL(propertiesHelper.retrieveAndDisplayConfigText("site.logoLeft.file"))}" alt="${propertiesHelper.displayConfigText(propertiesHelper.retrieveAndDisplayConfigText("site.logoLeft.description"))}" id="logoLeft"/>
				</a>
				</#if>
				<h1 id="headerTitle">${propertiesHelper.retrieveAndDisplayConfigText("site.headline")}</h1>
				<#if propertiesHelper.hasConfigValue("site.logoRight.file")>
					<img src="${common.buildRootPathAwareURL(propertiesHelper.retrieveAndDisplayConfigText("site.logoRight.file"))}" alt="${propertiesHelper.displayConfigText(propertiesHelper.retrieveAndDisplayConfigText("site.logoRight.description"))}" id="logoRight"/>
				</#if>
			</div>
		</div>
	</#if>
	
	<div id="beforeMainContent" class="container ${webleger.site.beforeMainContent.class}">
	<#if hookHelper??>
		<@hookHelper.hook "beforeMainContent" content/>
	</#if>
    </div>
    </@ecoWeb.imageHero>
    
    <#assign mainContainerClass = "container" />
    <#if content?? && content.specificClass??>
    	<#assign mainContainerClass = mainContainerClass + " @webleger.site.mainContent.class@ " + content.specificClass>
    </#if>
    <div id="mainContent" class="${mainContainerClass}" role="main">
    <#if content?? && content?has_content>
    	<#if hookHelper?? && hookHelper.hasContributors("topContentContainer")>
    		<div id="topContentContainer" class="${webleger.site.topContentContainer.class}">
			<@hookHelper.hook "topContentContainer" content/>
			</div>
		</#if>
    </#if>