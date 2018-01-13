function initCytoscape(data) {
  cytoscape({
    container: document.querySelector('#cy'),

    boxSelectionEnabled: false,
    autounselectify: true,

    layout: {
      name: 'dagre'
    },

    style: [
      {
        selector: 'node',
        style: {
          'content': 'data(name)',
          'text-valign': 'center',
          'text-halign': 'center',
          'color': '#ffffff',
          'font-weight': 'bold',
          'background-color': '#11479e'
        }
      },

      {
        selector: 'edge',
        style: {
          'curve-style': 'bezier',
          'control-point-step-size': 40,
          'width': 4,
          'target-arrow-shape': 'triangle',
          'line-color': '#9dbaea',
          'target-arrow-color': '#9dbaea'
        }
      }
    ],

    elements: data,

    layout: {
      name: 'circle',
      directed: true
    }
  });
}

$(function() {
    $.ajax({
        url: '/data',
        method: 'GET',
        dataType: 'json',
        success: function(response) {
          initCytoscape(response);
        },
        error: function() {alert('error getting data');}
    });
});
