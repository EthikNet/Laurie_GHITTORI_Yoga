<#function getComponnentInfo>
	<#return {"componnentVersion":2, "name":"block", "description":"Add blocks in content", "recommandedNamespace":"block", "version":"0.1.0", "require":[{"value":"sequenceHelper", "type":"lib"}, {"value":"hookHelper", "type":"lib"}, {"value":"common", "type":"lib"}, {"value":"org_openCiLife_blocks", "type":"contentType"}], "uses":[{"value":"langHelper", "type":"lib"}, {"value":"logHelper", "type":"lib"}, {"value":"subTemplate", "type":"contentHeader"}]}>
</#function>

<#function init>
	<#return "" />
</#function>

<#function registerDefaultHooks()>
	<#local registerComponnentHooks = true>
	<#if registerComponnentHooks>
		${hookHelper.registerHook("afterBody", "block.build", false)}
	</#if>
</#function>

<#function addHeaderScripts()>
	<#return "" />
</#function>

<#function addFooterScripts()>
	<#return "" />
</#function>


<#macro build theContent>
	<#if (theContent.includeBlocks)??>
		<#if (theContent.includeBlocks.category)??>
			<@buildWithCategory theContent theContent.includeBlocks.category "order" theContent.includeBlocks/>
		<#elseif (theContent.includeBlocks.data)??>
			<#list theContent.includeBlocks.data as blokcConfig>
				<@buildWithCategory theContent blokcConfig.category "order" blokcConfig/>
			</#list>
		</#if>
	</#if>
</#macro>

<#function getBlocks theContent categoryFilter="" orderBy="", blockConfig={}>
	<#if !(blockConfig?has_content) && (theContent.includeBlocks)??>
		<#local blockConfig = theContent.includeBlocks>
	<#else>
		<#local blockConfig = blockConfig>
	</#if>
	
	<#if !(categoryFilter?has_content) && (blockConfig)??>
		<#local categoryFilter = blockConfig.category>
	</#if>
	<#if !(orderBy?has_content) && (blockConfig)?? && (blockConfig.order)??>
		<#local orderBy = blockConfig.order>
	<#else>
		<#local orderBy = "order">
	</#if>
	
	<#local blocks = org_openCiLife_blocks?filter(b -> b.status=="published")?filter(b-> sequenceHelper.seq_containsOne(b.category!"__empty_categ__", categoryFilter))?sort_by(orderBy)>
	<#if (langHelper)??>
		<#local blocks = blocks?filter(ct -> langHelper.isCorectLang(ct, langHelper.getLang(content)))>
	</#if>
	<#if logHelper??>
		<@logHelper.debug "Blocks : Liste of blocks for " + categoryFilter + " (published, filtered by lang if resquired) with " + blocks?size + " blocks"/>
	</#if>
	<#return blocks>
</#function>

<#-- build a content with blocks
    @param categoryFilter category to filter to get blocks. "config.site_homepage_category" for HomePage.
-->
<#macro buildWithCategory theContent categoryFilter orderBy="order", blockConfig={}>
	<@generateBlockWrap theContent, blockConfig>
		<#list getBlocks(theContent, categoryFilter, order, blockConfig) as block>
			<#local blockCategory = blockConfig.category!"__empty_categ__">
			<#if (sequenceHelper.seq_containsOne(blockCategory, categoryFilter))>
		 		<#local alteredBlock = commonInc.propagateContentChain(block) />
				<#local subTemplateName = "defaultBlockSubTemplate">
				<#if (block.subTemplate??)>
					<#local subTemplateName=block.subTemplate>
				</#if>
				
				<#local subTemplateInterpretation = "<@${subTemplateName} alteredBlock />"?interpret>
				<@subTemplateInterpretation/>
			</#if>
	  	</#list>
  	</@generateBlockWrap>
  	${common.clearGeneratedAnchorId()}
</#macro>

<#macro generateBlockWrap theContent blockConfig>
	<#if !(blockConfig)?has_content && (theContent.includeBlocks)??>
		<#local blockConfig = theContent.includeBlocks>
	</#if>
	
	<#if logHelper??>
		<#local wrapParams = "NONE">
		<#if (blockConfig)?? && (blockConfig.wrap)??>
			<#local wrapParams =  common.toString(blockConfig.wrap)>
		</#if>
		${logHelper.stackDebugMessage("block.generateBlockWrap : checking for block wraping in params : " + wrapParams)}
	</#if>
	<#local wrapEnable = false>
	<#local specificClass = "block_wraping">
	<#local wrapTag = "div">
	<#if (blockConfig)?? && (blockConfig.wrap)?? && (blockConfig.wrap.enable)?? && (blockConfig.wrap.enable == "true")>
		<#if logHelper??>
			${logHelper.stackDebugMessage("block.generateBlockWrap : wraping is enabled")}
		</#if>
		<#local wrapEnable = true>
	</#if>
	
	<#if (blockConfig)?? && (blockConfig.wrap)?? && (blockConfig.wrap.specificClass)?? && blockConfig.wrap.specificClass?has_content>
		<#local specificClass = specificClass + " " + blockConfig.wrap.specificClass>
	</#if>
	<#if (blockConfig)?? && (blockConfig.wrap)?? && (blockConfig.wrap.tag)?? && blockConfig.wrap.tag?has_content>
		<#local wrapTag = blockConfig.wrap.tag>
	</#if>
	
	<#if wrapEnable>
		<${wrapTag} class="${specificClass}">
	</#if>
	<#nested>
	
	<#if wrapEnable>
		</${wrapTag}>
	</#if>
	
</#macro>

