<#function getComponnentInfo>
	<#return {"componnentVersion":1, "name":"sequenceHelper", "description":"Helper for sequences", "recommandedNamespace":"sequenceHelper", "version":"0.1.0"}>
</#function>

<#function init>
	<#return "" />
</#function>

<#-- Search if an element on a list, belong to another list 
param : aSequence : the sequence to search for matches
param : lookupItems : item or items to search for
param : **default** : , : autoSplitChar : String containing this Char will be converted to Sequence with autoSplitChar as separator
return : true in a least one lookupItems is found in aSequence
-->
<#function seq_containsOne aSequence lookupItems = "" autoSplitChar = ",">
	<#assign found=false>
	
	<#assign transformedASequence=aSequence>
	<#assign transformedLookupItems=lookupItems>
	
	<#if autoSplitChar?? && autoSplitChar != "">
		<#if (aSequence?is_string && aSequence?contains(autoSplitChar))>
			<#assign transformedASequence = splitStringToSequence(aSequence)>
		</#if>
		
		<#if (lookupItems?is_string && lookupItems?contains(autoSplitChar))>
			<#assign transformedLookupItems=lookupItems?split(r"\s*,\s*", "r")>
		</#if>
	
	</#if>
	
	<#if (transformedLookupItems?is_sequence)>
		<#if (transformedASequence?is_sequence)>
			<#list transformedLookupItems as item>
				<#if (!found)>
					<#assign found = transformedASequence?seq_contains(item)>
				</#if>
			</#list>
		<#else> <#-- transformedASequence is not a Sequence, but transformedLookupItems IS -->
			<#assign found = transformedLookupItems?seq_contains(transformedASequence)>
		</#if>
	<#else> <#-- transformedLookupItems is not a Sequence -->
		<#if (transformedASequence?is_sequence)>
			<#assign found = transformedASequence?seq_contains(transformedLookupItems)>
		<#else> <#-- both params are NOT lists -->
			<#assign found = transformedLookupItems == transformedASequence>
		</#if>>
	</#if>
	
	<#if logHelper??>
		<#if found>
			${logHelper.stackDebugMessage("seq_containsOne (data) " + aSequence + "  contains at least one (filter) : " + lookupItems)}
		<#else>
			${logHelper.stackDebugMessage("seq_containsOne (data) " + aSequence + " NOT contains any (filter) : " + lookupItems)}
		</#if>
	</#if>
	
	<#return found>
</#function>

<#-- convert a String to a Sequence
param : value : the String to convert
param : **default** : , : autoSplitChar : String containing this Char will be converted to Sequence with autoSplitChar as separator
return : A sequence with all elements after splitting
-->
<#function splitStringToSequence stringValue autoSplitChar = ",">
	<#if (stringValue?is_string && stringValue?contains(autoSplitChar))>
		<#assign sequence=stringValue?split(r"\s*,\s*", "r")>
	<#else>
		<#assign sequence=[stringValue]>
	</#if>
	
	<#return sequence>
</#function>