<#function getComponnentInfo>
	<#return {"componnentVersion":2, "name":"subcontent", "description":"Add subContent in content", "recommandedNamespace":"subcontent", "version":"0.1.0", "require":[{"value":"includeContent", "type":"contentHeader"}], "uses":[{"value":"langHelper", "type":"lib"}, {"value":"logHelper", "type":"lib"}]}>
</#function>

<#function init>
	<#return "" />
</#function>

<#function registerDefaultHooks()>
	<#local registerComponnentHooks = true>
	<#if registerComponnentHooks>
		${hookHelper.registerHook("afterBody", "subcontent.build", false)}
		${hookHelper.registerHook("afterBlockBody", "subcontent.build", false)}
	</#if>
</#function>

<#function addHeaderScripts()>
	<#return "" />
</#function>

<#function addFooterScripts()>
	<#return "" />
</#function>

<#macro generateAnchor subContent>
	<#if (subContent.anchorId)??>
		id="<#escape x as x?xml>${subContent.anchorId}</#escape>"<#rt>
	</#if>
</#macro>

<#macro generateCssClass subContent customCssClass="">
	<#local classes = "subContent">
	<#if (subContent.specificClass)?? && subContent.specificClass?has_content>
		<#local classes = classes + " " + subContent.specificClass>
	</#if>
	<#if (customCssClass)?? && customCssClass?has_content>
		<#local classes = classes + " " + customCssClass>
	</#if>
	<#lt>class="<#escape x as x?xml>${classes}</#escape>"
</#macro>

