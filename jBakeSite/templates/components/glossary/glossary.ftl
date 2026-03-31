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

<#function hightlightGlossaryWords theContent>
	<#assign alteredContent = theContent>
	
	<#if !((theContent.enableGlossary)?? && theContent.enableGlossary=="false")>
		<#if (alteredContent.body)??>
			<#assign newContent = alteredContent.body>
			
			<#local glossaryDataRaw = propertiesHelper.retrieveAndDisplayConfigText("component.glossary.terms")>
			<#if glossaryDataRaw?has_content>
				<#local glossaryData = propertiesHelper.parseJsonProperty(glossaryDataRaw)>
				<#list glossaryData.data as element>
					<#local specificClassTerm = "">
					<#if (element.specificClass)??>
						<#local specificClassTerm = " " +element.specificClassTerm>
					</#if>
					<#local specificClassDef = "">
					<#if (element.specificClassDef)??>
						<#local specificClassDef = " " +element.specificClassDef>
					</#if>
					<#local wholeWord = true>
					<#if (element.wholeWord)?? && element.wholeWord == "false">
						<#local wholeWord = false>
					</#if>
					<#local enhancedTerm = element.term>
					<#if wholeWord>
						<#-- support for or "|" operator in word for example "mobile|smartphone" -->
						<#if enhancedTerm?contains("|")>
							<#local words = enhancedTerm?split("|")>
							<#local enhancedTerm = "">
							<#list words as aWord>
								<#local enhancedTerm = enhancedTerm + "|\\b"+aWord+"\\b">
							</#list>
							<#local enhancedTerm = enhancedTerm?remove_beginning("|")>
						<#else>
							<#local enhancedTerm = "\\b"+element.term+"\\b">
						</#if>
					</#if>
					<#if logHelper??>
				 		${logHelper.stackDebugMessage("glossary.hightlightGlossaryWords : term to search for : " + enhancedTerm + " (original : "+ element.term + ")")}
				 	</#if>
					<#assign newContent = newContent?replace("("+enhancedTerm+")", "<div class=\"glossay_term"+specificClassTerm+"\">$1<div class=\"glossay_def"+specificClassDef+"\">"+element.def+"</div></div>", "r")>
				</#list>
						
				<#assign alteredContent = alteredContent + {"body": newContent}>
				<#-- <#if logHelper??>
			 		${logHelper.stackDebugMessage("glossary.hightlightGlossaryWords : RETURN altered body : " + alteredContent.body)}
			 	</#if> -->
			</#if>
		</#if>
	</#if>
	<#return alteredContent />
</#function>