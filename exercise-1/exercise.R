# Exercise 1: reading and querying a web API

# Load the httr and jsonlite libraries for accessing data
# You can also load `dplyr` if you wish to use it
library("httr")
library("jsonlite")
library("dplyr")

# Create a variable for the API's base URI (https://api.github.com)
base.uri <- "https://api.github.com"

# Under the "Repositories" category, find the endpoint that will list repos in 
# an organization
# Create a variable `resource` that represents the endpoint for the course
# organization (you can use `paste0()` to construct this, or enter it manually)
resource <- "/orgs/info201/repos"  # general example

# Send a GET request to this endpoint (the base.uri followed by the resource)
# and extract the response body
response <- GET(paste0(base.uri, resource))
body <- content(response,"text")

# Convert the body from JSON into a data frame
info.repos <- fromJSON(body)

# How many (public) repositories does the organization have?
print(nrow(info.repos))


# Use a "Search" endpoint to search for repositories about "visualization" whose
# language includes "R"
# Reassign the `resource` variable to refer to the appropriate resource.
resource <- '/search/repositories'

# You will need to specify some query parameters. Create a `query.params` list 
# variable that specifies an appropriate key and value for the search term and
# the language
query.params <- list(q = "visualization", language = "R")

# Send a GET request to this endpoint--including your params list as the `query`.
# Extract the response body and convert it from JSON.
response <- GET(paste0(base.uri, resource), query = query.params)
body <- content(response, "text")
results <- fromJSON(body)

# How many search repos did your search find? (Hint: check the list names)
print(results$total_count)

# What are the full names of the top 5?
vis.repo.names <- results$items$full_name[1:5]
print(vis.repo.names)


# Use the API to determine the number of people following Hadly Wickham 
# (`hadley`, the author of dplyr, ggplot2, and other libraries we'll be using). 

# Find an appropriate endpoint to query for statistics about a particular repo, 
# and use it to get a list of contributors to the `tidyverse/dplyr` repository.
# Who were the top 10 contributor in terms of number of total commits?
# NOTE: This will be a really big response with lots of data!
resource <- '/repos/tidyverse/dplyr/stats/contributors'
response <- GET(paste0(base.uri, resource))
result <- flatten(fromJSON(content(response, "text")))
contributors <- result %>% select(author.login, total) %>% arrange(-total)
print(contributors[1:10])
