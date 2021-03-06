<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main"/>
		<title>Welcome to Grails</title>
	</head>
	<body>
        <div class="col-md-3">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h2 class="panel-title">Application Status</h2>
                </div>
                <div class="panel-body">
                    <ul>
                        <li>Environment: ${grails.util.Environment.current.name}</li>
                        <li>App profile: ${grailsApplication.config.grails?.profile}</li>
                        <li>App version: <g:meta name="info.app.version"/></li>
                        <li>Grails version: <g:meta name="info.app.grailsVersion"/></li>
                        <li>Groovy version: ${GroovySystem.getVersion()}</li>
                        <li>JVM version: ${System.getProperty('java.version')}</li>
                        <li>Reloading active: ${grails.util.Environment.reloadingAgentEnabled}</li>
                        <li>Controllers: ${grailsApplication.controllerClasses.size()}</li>
                        <li>Domains: ${grailsApplication.domainClasses.size()}</li>
                        <li>Services: ${grailsApplication.serviceClasses.size()}</li>
                        <li>Tag Libraries: ${grailsApplication.tagLibClasses.size()}</li>
                    </ul>
                </div>
            </div>

            <div class="panel panel-default">
                <div class="panel-heading">
                    <h2 class="panel-title">Installed Plugins</h2>
                </div>
                <div class="panel-body">
                    <ul>
                        <g:each var="plugin" in="${applicationContext.getBean('pluginManager').allPlugins}">
                            <li>${plugin.name} - ${plugin.version}</li>
                        </g:each>
                    </ul>
                </div>
            </div>


    </div>
        <div class="col-md-9">
            <h1>Angular Grails</h1>
			<p>Congratulations, you have successfully started your first Angular Grails application generated by the <a href="https://github.com/craigburke/lazybones-angular-grails">Lazybones Angular Grails Template</a> </p>
			
		    <p class="alert alert-info"><i class="fa fa-info-circle"></i> Look around, check out the available AngularJS applications in the menu above to see how it all works</p>
			

            <div class="panel panel-default">
                <div class="panel-heading">
                    <h2 class="panel-title">AngularJS Applications</h2>
                </div>
                <div class="panel-body">
                    <ul>
						<g:each var="c" in="${grailsApplication.controllerClasses.findAll{ it.logicalPropertyName != 'assets' }. sort { it.fullName } }">
						<li><a href="${c.logicalPropertyName}"><i class="fa fa-database"></i> ${c.logicalPropertyName.capitalize()} List</a></li>
						</g:each>
                    </ul>
                </div>
            </div>

        </div>

	</body>
</html>
