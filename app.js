var SearchResult = React.createClass({displayName: "SearchResult",
  render: function() {
    return (
      React.createElement("a", {href: "#", className: "list-group-item active"}, 
        React.createElement("h4", {className: "list-group-item-heading"}, this.props.heading), 
        React.createElement("p", {className: "list-group-item-text"}, this.props.subheading)
      )
    );
  }
});

var SearchResults = React.createClass({displayName: "SearchResults",
  render: function() {
    var renderSearchResults = function() {
      this.props.results.map(function(result) {
        return React.createElement('SearchResult', {heading: 'foo', subheading: 'bar'});
      });
    };

    
    return (
      React.createElement("div", null, 
        React.createElement("div", {className: "row"}, 
          React.createElement("div", {className: "col-md-12"}, 
            React.createElement("form", {className: "navbar-form navbar-left", role: "search"}, 
              React.createElement("div", {className: "form-group"}, 
                React.createElement("input", {type: "text", className: "form-control"})
              ), 
              React.createElement("button", {type: "submit", className: "btn btn-default"}, 
                "Search"
              )
            )
          )
        ), 
        React.createElement("div", {className: "row"}, 
          React.createElement("div", {className: "col-md-12"},
            renderSearchResults()
          )
        )
      )
    );
  }
});

document.addEventListener("DOMContentLoaded", function() {
  React.render(
    React.createElement(SearchResults, {results: [1,2,3]}),
    document.getElementById('app')
  );
});
