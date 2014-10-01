Lazybones Template for Angular Grails
================================
## Getting started

To generate a new project make sure you have lazybones installed (easiest to install through GVM):
```bash
gvm install lazybones
```
Then install the template
```bash
gradlew installAllTemplates
```
Now that you have the template installed locally you can create a new Grails app like this:
```bash
lazybones create angular-grails 0.1 my-project
```

## Running your project
Any new project makes use of the [Grails Gradle plugin](https://github.com/grails/grails-gradle-plugin). You can start the application like this:

```bash
gradlew run
```
You can run all the tests (Groovy and Javascript) like this:
```bash
gradlew test
```
If you want to run just the Jasmine (JavaScript) tests use this command
```bash
gradlew jasmineRun
```

The following will run the Jasmine tests in watch mode (so that tests are rerun when your source changes):
```bash
gradlew jasmineWatch
```

## Generate Scaffolding
You can generate a CRUD AngularJS application based on a domain class by following these steps:

**1. Create a new domain class**
```bash
gradlew grails-create-domain-class -PgrailsArgs=Foo
```

**2. Generate an Angular module based on your domain object**
```bash
lazybones generate module::Foo
```

This will create a module with views, services, controllers, routes, etc. In the example above you can access your app by visiting **/foo.**

## The Grails AngularController
This is a slightly modified version of the standard Grails RestfulController. It adds support for server side paging and can be used exactly the same way the RestfulController is used.

Here's how you would add a REST controller for the Book domain class:
```groovy
class BookController extends AngularController {
    BookController() {
        super(Book)
    }
}
```
## Grails Plugins

This project makes use of the Asset Pipeline along with two AngularJs specific asset pipeline plugins that I developed:

* [Angular Template Asset Pipeline](https://github.com/craigburke/angular-template-asset-pipeline)
* [Angular Annotate Asset Pipeline](https://github.com/craigburke/angular-annotate-asset-pipeline)

## The AngularJS grails module
This project includes an AngularJS module called **grails** that you can include as a dependency in your own angular modules.

### Services

#### CrudResourceFactory

This is a factory that you can use to create CrudResource object to help you make REST calls. 
This is essentially a wrapper for Angular's own **$resource** module but the methods from a CrudResource object return a promise from all its methods and supports paging.

Here's how you would create a CrudResource object
```javascript
function AuthorResource(CrudResourceFactory) {
    // set the rest url and resource name here
    return CrudResourceFactory('/api/author', 'Author');
}

angular.module('exampleApp.authors.services', ['grailsCrud'])
    .factory('AuthorResource', AuthorResource);
```

Once you have a CrudResource object you can use it like this:

```javascript
AuthorResource.list({page: 1}).then(function(items) {
  this.items = items;
  // items also has a getTotalCount function that provides the total item count for paging
  this.totalCount = items.getTotalCount();
});

AuthorResource.create().then(function(item) {
  this.newItem = item;
});

AuthorResource.get(1).then(function(item) {
  this.currentItem = item;
});

var item = {id: 1, title: 'Foo Bar'};
AuthorResource.update(item);

AuthorResource.delete(1);
```
Each of the above functions can also accept an optional success and error callback function:

```javascript
var successFunction = function(response) {
    console.log("It worked!");
};

var errorFunction = function(response) {
    console.log("Uh oh!");
};

AuthorResource.delete(1, successFunction, errorFunction);
````
#### FlashService
Used in conjunction with the **flash-message** directive below. This service allows you to easily set different messages in your app. Each time a flash message is set it overrides the previous one.

```javascript
FlashService.success("Everything is fine");
FlashService.warning("Something bad is about to happen");
FlashService.error("Uh oh, something bad did happen");
FlashService.info("Something good or bad might happen");
FlashService.clear(); // Clear message
```

### Directives

#### crudButton

The click actions of these buttons are automatically set to make the appropriate method call from the default CrudResource. For example, clicking the delete button will call the DefaultResource.delete method.


```html
<button crud-button="delete" item="ctrl.item" ></button>
<button crud-button="edit" item="ctrl.item" ></button>
<button crud-button="save" item="ctrl.item" ></button>
<button crud-button="create" ></button>
```

You can also include an optional **afterAction** parameter to register a callback or **isDisabled** to disable a button.

```html
<button crud-button="delete" item="ctrl.item" after-action="ctrl.logDelete()"></button>
<button crud-button="save" item="ctrl.item" is-disabled="form.$invalid"></button>
```

The button templates are located at:
`/grails-app/assets/vendor/grails/templates/directives/buttons`

#### fieldContainer
This allows you to define a common template for your form fields (similar to the way the Fields plugin does with GSP pages). It includes a label, value and invalid property that are used within the template.

```html
<form name="form" novalidate>
    <div field-container label="Title" value="ctrl.item.title" invalid="form.title.$invalid">
        <input name="title" ng-model="ctrl.item.title" required />
    </div>
</form>
```

The fieldContainer template is located at:
`/grails-app/assets/vendor/grails/templates/directives/fields/field-container.tpl.html`

#### displayField
Like the **fieldContainer** directive above, this defines a template for the displaying the field values (such as on a show page).

```html
<table>
<tbody>
    <tr display-field label="Title" value="ctrl.item.title"></tr>
</tbody>
</table>
```

The displayField template is located at:
`/grails-app/assets/vendor/grails/templates/directives/fields/display-field.tpl.html`


#### flashMessage
This directive is used along with the **FlashService** above to display messages on the page. 
```html
<div flash-message></div>
```

The flash message template is located at:
`/grails-app/assets/vendor/grails/templates/directives/flash-message.tpl.html`

#### sortHeader / sortableColumn
This directive allows you to keep track of the current sort state of a table, and has an onSort callback to allow you to reload your data if need be.

```html
<thead sort-header ng-model="ctrl.sort" on-sort="ctrl.reloadData()">
    <th sortable-column title="Id" property="id"></th>
    <th sortable-column title="Name" property="name"></th>
</thead>
```

The sortable column template is located at:
`/grails-app/assets/vendor/grails/templates/directives/sortable-column.tpl.html`


