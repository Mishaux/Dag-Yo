# README
See this app in action http://dag-yo.industriumvita.com/

This little app uses two algorithms to solve the longest possible path from any given node to the furthest terminal node in a DAG.

Since it is part of an application for a web developer job, I made it a web app :)

The primary approach simply takes a node and uses recursion to explore all possible descendant branches, returning the length of the longest leg.

That code is here: https://github.com/Mishaux/Dag-Yo/blob/master/app/models/vertex.rb#L7

I was not meticulous about architectural patterns, wizard level ruby syntax, unit tests, etc. since those weren't really the point. I did keep things mostly tidy.

# The more mundane optimizations

* Given the problem space (a web app), recursing through possibly huge swaths of the vertex and edge tables every time we need to show a hop count is painful. Calculating the hop count at insert time and storing it on the vertex is far better, if possibly a little more brittle.

* If things got very large, we could make recalculation only happen on demand, and/or asynchronously.

* Whatever db work we can do with functions or an insert trigger at the db level will go far faster than finding and instantiating nodes and edges through the ORM one at a time.


# The more interesting optimizations

* I wondered if a bottom up algorithm might be a faster (or less memory intensive) traversal given very long graphs with few terminal nodes. (Like a questionnaire?) Either way, I built out a bottom up approach for validating my recursive approach. It starts with terminal nodes and climbs up, marking the hop count so far on each node as it passes it, until it reaches apex nodes. That code is here: https://github.com/Mishaux/Dag-Yo/blob/master/app/models/vertex.rb#L20

* Since we are storing hop counts on the nodes, we could get even smarter about recalculating after a graph edit.
  * When adding a node above an apex node, we only need to increment the hop count for the new node.
  * When inserting a node anywhere else, we only need to recalculate it's ancestors. I think the bottoms up algorithm might allow us to avoid recursing all ancestors from top to bottom, we could start the step counter at the current node's hop count, then climb up the graph incrementing hop counts that are <= our step count.

* If we stored something like 'in_longest_route' on the edges, we could get even more surgical about some edits. I didn't think this all through carefully, but some dynamics that could help are:
  * Any edge leading in to a terminal node is in a longest path.
  * Any edge leading from an apex node is in a longest path.
  * There will only be one, or tied longest route edges leading out of a node. Either way, when using the bottoms up algorithm and marking longest paths on the way up, the edges reaching in to a node on the current step are always the only longest path edges reaching out of that node so far, the others can be marked non-longest path.
