		</div>
		<img src="${common.buildRootPathAwareURL("org_openCiLife_ecoWeb/images/pageup.svg")}" id="go_to_top" OnClick='window.location.href="#up"' alt="go to top">
		<div id="push"></div>
    </div>
    
    <div id="footer" role="contentinfo">
     <div class="container">
     	<#if block??>
		     <div id="footer_blocks" class="blocks ${webleger.site.footer.class}">
		     	<@block.buildWithCategory content config.site_footer_category/>
		     </div>
	     </#if>
	     <p role="note" class="discret credit">&copy; 2025 | Mixed with <a href="http://getbootstrap.com/">Bootstrap v3.1.1</a> and <a href="https://fontawesome.com/">https://fontawesome.com/</a> | Baked with <a href="http://jbake.org">JBake ${jbake_maven_plugin.version}</a> with recipe from <a href ="https://github.com/OpenCyLife/ecoweb">EcoWeb</a> by <a href="http://www.open-cy.life">open-cy.life</a> and <a href="https://www.ethiknet.fr/webleger/">WebLeger</a> | Version ${version} at ${published_date?datetime}</p>
      </div>
    </div>
    
    <#if hookHelper?? && hookHelper.hasContributors("afterFooter")>
    	<div id="afterFooter_blocks" class="blocks ${webleger.site.afterFooter.class}">
	    	<div class="container">
				<@hookHelper.hook "afterFooter" content/>
			</div>
		</div>
	</#if>
	
	${commonInc.handleComponentLastActions()}
    
    <!-- Javascript here load faster -->
    <#if ressourcesHelper??>
    	<@ressourcesHelper.buildExternalInjectionFooter config.site_script_footer />
    </#if>
  </body>
</html>