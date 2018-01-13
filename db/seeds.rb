# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


vertices = [
  {
    max_hops_to_end: 4,
  },
  {
    max_hops_to_end: 2,
  },
  {
    max_hops_to_end: 0,
  },
  {
    max_hops_to_end: 3,
  },
  {
    max_hops_to_end: 1,
  },
  {
    max_hops_to_end: 2,
  },
  {
    max_hops_to_end: 1,
  },
  {
    max_hops_to_end: 0,
  },
  {
    max_hops_to_end: 0,
  },
]

Vertex.create(vertices)

edges = [
  {
    from_id: 1,
    to_id: 4
  },
  {
    from_id: 1,
    to_id: 2
  },
  {
    from_id: 2,
    to_id: 3
  },
  {
    from_id: 2,
    to_id: 7
  },
  {
    from_id: 4,
    to_id: 9
  },
  {
    from_id: 4,
    to_id: 5
  },
  {
    from_id: 4,
    to_id: 6
  },
  {
    from_id: 5,
    to_id: 8
  },
  {
    from_id: 5,
    to_id: 9
  },
  {
    from_id: 6,
    to_id: 7
  },
  {
    from_id: 7,
    to_id: 8
  },
]

Edge.create(edges)
