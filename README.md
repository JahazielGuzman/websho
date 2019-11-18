# Websho

Websho is a movie streaming app which customizes its selection to the users viewing history.
Choose from a catalog of 1000+ movies from more than 10 genres. You can also browse movies more easily by using the search functionality. 

NOTE: You can also stream trailers of movies.

This repository is for the Rails backend, visit [here](https://github.com/JahazielGuzman/websho-frontend) for the front-end code base

[Click here for the hosted app.](websho.jahazielguzman.com) Rails app was deployed to Heroku.

This project was created in Rails, React and Postgres.

Some of the techniques used to create this app:
+ Created 4 Active Record models with PostgreSQL to store users, reviews, viewership patterns and a catalog of 1000+ movies.
+ Seeded database with movie metadata obtained from TheMovieDB API.
+ Created custom movie recommendation lists in Rails which were tailored to each users viewing history.
+ Generated search results based on movie search queries.
+ Used the react-youtube npm package to stream youtube trailers fetched from TheMovieDB.

To run this project do the following:

Navigate to the folder where the project is contained and run

`bundle install`

`rails db:create`

`rails db:migrate`

`rails db:seed`

and finally

`rails s`
