<#function getComponnentInfo>
	<#return {"componnentVersion":2, "name":"stripe", "description":"allow online payement with Stripe", "version":"0.1.0", "recommandedNamespace":"stripe", "require":[{"value":"stripe", "type":"contentHeader"}], "uses":[{"value":"langHelper", "type":"lib"}, {"value":"logHelper", "type":"lib"}]}>
</#function>

<#global pageUseStripe=false />

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
	<#if pageUseStripe>
		<#if ressourcesHelper??>
			${ressourcesHelper.addFooterRessource({"tagType":"script", "src":"templates/components/stripe/copyToAssets/noAgregation/stripe_button_v3.js", "order":55})}
		<#else>
			<#if logHelper??>
				${logHelper.stackDebugMessage("stripe.addFooterScripts : ERROR cannot add footer script, missing 'ressourcesHelper' component")}
			</#if>
		</#if>
		<#else>
		<#if logHelper??>
			${logHelper.stackDebugMessage("stripe.addFooterScripts : tripe component are not use in this page, no script added")}
		</#if>
	</#if>
	<#return "" />
</#function>

<#macro build theContent>
	<#if (theContent.stripe)?? && (theContent.stripe.productId)??>
		<#local productId = theContent.stripe.productId>
		
		<#if logHelper??>
			${logHelper.stackDebugMessage("stripe.build : adding Stripe component. Page already contain Stripe component : " + pageUseStripe?string("yes","no"))}
		</#if>
		<#global pageUseStripe=true />
	
		<stripe-buy-button
		  buy-button-id="${productId}"
		  publishable-key="${webleger.component.stripe.apiKey}">
		</stripe-buy-button>
	<#else>
		<#if logHelper??>
			<#local stripeInfo = "NO stripe content Header">
			<#if (theContent.stripe)??>
				<#local stripeInfo = common.toString(theContent.stripe)>
			</#if>
			${logHelper.stackDebugMessage("stripe.build : ERROR : content does NOT contain stripe Product ID : " + stripeInfo + ", for content URI : " + theContent.uri!"NO_URI")}
		</#if>
	</#if>
</#macro>
