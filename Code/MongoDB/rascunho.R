library(mongolite)
connection_string = 'mongodb://andrey:1234@localhost/politics'
iris=iris
iris_collection = mongo(collection="iris", db="politics", url=connection_string) 
iris_collection$insert(mtcars)
iris_collection$aggregate('[{"$group":{"_id":"$Species", "Count": {"$sum":"Sepal_Length"}}}]')
iris_collection$find('{"Species": {"$binary": "1"}}')
