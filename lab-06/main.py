#!/usr/bin/env python3

# graphs
import networkx as nx
# plots
import matplotlib.pyplot as plt

def plot(G: nx.Graph):
    G.nodes[0]['pos'] = (0, 1)
    G.nodes[1]['pos'] = (1, 1)
    G.nodes[2]['pos'] = (2, 2)
    G.nodes[3]['pos'] = (2, 1)
    G.nodes[4]['pos'] = (2, 0)
    G.nodes[5]['pos'] = (3, 1.5)
    G.nodes[6]['pos'] = (3, 0.5)
    G.nodes[7]['pos'] = (4, 1)
    G.nodes[8]['pos'] = (5, 1)
    plt.figure()
    positions = nx.get_node_attributes(G, 'pos')
    nx.draw(G, positions, with_labels = True)
    weights = nx.get_edge_attributes(G, 'weight')
    nx.draw_networkx_edge_labels(G, positions, edge_labels = weights)
    plt.show()

# duration table
a = 3
b = 5
c = 2
d = 4
e = 3
f = 1
g = 4
h = 3
i = 3
j = 2
k = 5

G = nx.Graph()

G.add_nodes_from(range(0, 9))

G.add_edge(0, 1, weight = a)
G.add_edge(1, 2, weight = b)
G.add_edge(1, 3, weight = c)
G.add_edge(1, 4, weight = d)
G.add_edge(2, 5, weight = e)
G.add_edge(3, 5, weight = f)
G.add_edge(5, 7, weight = g)
G.add_edge(3, 6, weight = h)
G.add_edge(4, 6, weight = i)
G.add_edge(6, 7, weight = j)
G.add_edge(7, 8, weight = k)

print("nodes: ", G.nodes())
print("edges: ", G.edges())

plot(G)

# find critical path using dijkstra algorithm
path = G.subgraph(nx.dijkstra_path(G, 0, 8))
plt.figure()
positions = nx.get_node_attributes(path, 'pos')
nx.draw(path, positions, with_labels = True)
weights = nx.get_edge_attributes(path, 'weight')
nx.draw_networkx_edge_labels(path, positions, edge_labels = weights)
plt.show()


edges = path.edges.data('weight')
total_weight = 0
count = 0
for (_, _, weight) in edges:
    count += 1
    total_weight += weight
print("Number of works in critical path: ", count)
print("Total work duration: ", total_weight)
