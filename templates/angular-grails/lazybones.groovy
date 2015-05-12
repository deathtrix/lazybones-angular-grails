import org.apache.commons.io.FileUtils
import static groovy.io.FileType.FILES

List.metaClass.collectWithIndex = { yield ->
	def collected = []
	delegate.eachWithIndex { listItem, index ->
		collected << yield(listItem, index)
	}

	return collected
}

def params = [:]

String installDirName = "install"
File installDir = new File(templateDir, installDirName)

params.appName = ask("Define the name for your project [${projectDir.name}]: ", projectDir.name, "appName")
params.angularVersion = ask("Defined the version of AngularJS you want in your project [1.3]: ", "1.3", "angularVersion")
params.grailsVersion = ask("Defined the version of Grails you want in your project [3.0.1]: ", "3.0.1", "grailsVersion")
def angularModule = params.appName.split('-').toList().collectWithIndex {part, i -> i == 0? part : part.capitalize()}.join()
params.angularModule = ask("Define value for your main AngularJS module [${angularModule}]: ", angularModule, "angularModule")
def group = params.appName.replaceAll('-', '.')
params.group = ask("Define the value for your application group [${group}]: ", group, "group")
params.version = ask("Define value for your application 'version' [0.1]: ", "0.1", "version")
params.warName = ask("Define the name for your war file [${params.appName}.war]: ", "${params.appName}.war", "warName")

processTemplates 'gradle.properties', params
processTemplates "${installDirName}/app/**/*", params

def processFile = { File baseDirectory, File file ->
	String relativePath = file.path - baseDirectory.path
	String groupPath = params.group.replace('.', '/')		
	String destinationPath = relativePath.replace("_groupPath_", groupPath)
		
	File destination = new File(templateDir, destinationPath)
	FileUtils.copyFile(file, destination)
}

def addApplicationInit = {
	File sourceDir = new File(projectDir, "grails-app/init/")
	File destinationDir = new File(sourceDir, "${params.group.replace('.', '/')}/")
	File source = new File(sourceDir, "Application.groovy")

	// modify file
	def functionRegex = /package (\$\{applicationName\})/
	source.text.replaceAll(functionRegex, "")
	source.text = source.text.replaceAll(functionRegex) { all, matched ->
		"package ${params.group}"
	}
	FileUtils.moveFileToDirectory(source, destinationDir, true)
}

File appDirectory = new File(installDir, "app")	
appDirectory.eachFileRecurse(FILES) { processFile(appDirectory, it) }

FileUtils.copyDirectory new File(installDir, "angular/${params.angularVersion}"), templateDir

FileUtils.deleteDirectory(installDir)

addApplicationInit()
