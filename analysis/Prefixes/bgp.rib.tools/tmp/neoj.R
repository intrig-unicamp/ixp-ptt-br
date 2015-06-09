library(RNeo4j)

address.ip="192.168.56.101"

graph = startGraph(paste("http://",address.ip,":7474/db/data/",sep=""))

graph$version

clear(graph)

mugshots = createNode(graph, "Bar", name = "Mugshots", location = "Downtown")
parlor = createNode(graph, "Bar", name = "The Parlor", location = "Hyde Park")
createNode(graph, "Bar", name = "Cheer Up Charlie's", location = "Downtown")

mugshots$location

nicole = createNode(graph, name = "Nicole", status = "Student")
addLabel(nicole, "Person")

nicole = updateProp(nicole, eyes = "green", hair = "blonde")

addLabel(nicole, nicole$status)

nicole = deleteProp(nicole, "status")

nicole

addConstraint(graph, "Person", "name")
addConstraint(graph, "Bar", "name")

getConstraint(graph)

charlies = getUniqueNode(graph, "Bar", name = "Cheer Up Charlie's")

createRel(nicole, "DRINKS_AT", mugshots, on = "Fridays")
createRel(nicole, "DRINKS_AT", parlor, on = "Saturdays")
rel = createRel(nicole, "DRINKS_AT", charlies, on = "Everyday")

rel$on


query  = "MATCH (p:Person {name:'Nicole'})-[d:DRINKS_AT]->(b:Bar)
          RETURN p.name, d.on, b.name, b.location"

cypher(graph, query)

bars = getLabeledNodes(graph, "Bar")
bars_names = lapply(bars, function(b) b$name)

bars_names
