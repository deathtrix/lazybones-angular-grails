<div crud-breadcrumbs="list"></div>

<h2>${resourceName} List</h2>
<div flash-message ></div>

<p><button crud-button="create" ></button></p>

<div class="panel panel-default">
  <div class="panel-heading">
    <h3 class="panel-title"><i class="fa fa-filter"></i> Filter List</h3>
  </div>
  <div class="panel-body">
<div class="row">
<form class="form"><% domainProperties.take(4).each { property -> %>
	<div class="form-group col-md-3">
		<label for="filter.${property.name}">${property.label}</label>
		<%= renderInput(property, 'ctrl.filter', ['ng-model-options' : '{ debounce: 500 }']) %>
    </div><% } %>
</form>
</div>
  </div>
</div>

<table id="list" class="table table-striped table-bordered table-hover">

    <thead sort-header ng-model="ctrl.sort" on-sort="ctrl.reload()">
        <th sortable-column title="Id" property="id"></th><% domainProperties.take(4).each { property -> %>
		<th sortable-column title="${property.label}" property="${property.name}"></th><% } %>
        <th>&nbsp;</th>
    </thead>
    <tbody>
        <tr class="animate-repeat" ng-repeat="item in ctrl.${moduleName}List">
            <td><a href="#/show/{{item.id}}">{{item.id}}</a></td><% domainProperties.take(4).each { property -> %>
			<td>{{ ${ renderDisplay(property, 'item')} }}</td><% } %>
            <td>
                <button crud-button="edit" item="item" ></button>
                <button crud-button="delete" item="item" after-action="ctrl.reload()"></button>
            </td>
        </tr>
    </tbody>
</table>

<div pagination total-items="ctrl.${moduleName}List.getTotalCount()" items-per-page="ctrl.pageSize" ng-model="ctrl.page" ng-change="ctrl.load()"></div>
