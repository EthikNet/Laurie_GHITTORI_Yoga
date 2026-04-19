<#include "header.ftl">

	<#if (content.title)??>
	<div class="page-header">
		<h1><#escape x as x?xml>${content.title}</#escape></h1>
	</div>
	<#else></#if>
	
	<p>${content.body}</p>

<#include "footer.ftl">