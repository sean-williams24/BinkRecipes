# BinkRecipes

An app which displays recipes downloaded via the MealsDB API

## Pre-requisites   

Required SDK's (included):
  
	pod 'SDWebImage', '~> 5.0'
	pod "YoutubePlayer-in-WKWebView", "~> 0.2.0" 
 	pod 'Spring'       
  
SDWebImage was used to assist with asynchronously downloading and caching images in the collection and table views to boost performance and ensure a smooth scrolling experience for the user.

YouTubePlayer was used to embed YouTube video content for each recipe.

Spring library was used to assist with implementing animations.


## Getting Started
Clone or download the project and run the xcworkspace file. The app works best on a real device as the NWPathMonitor is unreliable on the simulator. 

The app was built using MVVM architecture with a dedicated networking client for API calls to the MealDB API.

On app launch meal categories are fetched from MealDB. On selecting a category another MealDB API call returns a list of meals for that category. The user can view recipe details by tapping a cell, the recipe is persisted to Core Data on viewing.

The app listens for Internet connectivity using NWPathMonitor; if connection is lost the UI updates to display previously viewed recipes from Core Data.

I have written unit tests to test the Category, Meal and Recipe View Models.
