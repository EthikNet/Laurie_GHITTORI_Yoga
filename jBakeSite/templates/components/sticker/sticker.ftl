<#function getComponnentInfo>
	<#return {"componnentVersion":1, "name":"sticker", "description":"Display stickers on content", "version":"0.1.0", "recommandedNamespace":"sticker", "require":[{"value":"includeContent", "type":"contentHeader"}], "uses":[{"value":"langHelper", "type":"lib"}, {"value":"logHelper", "type":"lib"}]}>
</#function>

<#function init>
	<#return "" />
</#function>

<#macro build content>
	<#if (content.stickers)??>
		<#if logHelper??>
			<@logHelper.debug "stickers : bulding stickers for : " + content.uri/>
		</#if>
		<#if (content.stickers.data)??>
			<#if logHelper??>
				<@logHelper.debug "Sticker : Nbsticker :  " + content.stickers.data?size/>
			</#if>
			<#local stickerListDisposition = content.stickers.disposition!"center">
			<#local stickerListSpecificClass = "sticker_list sticker_" + stickerListDisposition>
			
			<#if (content.stickers.specificClass)??>
				<#local stickerListSpecificClass = stickerListSpecificClass + " " + content.stickers.specificClass>
			</#if>
			<div class="${stickerListSpecificClass}">
			<#list content.stickers.data as aSticker>
				<#if logHelper??>
					<@logHelper.debug "Stickers : buliding sticker : " + common.toString(aSticker)/>
				</#if>
				
				<#local specificClass = "">
				<#if (aSticker.specificClass)??>
					<#local specificClass = specificClass + " " + aSticker.specificClass>
				</#if>
				
				<span  class="sticker ${specificClass}">
					<#if (aSticker.image)??>
						<#local stickerImage = aSticker.image>
						<#local imageSpecificClass = "">
						<#if (aSticker.imageSpecificClass)??>
							<#local imageSpecificClass = imageSpecificClass + aSticker.imageSpecificClass>
						</#if>
						<@common.addImageIcon aSticker.image imageSpecificClass/>
					</#if>
					<#if (aSticker.label)??>
						${aSticker.label}
					</#if>
					</span>
			</#list>
			</div>
		<#else>
			<span>stickers present dans l'entête de contenu, mais pas de "data" détecté</span>
		</#if>
	</#if>
</#macro>
