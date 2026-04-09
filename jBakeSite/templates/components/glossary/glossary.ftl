<#function getComponnentInfo>
	<#return {"componnentVersion":2, "name":"glossary", "description":"Add definition to some word", "version":"0.0.1", "recommandedNamespace":"glossary", "contentChainBefore":true, "require":[{"value":"propertiesHelper", "type":"lib"}, {"value":"component.glossary.terms", "type":"config"}], "uses":[{"value":"logHelper", "type":"lib"}]}>
</#function>

<#function init>
	<#return "" />
</#function>

<#function handleContentChain content>
	<#return hightlightGlossaryWords(content) />
</#function>

<#function registerDefaultHooks()>
<#return "" />
</#function>

<#function addHeaderScripts()>
	<#return "" />
</#function>

<#function addFooterScripts()>
	<#return "" />
</#function>

<#global securedGlossaryData = []>

<#function hightlightGlossaryWords theContent>
	<#assign alteredContent = theContent>
	
	<#if !((theContent.enableGlossary)?? && theContent.enableGlossary=="false")>
		<#if (alteredContent.body)?? && alteredContent.body?has_content>
			<#assign newContent = alteredContent.body>
			<#local startSecureMarker = "II--II">
			<#local endSecureMarker = "II/--II">
			<#local postLinkImg = "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"24\" height=\"24\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><circle cx=\"12\" cy=\"12\" r=\"10\"></circle><path d=\"M12 16v-4\"></path><path d=\"M12 8h.01\"></path></svg>">
			
			<#if securedGlossaryData?size == 0>
				<#global securedGlossaryData = secureGlossary(startSecureMarker , endSecureMarker)>
			</#if>
			
			<#list securedGlossaryData as element>
				<#local specificClassTerm = "">
				<#local originalContainTerm = false>
				<#if (element.specificClass)??>
					<#local specificClassTerm = " " +element.specificClassTerm>
				</#if>
				<#local specificClassDef = "">
				<#if (element.specificClassDef)??>
					<#local specificClassDef = " " +element.specificClassDef>
				</#if>
				
				<#-- support for or "|" operator in word for example "mobile|smartphone" -->
				<#local words = element.term?split("|")>
				
				<#list words as aWord>
					<#local enhancedTerm = "(\\b"+aWord+"\\b)">
					<#if logHelper??>
				 		${logHelper.stackDebugMessage("glossary.hightlightGlossaryWords  : replacing term : " + element.term + " (adapted as : " + enhancedTerm + ")")}
				 	</#if>
				 	<#assign newContent = newContent?replace(enhancedTerm, "<a tabindex=\"0\" class=\"glossay_term"+specificClassTerm+"\" role=\"button\" data-toggle=\"popover\" data-trigger=\"focus\" data-html=\"true\" title=\"$1\" data-content=\""+element.def+"\">$1"+postLinkImg+"</a>", "rm")>
				</#list>
			</#list>
			<#assign newContent = newContent?replace(startSecureMarker, "")>
			<#assign newContent = newContent?replace(endSecureMarker, "")>
					
			<#assign alteredContent = alteredContent + {"body": newContent}>
			<#-- <#if logHelper??>
		 		${logHelper.stackDebugMessage("glossary.hightlightGlossaryWords : RETURN altered body : " + alteredContent.body)}
		 	</#if> -->
		</#if>
	</#if>
	<#return alteredContent />
</#function>

<#function secureGlossary startSecureMarker endSecureMarker>
	<#local glossaryDataRaw = propertiesHelper.retrieveAndDisplayConfigText("component.glossary.terms")>
	<#if glossaryDataRaw?has_content>
		<#local glossaryData = propertiesHelper.parseJsonProperty(glossaryDataRaw)>
	
		<#-- collect all terms -->
		<#local glosaryDataSequence = glossaryData.data?sequence>
		
		<#local allTermsPatern = "(">
		<#list glosaryDataSequence as element>
			<#local allTermsPatern = allTermsPatern + "\\b"+ element.term + "\\b|">
		</#list>
		<#local allTermsPatern = allTermsPatern?remove_ending("|")>
		<#local allTermsPatern = allTermsPatern + ")">
		<#if logHelper??>
			${logHelper.stackDebugMessage("glossary.secureGlossary : allTermsPatern : " + allTermsPatern)}
		</#if>
		
		<#-- secure definition (avoid replacement of existing terms in definition) -->
		<#list glosaryDataSequence as element>
			<#local securedDef = element.def?replace(allTermsPatern, startSecureMarker+"$1"+endSecureMarker, "r")>
			<#local securedElement = element>
			<#local securedElement = element + {"def" : securedDef}>
			<#local securedGlossaryData = securedGlossaryData + [securedElement]>
		</#list>
		
		<#if logHelper??>
	 		${logHelper.stackDebugMessage("glossary.secureGlossary : secured glossary : " + common.toString(securedGlossaryData))}
	 	</#if>
	</#if>
	<#return securedGlossaryData>
</#function>