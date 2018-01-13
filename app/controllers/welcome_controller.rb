class WelcomeController < ApplicationController

  def index
  end

  def scramble
    Vertex.scramble

    redirect_to '/'
  end


  def data
    dataset = {
      nodes: Vertex.serialize_all_for_cytoscape,
      edges: Edge.serialize_all_for_cytoscape
    }

    render json: dataset.as_json
  end
end