<#-- build an block or table listing (using Boostrap)
param : content : content to search for include content
-->
<#macro build content>
	<#if (content.includeContent)??>
		<#if logHelper??>
			<@logHelper.debug "(sub)Content should be included"/>
		</#if>
		<#local allSubContents = db.getPublishedContent(content.includeContent.type)>
		<#local displaySelf = (content.includeContent.displaySelf)!"disabled">
		<#local includeContentFilter = content.includeContent.category!"all">
		<#local noCnontentText = content.includeContent.noContentText!"">
		<#local maxItemToDisplay = content.includeContent.limit!-1>
		
		<#local subContents = allSubContents>
		
		<#--  filter by categories -->
		<#local subContents = subContents?filter(ct -> (includeContentFilter == "all" || sequenceHelper.seq_containsOne(includeContentFilter, ct.category)))>
		
		<#--  -- remove self if presents -->
		<#if (displaySelf == "none")>
			<#local subContents = subContents?filter(ct -> ct.title != content.title)>
		</#if>
		
		<#if (langHelper)??>
			<#local currentLang = langHelper.getLang(content)>
			<#local subContents = subContents?filter(ct -> langHelper.isCorectLang(ct, currentLang))>
			<#if logHelper??>
				<@logHelper.debug "Included Type " + content.includeContent.type + " ("+allSubContents?size+") (category : " + includeContentFilter + "), for lang " + currentLang + " : number of subContent to display " + subContents?size/>
			</#if>
		<#else>	
			<#if logHelper??>
				<@logHelper.debug "Included Type " + content.includeContent.type + " ("+allSubContents?size+") (category : " + includeContentFilter + ") : number of subContent to display " + subContents?size/>
			</#if>
		</#if>
		
		<#local specificClass = (content.includeContent.specificClass)!"">
		<div <@generateAnchor content/><#if specificClass?? && specificClass?has_content> class="${specificClass}"</#if>>
		<#if (subContents?size > 0)>
			<#if (content.includeContent.title)??>
				<div class="title">${content.includeContent.title}</div>
			</#if>
			<#local listDisplayType = (content.includeContent.display.type)!"bullet">
			<#local subContentDisplayContentMode = (content.includeContent.display.content)!"link">
			<#local subContentBeforeTitleImage = (content.includeContent.display.beforeTitleImage)!"">
			
			<#local subContentmodaleCloseButton = (content.includeContent.display.closeButton)!"close">
			<#local subContentMoreInfoLinkLabel = (content.includeContent.display.moreInfoLinkLabel)!"">
			<#local subContentDisplayTags = (content.includeContent.display.displayTags)!false>
			
			<#local hasSubTemplate = (content.includeContent.display.subTemplate)!"">
			
			<#if logHelper??>
				<@logHelper.debug "listDisplayType = " + listDisplayType + " subContentDisplayContentMode = " + subContentDisplayContentMode/>
			</#if>
			
			<#local theModalId = "basicModal">
			<#if (subContentDisplayContentMode == "modal")>
				<@modal.buildModalContainer theModalId, subContentmodaleCloseButton, subContentMoreInfoLinkLabel/>
			</#if>
			
			<#if (hasSubTemplate)?? && hasSubTemplate?has_content>
				<#local subTemplateInterpretation = "<@${hasSubTemplate} content subContents />"?interpret>
				<@subTemplateInterpretation/>
				<#return>
			<#elseif (listDisplayType == "table")>
				<table class="${listDisplayType}_list content_type_${subContentDisplayContentMode}">
					<thead>
						<tr>
							<#if (content.includeContent.display.columns)??>
								<#list content.includeContent.display.columns as column>
									<#if ((column.name)?? && (column.name != ""))>
							<th>${column.name}</th>
									</#if>
								</#list>
							<#else>
								No colums for this table.
							</#if>
							<#if (subContentDisplayContentMode == "modal")>
							<th></th>
							</#if>
						</tr>
					</thead>
					<tbody>
			<#else>
				<div class="${listDisplayType}_list">
			</#if>
			<#list subContents?sort_by("order") as subContent>
				<#if (maxItemToDisplay!=-1) && (subContent?counter > maxItemToDisplay) >
					<#break>
				</#if>
				<#local altSubContent = commonInc.propagateContentChain(subContent) />
				
				<#local subContentCategory = (altSubContent.category)!"__none__">
				<#local specificContentClass = (content.includeContent.display.specificClass)!"">
				<#local displayTitle = true>
				<#if (content.includeContent.display.displayTitle)?? && content.includeContent.display.displayTitle == false>
					<#local displayTitle = false>
				</#if>
				<#local collapseClass = "">
				<#local collapseId = "">
				<#local isSelf = altSubContent.title == content.title>
				<#local featauredText = "">
				
				<#if isSelf>
					<#local specificContentClass += " self">
					<#switch displaySelf>
						<#case "disabled">
							<#local specificContentClass += " self_disabled">
						<#break>
						<#break>
						<#case "none">
							<#-- Nothing to do content is not in list -->
						<#break>
						<#break>
					</#switch>
				</#if>
				
				<#if (altSubContent.specificClass)??>
					<#local specificContentClass += " " + altSubContent.specificClass>
				</#if>
				
				<#if (altSubContent.featured)??>
					<#local specificContentClass = specificContentClass + " featured">
					<#if (altSubContent.featured.text)??>
						<#local featauredText = altSubContent.featured.text>
					</#if>
				</#if>
				
				<#if (altSubContent.includeContent.hooks)??>
					<#if logHelper??>
						${logHelper.stackDebugMessage("SubContent.build : Custom Hooks detected for : " + altSubContent.uri + " : " + common.toString(content.includeContent.hooks))}
					</#if>
					<#if hookHelper??>
						<#if logHelper??>
							${logHelper.stackDebugMessage("SubContent.build : Registering Custom Hooks")}
						</#if>
						${hookHelper.registerHookFromJson(altSubContent.includeContent.hooks)}
					</#if>
				</#if>
				
				<#if (listDisplayType == "table")>
					<#local specificClassForContent = specificContentClass>
					<#if (altSubContent.featured)??>
						<#local specificClassForContent = specificClassForContent + "featured">
					</#if>
					
					<tr <@generateAnchor altSubContent/> <#rt>
						<#if (subContentDisplayContentMode == "link")>
							<#lt> data-href="${common.buildRootPathAwareURL(altSubContent.uri)}"<#rt>
						</#if>
						
						<#if (specificContentClass != "")>
							<#lt> class="${specificContentClass}"
						</#if>
						
					<#lt>>
						<#local isFirstColumn = true>
						<#if ((content.includeContent.display.columns)?? && content.includeContent.display.columns?is_sequence)>
							<#list content.includeContent.display.columns?sort_by("order") as column>
								<td>
									<#if isFirstColumn>
										<#if featauredText?has_content>
											<span class="featured_label">${featauredText}</span>
										</#if>
									</#if>
									<#if (column.attr)?? && column.attr?has_content>
										<#local contentAtttrName = column.attr>
										<#if (altSubContent[contentAtttrName])??>
											<#local contentAtttrValue = altSubContent[contentAtttrName]>
											
											<#if contentAtttrName=="title">
												<#if (subContentBeforeTitleImage?has_content)>
													<img src="${common.buildRootPathAwareURL(subContentBeforeTitleImage)}" class="widget_title_image icon"/>
												</#if>
											</#if>
											<#if (contentAtttrValue?is_date)>
												${contentAtttrValue?string('dd/MM/yyyy à HH:mm')}
											<#elseif contentAtttrName=="contentImage">
												<#if (altSubContent.contentImage)??>
													<@common.addImageIcon altSubContent.contentImage "" altSubContent.title/>
												</#if>
											<#else>
												${contentAtttrValue}
											</#if>
										</#if>
									</#if>
								</td>
								<#local isFirstColumn = false>
							</#list>
						</#if>
						<#if (subContentDisplayContentMode == "modal")>
						<td>
							<@modal.extractContentForModal altSubContent, "button", listDisplayType, "voir plus", subContentDisplayTags />
						</td>
						</#if>
						<#if subContentDisplayContentMode == "visible">
						<td class="${listDisplayType}_content">
							${altSubContent.body!""}
						</td>
						</#if>
					</tr>
				<#elseif listDisplayType == "steps" >
					<#if featauredText?has_content>
						<div class="featured_label">${featauredText}</div>
					</#if>
					<#if hookHelper??>
						<@hookHelper.hook "beforeItemSubContent" altSubContent/>
					</#if>
					<div <@generateAnchor altSubContent/> class="${listDisplayType} content_type_${subContentDisplayContentMode} ${specificContentClass}">
						<#if hookHelper??>
							<@hookHelper.hook "beginItemSubContent" altSubContent/>
						</#if>
						<div class="step_icon">
							<#if (altSubContent.contentImage)??>
								<@common.addImageIcon altSubContent.contentImage listDisplayType+"_image" altSubContent.title/>
							</#if>
							<div class="vertical_line"></div>
						</div>
						<div class="step_content">
							<#if (altSubContent.exerpt??)>
								<div class="${listDisplayType}_exerpt">
									${altSubContent.exerpt!""}
								</div>
							</#if>
							
							<#if subContentDisplayTags>						
								<span class="${listDisplayType}_tags"><#rt>
								<@ecoWeb.displayTags altSubContent ""/>
								</span>
							</#if>
							
							<#if displayTitle>						
								<h3 class="${listDisplayType}_title"><#rt>
								<#if (subContentBeforeTitleImage?has_content)>
									<img src="${common.buildRootPathAwareURL(subContentBeforeTitleImage)}" class="widget_title_image icon"/>
								</#if>
									<#t>${altSubContent.title!""}
								<#lt></h3>
							</#if>
							<div class="${listDisplayType}_content<#if subContentDisplayContentMode == "modalLink"> contentHidden</#if>">
								${altSubContent.body!""}
							</div>
						</div>
						<#if hookHelper??>
							<@hookHelper.hook "endItemSubContent" altSubContent/>
						</#if>
					</div>
					<#if hookHelper??>
						<@hookHelper.hook "afterItemSubContent" altSubContent/>
					</#if>
				<#else><#-- NOT a table -->
					<#if hookHelper??>
						<@hookHelper.hook "beforeItemSubContent" altSubContent/>
					</#if>
					<div <@generateAnchor altSubContent/> class="${listDisplayType} content_type_${subContentDisplayContentMode} ${specificContentClass}">
						<#if featauredText?has_content>
							<div class="featured_label">${featauredText}</div>
						</#if>
						<#if hookHelper??>
							<@hookHelper.hook "beginItemSubContent" altSubContent/>
						</#if>
						<#switch listDisplayType>
							<#case  "link">
								<a href="${common.buildRootPathAwareURL(altSubContent.uri)}" class="widget_link">
							<#break>
							<#case "collapse_block">
								<#local collapseClass = "collapse">
								<#local collapseId = common.randomNumber()>
								<a data-toggle="collapse" href="#${collapseId}" aria-expanded="false" aria-controls="${collapseId}">
							<#break>
							<#case "card">
								<#if (subContentDisplayContentMode == "modalLink")>
									<@modal.extractContentForModal altSubContent, "link", listDisplayType, "", [], subContentDisplayTags/>
								<#elseif (subContentDisplayContentMode == "link")>
									<a href="${common.buildRootPathAwareURL(altSubContent.uri)}">
								</#if>
							<#break>
						</#switch>
						<#if listDisplayType == "card">
							<#if (altSubContent.contentImage??)>
								<#if (altSubContent.contentImage)??>
									<@common.addImageIcon altSubContent.contentImage listDisplayType+"_image" altSubContent.title/>
								</#if>
							</#if>
						</#if>
						<#if subContentDisplayTags>						
							<span class="${listDisplayType}_tags"><#rt>
							<@ecoWeb.displayTags altSubContent ""/>
							</span>
						</#if>
						<#if displayTitle>						
							<h3 class="${listDisplayType}_title"><#rt>
							<#if (subContentBeforeTitleImage?has_content)>
								<img src="${common.buildRootPathAwareURL(subContentBeforeTitleImage)}" class="widget_title_image icon"/>
							</#if>
								<#t>${altSubContent.title!""}
							<#lt></h3>
						</#if>
						
						<#if listDisplayType == "collapse_block">
							<div class="${listDisplayType}_content ${collapseClass}" id="${collapseId}">
						</#if>
						
						<#if listDisplayType != "card">
							<#if (altSubContent.contentImage??)>
								<#if (altSubContent.contentImage)??>
								<@common.addImageIcon altSubContent.contentImage listDisplayType+"_image" altSubContent.title/>
								</#if>
							</#if>
						</#if>
						
						<#if (altSubContent.exerpt??)>
							<div class="${listDisplayType}_exerpt">
								${altSubContent.exerpt!""}
							</div>
						</#if>
						
						<#if listDisplayType == "collapse_block">
							</a>
						</#if>
						
						<#if (subContentDisplayContentMode == "modal")>
							<@modal.extractContentForModal altSubContent, "button", listDisplayType, "voir plus", subContentDisplayTags />
						</#if>
						<#if (subContentDisplayContentMode == "visible" || subContentDisplayContentMode == "modalLink")>
							<div class="${listDisplayType}_content<#if subContentDisplayContentMode == "modalLink"> contentHidden</#if>">
								${altSubContent.body!""}
							</div>
						</#if>
						<#if (listDisplayType == "link" || subContentDisplayContentMode == "modalLink") || subContentDisplayContentMode == "link" || subContentDisplayContentMode == "modal">
							</a>
						</#if>
						<#if listDisplayType == "collapse_block">
							</div>
						</#if>
						<#if hookHelper??>
							<@hookHelper.hook "endItemSubContent" altSubContent/>
						</#if>
					</div>
					<#if hookHelper??>
						<@hookHelper.hook "afterItemSubContent" altSubContent/>
					</#if>
				</#if> <#-- end onf contentDisplayType "switch" -->
			</#list>
			<#if (listDisplayType == "table")>
					</tbody>
				</table>
			<#else>
				</div>
			</#if>
			<#if (content.includeContent.showMore)??>
				<div class="showMoreContainer">
				<a class="showMore<#if (content.includeContent.showMore.specificClass)??> ${content.includeContent.showMore.specificClass}</#if>" href="${content.includeContent.showMore.to}">
					${content.includeContent.showMore.label}
				</a>
				</div>
			</#if>
		<#else>
			<span class="noContent">${noCnontentText}</span>			
		</#if>
		</div>
		<#if hookHelper??>
			<@hookHelper.hook "afterSubContent" content/>
		</#if>
	<#else>
		<#if logHelper??>
			<@logHelper.debug "No SubContent for this content"/>
		</#if>
	</#if>
