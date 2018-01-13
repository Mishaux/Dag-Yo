class Vertex < ApplicationRecord
  has_many :incoming_edges, class_name: 'Edge', foreign_key: 'to_id'
  has_many :outgoing_edges, class_name: 'Edge', foreign_key: 'from_id'
  has_many :next_vertices, through: :outgoing_edges, source: 'to'
  has_many :previous_vertices, through: :incoming_edges, source: 'from'

  # This the meat of the excercize.
  def find_max_path_length_recursively
    if self.outgoing_edges.exists?
      available_path_lengths = self.next_vertices.map do |vertex|
        [vertex.id, 1 + vertex.find_max_path_length_recursively]
      end
      longest = available_path_lengths.max{|a,b| a[1] <=> b[1]}[1]
      return longest
    else
      return 0;
    end
  end

  # Find and store longest path using bottom up traversal.
  # Might be less memory intensive if graphs were known to be extremely long and tightly branched with few terminal nodes?
  def self.reset_max_path_lengths
    Vertex.all.map{|vertex| vertex.update_attribute(:max_hops_to_end, nil)}

    # These will all be terminal nodes
    current_vertices = Vertex.where('id NOT IN (?)', Edge.pluck(:from_id))
    step = 0;

    loop do
      current_vertices.map{|vertex| vertex.update_attribute(:max_hops_to_end, step)}
      step += 1
      current_vertices = current_vertices.map(&:previous_vertices).flatten
      break if current_vertices.empty?
    end
  end

  def self.validate_hop_counts
    Vertex.all.map{|v| v.max_hops_to_end == v.find_max_path_length_recursively}.all?
  end

  def self.serialize_all_for_cytoscape
    Vertex.all.map do |vertex|
      {data: {id: vertex.id, name: vertex.find_max_path_length_recursively}}
    end
  end

  def self.scramble
    Edge.destroy_all
    Vertex.destroy_all

    20.times do
      Vertex.create
    end

    Vertex.all.map do |vertex|
      rand(1..3).times do |index|
        from = vertex.id + 1
        to = vertex.id + (Vertex.count - 1)
        new_edge = Edge.new(from_id: from, to_id: rand(from..to))
        if new_edge.valid?
          new_edge.save
        end
      end
    end

    Vertex.reset_max_path_lengths
  end
end
