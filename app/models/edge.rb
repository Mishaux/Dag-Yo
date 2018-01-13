class Edge < ApplicationRecord
  belongs_to :from, class_name: 'Vertex'
  belongs_to :to, class_name: 'Vertex'

  # Prevents unterminated edges
  validates_presence_of :from_id
  validates_presence_of :to_id

  # Prevents duplicated edges
  validates :from, uniqueness: { scope: :to }

  validate :not_self_referential
  validate :enforce_acyclicity

  def not_self_referential
    if from_id == to_id
      self.errors.add(:base, 'Edge must not come from, and connect to, the same vertex.')
    end
  end

  def enforce_acyclicity
    # This approach is overly restrictive.
    # Nodes that are lower in the graph's topology could still have higher ids in the db.
    # Actually proving acyclicity could be another fun problem of its own :)
    if from_id > to_id
      self.errors.add(:base, 'Edge must not run counter to the flow of the graph.')
    end
  end

  def self.serialize_all_for_cytoscape
    Edge.all.map do |edge|
      {data: {source: edge.from_id, target: edge.to_id}}
    end
  end
end