</#macro>

<#macro stepAlternateSubTemplate theContent items>
	<#local className = "hsitoAlternate">
	<#local maxItemToDisplay = theContent.includeContent.limit!-1>
	<#local specificContentClass = (theContent.includeContent.display.specificClass)!"">
	<#local displayTitle = true>
	<#if (theContent.includeContent.display.displayTitle)?? && theContent.includeContent.display.displayTitle == false>
		<#local displayTitle = false>
	</#if>
	<#local subContentDisplayContentMode = (theContent.includeContent.display.content)!"link">
	<#local subContentDisplayTags = (theContent.includeContent.display.displayTags)!false>
	<#local currentIndex = 0>
	
	
	<div class="${className}_list content_type_${subContentDisplayContentMode}">
		<div class="middleLine"></div>
		<div class="${className}_items">
			<#list items?sort_by("order") as subContent>
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
				
				<#if (altSubContent.includeContent.hooks)??>
					<#if logHelper??>
						${logHelper.stackDebugMessage("SubContent.build(stepAlternateSubTemplate) : Custom Hooks detected for : " + altSubContent.uri + " : " + common.toString(content.includeContent.hooks))}
					</#if>
					<#if hookHelper??>
						<#if logHelper??>
							${logHelper.stackDebugMessage("SubContent.build(stepAlternateSubTemplate) : Registering Custom Hooks")}
						</#if>
						${hookHelper.registerHookFromJson(altSubContent.includeContent.hooks)}
					</#if>
				</#if>
				
				<#local blockPosition = "left">
				<#if currentIndex%2 == 1>
					<#local blockPosition = "right">
				</#if>
				
				<div class="${className} ${className}_${blockPosition}">
					<div class="lineMarker"></div>
						<div class="${className}_block">
						<#if featauredText?has_content>
							<span class="featured_label">${featauredText}</span>
						</#if>
						<div class="${className}_body">
							<#if (altSubContent.contentImage)??>
								<@common.addImageIcon altSubContent.contentImage className+"_image" altSubContent.title/>
							</#if>
							<#if (altSubContent.exerpt??)>
								<div class="${className}_exerpt">
									${altSubContent.exerpt!""}
								</div>
							</#if>
							
							<#if subContentDisplayTags>						
								<span class="${className}_tags"><#rt>
								<@ecoWeb.displayTags altSubContent ""/>
								</span>
							</#if>
							
							<#if displayTitle>						
								<h3 class="${className}_title"><#rt>
								<#if (subContentBeforeTitleImage?has_content)>
									<img src="${common.buildRootPathAwareURL(subContentBeforeTitleImage)}" class="widget_title_image icon"/>
								</#if>
									<#t>${altSubContent.title!""}
								<#lt></h3>
							</#if>
							<div class="${className}_content">
								${altSubContent.body!""}
							</div>
						</div>
					</div>
				</div>
				<#local currentIndex = currentIndex +1>
			</#list>
		</div>
	<div>
</#macro>
