<#function getComponnentInfo>
	<#return {"componnentVersion":1, "name":"laurieYoga", "description":"laurieYoga Template", "recommandedNamespace":"laurieYoga", "uses":[{"value":"logHelper", "type":"lib"}]}>
</#function>

<#function init>
	<#return "" />
</#function>

<#macro blogCard contentHolder subContents>
	<#local featauredText = "">
	<#local specificContentClass = "">
	<#local specificClass = "">
	<#if (contentHolder??) && (contentHolder.includeContent)??>
		<#if (contentHolder.includeContent.specificClass)??>
			<#local specificClass = contentHolder.includeContent.specificClass>
		</#if>
		<#if (contentHolder.includeContent.display)?? && (contentHolder.includeContent.display.specificClass)?? >
			<#local specificContentClass = contentHolder.includeContent.display.specificClass>
		</#if>
	</#if>
	<#local maxItemToDisplay = contentHolder.includeContent.limit!-1>
	<div class="card_list ${specificClass}">
		<#list subContents?sort_by("order") as subContent>
			<#if (maxItemToDisplay!=-1) && (subContent?counter > maxItemToDisplay) >
				<#break>
			</#if>
			<#local altSubContent = commonInc.propagateContentChain(subContent) />
			<#if (altSubContent.featured)??>
				<#local specificContentClass = specificContentClass + " featured">
				<#if (altSubContent.featured.text)??>
					<#local featauredText = altSubContent.featured.text>
				</#if>
			</#if>
			<#if hookHelper??>
				<@hookHelper.hook "beforeItemSubContent" altSubContent/>
			</#if>
			<div <#if altSubContent??><@subcontent.generateAnchor altSubContent/></#if> class="blogCard card ${specificContentClass}">
				<#if featauredText?has_content>
					<div class="featured_label">${featauredText}</div>
				</#if>
				<#if hookHelper??>
					<@hookHelper.hook "beginItemSubContent" altSubContent/>
				</#if>
				
				<#if (altSubContent.tags)?? && (altSubContent.tags?size > 0) >
					<ul class="subContent_tags">
					<#list altSubContent.tags as tag>
						<li class="subContent_tag">${tag}</li>
					</#list>
					</ul>
				</#if>
				<a href="${common.buildRootPathAwareURL(altSubContent.uri)}" class="blog_link">
				<h3>${altSubContent.title}</h3>
				<#if (altSubContent.contentImage??)>
					<#if (altSubContent.contentImage)??>
						<@common.addImageIcon altSubContent.contentImage "blogCard_image" altSubContent.title/>
					</#if>
				</#if>
				<#if (altSubContent.exerpt??)>
					<div class="blogCard_exerpt">
						${altSubContent.exerpt!""}
					</div>
				</#if>
				</a>
				<#if hookHelper??>
					<@hookHelper.hook "endItemSubContent" altSubContent/>
				</#if>
			</div>
			<#if hookHelper??>
				<@hookHelper.hook "afterItemSubContent" altSubContent/>
			</#if>
		</#list>
		<#if (content.includeContent.showMore)??>
			<div class="showMoreContainer">
				<a class="showMore<#if (content.includeContent.showMore.specificClass)??> ${content.includeContent.showMore.specificClass}</#if>" href="${content.includeContent.showMore.to}">
					${content.includeContent.showMore.label}
				</a>
			</div>
		</#if>
	</div>
</#macro>
