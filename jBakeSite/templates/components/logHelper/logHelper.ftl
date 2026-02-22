<#function getComponnentInfo>
	<#return {"componnentVersion":1, "name":"logHelper", "description":"Helper for debugging", "recommandedNamespace":"logHelper", "version":"0.1.0", "require":[{"value":"site.debug.enabled", "type":"config"}, {"value":"common", "type":"lib"}]}>
</#function>

<#function init>
	<#return "" />
</#function>

<#function isEnabled()>
	<#return (config.site_debug_enabled)?? && config.site_debug_enabled == "true">
</#function>

<#-- display debug messages in HTML page. Only displayend if "site.debug.enabled" exist and is "true"
param : message : the message to display (a String)
-->
<#macro debug message...>
	<#if isEnabled()>
		<div class="debug">
		<#if (message?is_hash)>
			<#-- Called using <@macro debug "A message"> OR <@macro debug "first message", "Second message"> OR <@macro debug "first message", ["Second message", "And an other"]> -->
			<#list message as key, value>
				<#if value?is_sequence>
					<#list value as aMessage>
						<p class="debug"> ${key} = ${aMessage}</p>
					</#list>
				<#else>
					<p class="debug">${key} = ${value}</p>
				</#if>
			</#list>
		<#elseif (message?is_sequence)>
			<#-- Called using <@macro debug ["A message"]> OR <@macro debug ["first message", "Second message"]> -->
			<#list message as value>
				<#if value?is_sequence>
					<#list value as aMessage>
						<p class="debug"> ${aMessage}</p>
					</#list>
				<#elseif (value?is_boolean)>
					<p class="debug">${value?string('yes', 'no')}</p>
				<#else>
					<p class="debug">${value}</p>
				</#if>
			</#list>
		<#else>
			<p class="debug"> ${message}</p>
		</#if>
		</div>
	</#if>
</#macro>


<#assign stackedDebugMessage = "">
<#-- allow function to debug. Message are stacked and rendered at the end of the page. -->
<#function stackDebugMessage message>
	<#local strMessage = message>
	<#if !strMessage?is_string && !(common)??>
		<#local strMessage = "LogHelper : !!! message is NOT a string and common module is NOT aviable to transform : the message is lost !!!">
	<#elseif common??>
		<#local strMessage = common.toString(message)>
	</#if>
	<#if !strMessage?is_string>
		<#return "">
	</#if>
	<#assign stackedDebugMessage = stackedDebugMessage + "<br/>" + strMessage>
	<#return ""/>
</#function>

<#macro displayDebugFunctionMessages content>
	<@debug stackedDebugMessage />
</#macro>