<#macro generateAnchor block>
	<#local theAnchorId = "">
	<#if (block.anchorId)??>
		<#local theAnchorId = block.anchorId>
	<#else>
		<#local theGeneratedAnchorId = common.getGeneratedAnchorId(block.title)>
		<#if theGeneratedAnchorId?has_content>
			<#local theAnchorId = theGeneratedAnchorId>
		</#if>
	</#if>
	<#if theAnchorId?has_content>
		id="<#escape x as x?xml>${theAnchorId}</#escape>"<#rt>
	</#if>
</#macro>

<#macro generateCssClass block customCssClass="">
	<#local classes = "block">
	<#if (block.specificClass)?? && block.specificClass?has_content>
		<#local classes = classes + " " + block.specificClass>
	</#if>
	<#if (customCssClass)?? && customCssClass?has_content>
		<#local classes = classes + " " + customCssClass>
	</#if>
	<#lt>class="<#escape x as x?xml>${classes}</#escape>"
</#macro>

<#macro generateTitle block contentImageBefore=false>
	<#if (block.title)?? && block.title?has_content && !((block.displayTitle)?? && block.displayTitle == "false")>
		<#local titleTag = "h2">
		<#if (block.titleTag)??>
			<#local titleTag = block.titleTag>
		</#if>
		<${titleTag} class="blockTitle"><#escape x as x?xml>
		<#if (block.beforeTitleImage?has_content)>
			<@common.addImageIcon block.beforeTitleImage "block_title_image" block.title/>
		</#if>
		<#if (contentImageBefore)>
			<@common.addImageIcon block.contentImage "block_title_image" block.title/>
		</#if>
		${block.title}</#escape>
		</${titleTag}>
	</#if>
</#macro>

<#macro generateBodyContent block>
	<#if hookHelper??>
		<@hookHelper.hook "beforeBlockContent" block/>
	</#if>
	<div class="blockContent">
		<#if hookHelper??>
			<@hookHelper.hook "beforeBlockBody" block/>
		</#if>
		${block.body}
		<#if hookHelper??>
			<@hookHelper.hook "afterBlockBody" block/>
		</#if>
	</div>
	<#if hookHelper??>
		<@hookHelper.hook "afterBlockContent" block/>
	</#if>
</#macro>

<#macro defaultBlockSubTemplate block>
	<@imageRightSubTemplate block />
</#macro>

<#macro imageRightSubTemplate block>
	<div <@generateAnchor block/> <@generateCssClass block "imageRightSubTemplate"/>>
		<@generateTitle block/>
		<div class="blockBody">
			<@generateBodyContent block/>
			<#if (block.contentImage)??>
				<@common.addImageIcon block.contentImage "blockIcon" block.title/>
			</#if>
		</div>
	</div>
</#macro>

<#macro imageLeftSubTemplate block>
	<div <@generateAnchor block/> <@generateCssClass block "imageLeftSubTemplate"/>>
		<@generateTitle block/>
		<div class="blockBody">
			<#if (block.contentImage)??>
				<@common.addImageIcon block.contentImage "blockIcon" block.title/>
			</#if>
			<@generateBodyContent block/>
		</div>
	</div>
</#macro>

<#macro imageLeftTitleAndContentSubTemplate block>
	<div <@generateAnchor block/> <@generateCssClass block "imageLeftTitleAndContentSubTemplate"/>>
		<#if (block.contentImage)??>
				<@common.addImageIcon block.contentImage "blockIcon" block.title/>
		</#if>
		<div class="groupe_content">
			<@generateTitle block/>
			<div class="blockBody">
				<@generateBodyContent block/>
			</div>
		</div>
	</div>
</#macro>

<#macro imageRightTitleAndContentSubTemplate block>
	<div <@generateAnchor block/> <@generateCssClass block "imageRightTitleAndContentSubTemplate"/>>
		<div class="groupe_content">
			<@generateTitle block/>
			<div class="blockBody">
				<@generateBodyContent block/>
			</div>
		</div>
		<#if (block.contentImage)??>
				<@common.addImageIcon block.contentImage "blockIcon" block.title/>
		</#if>
	</div>
</#macro>

<#macro imageBeforeTitleSubTemplate block customCssStyle="">
	<div <@generateAnchor block/> <@generateCssClass block "imageBeforeTitleSubTemplate"/> <#if customCssStyle?has_content>style="${customCssStyle}"</#if>>
		<@generateTitle block true/>
		<div class="blockBody">
			<@generateBodyContent block/>
		</div>
	</div>
</#macro>

<#macro noImageSubTemplate block customCssStyle="">
	<div <@generateAnchor block/> <@generateCssClass block "noImageSubTemplate"/> <#if customCssStyle?has_content>style="${customCssStyle}"</#if>>
		<@generateTitle block/>
		<div class="blockBody">
			<@generateBodyContent block/>
		</div>
	</div>
</#macro>

<#macro backGroundImageCoverSubTemplate block>
	<#local customCssStyle = "background-image: url('"+common.buildRootPathAwareURL(block.contentImage)+"'); background-repeat: no-repeat; background-size: cover; background-position: center center;">
	<@noImageSubTemplate block customCssStyle/>
</#macro>


<#macro backGroundImageContainSubTemplate block>
	<#local customCssStyle = "background-image: url('"+common.buildRootPathAwareURL(block.contentImage)+"'); background-repeat: no-repeat; background-size: contain;">
	<@noImageSubTemplate block customCssStyle/>
</#macro>

<#macro imageHeroSubTemplate block>
	<section class="imageHeroSection">
	<div class="imageHeroContainer">
		<img src="${common.buildRootPathAwareURL(block.contentImage)}"/>
		<div class="imageHeroMask"></div>
	</div>
	<@noImageSubTemplate block "position:relative"/>
	</section>
</#macro>

