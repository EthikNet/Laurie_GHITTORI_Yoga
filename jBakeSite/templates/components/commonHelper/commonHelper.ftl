<#function getComponnentInfo>
	<#return {"componnentVersion":1, "name":"commonHelper", "description":"general purpose tools", "recommandedNamespace":"common", "version":"0.1.0", "uses":[{"value":"logHelper", "type":"lib"}]}>
</#function>

<#function init>
	<#return "" />
</#function>

<#-- Build URL, using the root.path if required 
param : relativeUrl : the relative URL to adapt
return : URL prepend with rootPath (if configured)
-->
<#function buildRootPathAwareURL relativeUrl>
	<#assign rootPathAwareURL = relativeUrl>
	
	<#if (content.rootpath)??>
		<#assign rootPathAwareURL = content.rootpath + relativeUrl>
	</#if>
	
	<#return rootPathAwareURL>
</#function>

<#-- search for absolute URL in content and preprend the RootPath
param : text : the teh text to search for relative URL
param : rootPath : default ${content.rootpath} : the rootPath of teh webSite
return : text with URL transformed
-->
<#-- 
<#function findAndReplaceUrlAddAwareRootPath text rootPath = content.rootpath>
	<#assign contentRootPathAwareURL = text>
	
	<#if (config.rootPath)??>
		<#assign contentRootPathAwareURL = text?replace("/images/", rootPath + "/images/", "r")>
	</#if>
	
	<#return contentRootPathAwareURL>
</#function>
 -->

<#-- 
<#function functionExists namespace functionName>
	<#local exists = false>
	<#local includeNameSpace = .vars[namespace]>
	<#local namespaceExists = (includeNameSpace)??>
	
	<#local functionExistsInNamespace = false>
	<#if namespaceExists>
		<#local functionExistsInNamespace = ("${namespace}.${functionName}"?interpret)??>
		<#if functionExistsInNamespace>
			<#local exists = true>
		</#if>
	</#if>
	
	<#if logHelper??>
		${logHelper.stackDebugMessage("functionExists : namespace '" +namespace +"' exists : " + namespaceExists?string('yes', 'no') + " ==> '" + functionName + "()' exists ? " + functionExistsInNamespace?string('yes', 'no'))}
	</#if>
	<#return exists>
</#function>


<#function callFunctionIfExists namespace functionName>
	<#if functionExists(namespace, functionName)>
		<#if logHelper??>
			${logHelper.stackDebugMessage("callFunctionIfExists : calling '" +namespace +"." + functionName + "' (==>" + "${namespace}.${functionName}()" +")")}
		</#if>
		<#assign tempAutoLoadVar = "${namespace}.${functionName}"?interpret>
	</#if>
	<#return "">
</#function>
 -->
 
 <#-- determine if a String is an embeded svg or not -->
 <#function isSvg stringData>
	<#local isSvg = false>
	<#if stringData?starts_with("<svg")>
		<#local isSvg = true>
	</#if>
	<#return isSvg>
</#function>

<#macro addImageIcon image cssClass="" alternativeText="" wrapTo="div class=\""+cssClass+"_wraper\"">
	<#if (image)??>
		<#if common.isSvg(image)>
			<@wrap wrapTo>
				<span <#if cssClass?has_content>class="${cssClass}"</#if><#if alternativeText?has_content> alt="${alternativeText}"</#if>>
					${image}
				</span>
			</@wrap>
		<#else>
			<@wrap wrapTo>
				<img src="${common.buildRootPathAwareURL(image)}"<#if cssClass?has_content> class="${cssClass}"</#if><#if alternativeText?has_content> alt="${alternativeText}"</#if>/>
			</@wrap>
		</#if>
	</#if>
</#macro>

<#macro wrap wrapTo="">
	<#if (wrapTo)?? && wrapTo?has_content>
		<${wrapTo}><#nested></${wrapTo!keep_before(" ")}>
	<#else>
		<#nested>
	</#if>
</#macro>
 
<#-- convert hash, sequence, boolean to String
param : theObject : object to transform in String
-->
<#function toString theObject>
	<#local stringVal = "">
	<#if theObject?is_string>
		<#local stringVal = "\"" + theObject + "\"">
	<#elseif (theObject?is_hash)>
		<#local stringVal = stringVal + "{" />
		<#local separator = "">
		<#list theObject as key, value>
			<#local stringVal = stringVal + separator + toString(key) + ":"/>
			<#local stringVal = stringVal + toString(value)/>
			<#local separator = ",">
		</#list>
		<#local stringVal = stringVal + "}" />
	<#elseif (theObject?is_sequence)>
		<#local stringVal = stringVal + "[" />
		<#local separator = "">
		<#list theObject as value>
			<#local stringVal = stringVal + separator + toString(value)/>
			<#local separator = ",">
		</#list>
		<#local stringVal = stringVal + "]" />
	<#elseif (theObject?is_boolean)>
		<#local stringVal = stringVal + theObject?string('true', 'false') />
	<#elseif (theObject?is_number)>
		<#local stringVal = stringVal + theObject  />
	<#else>
		<#local stringVal = stringVal + "\"" + theObject + "\"" />
	</#if>
	<#return stringVal>
</#function>

<#assign oldRdnValues = []>
<#function randomNumber salt = 7>
    <#local str= .now?long />
    <#local str = (str * salt)/3 />
    <#local random = str[(str?string?length-13)..] />
    <#local returnVal = random?replace("\\D+", "1", "r") />
    <#list 0..100 as _>
    	<#if  !oldRdnValues?seq_contains(returnVal)>
    		<#break>
    	</#if>
    	<#if logHelper??>
			${logHelper.stackDebugMessage("common.randomNumber : (" + _?counter + ") " + returnVal + " already used, adding 1")}
		</#if>
    	<#local returnVal += 1>
    </#list>
    <#assign oldRdnValues = oldRdnValues + [returnVal]>
    <#return returnVal/>	
</#function>

<#assign allGeneratedAnchorIdByTitle = []>

<#function generatedAnchorId blockTitle>
	<#if logHelper??>
 		${logHelper.stackDebugMessage("generatedAnchorId : generating and storing an id for : " + blockTitle)}
 	</#if>
	<#local generatedAnchorId = common.randomNumber()>
	<#assign allGeneratedAnchorIdByTitle = allGeneratedAnchorIdByTitle + [{"title":blockTitle, "anchorId":generatedAnchorId}]>
	<#return generatedAnchorId>
</#function>

<#function getGeneratedAnchorId blockTitle>
	<#if logHelper??>
 		${logHelper.stackDebugMessage("getGeneratedAnchorId : searching for the eventually generated ID for : '${blockTitle}' in ${allGeneratedAnchorIdByTitle?size} generatedIds")}
 	</#if>
	<#local anchorId = "">
	<#list allGeneratedAnchorIdByTitle as  generatedAnchorIdByTitle>
		<#if generatedAnchorIdByTitle.title == blockTitle>
			<#local anchorId = generatedAnchorIdByTitle.anchorId>
			<#break>
		</#if>
	</#list>
	<#return anchorId>
</#function>

<#function clearGeneratedAnchorId>
	<#if logHelper??>
 		${logHelper.stackDebugMessage("clearGeneratedAnchorId : Clearing generated AnchorsIds")}
 	</#if>
	<#assign allGeneratedAnchorIdByTitle = []>
	<#return "">
</#function>