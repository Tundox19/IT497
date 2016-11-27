require(httr)
require(httpuv)
require(jsonlite)

#API V2 Access keys
consumerKey <- "x-_DhUTpWAwfnoLYZy9T6A"
consumerSecret <- "u2oX1WEzxePDqkKYUfHRlzyVx9M"
token <- "kl7cRZ8-WRl_CRzj02Z5663gewpscJTL"
token_secret <- "9LW5_fnXiM-Bjta_-tPB7Y6SfTs"



#Authorization
appAuthorization <- oauth_app("YELP", key=consumerKey, secret=consumerSecret)
appOAUTH <- sign_oauth1.0(appAuthorization, token=token,token_secret=token_secret)
yelpURL <- "http://api.yelp.com/v2/search/?"
limit <- 20
location <- "Chicago"
term <- "chinese%restaurant" #chicago-indian restaurants
yelpurl <- paste0(yelpURL,"limit=",limit,"&location=",location,"&term=",term)




#query yelp database
locationdata=GET(yelpurl, appOAUTH) #response
locationdataContent = content(locationdata) #list

#list to json
jsonLocationdataContent <- toJSON(locationdataContent) #JSON

#json to list
locationdataList=fromJSON(jsonLocationdataContent) #list

#List to dataframe
df <- data.frame(locationdataList)
names(df)



#Needed variables
business.RATINGS <- df[,"businesses.rating"]
business.NAME <- df[,"businesses.name"]
business.LOCATION <- df[,"businesses.location"]
names(business.LOCATION)
business.CITY <- business.LOCATION[,"city"] #from location
business.STATE <- business.LOCATION[,"state_code"] #from location
business.POSTAL <- business.LOCATION[,"postal_code"] #from location
business.COUNTRY <- business.LOCATION[,"country_code"] #from location

#To json
RATINGS.json <- toJSON(business.RATINGS, pretty=TRUE)
NAME.json <- toJSON(business.NAME, pretty=TRUE)
CITY.json <- toJSON(business.CITY, pretty=TRUE) #from location
STATE.json <- toJSON(business.STATE, pretty=TRUE) #from location
POSTAL.json <- toJSON(business.POSTAL, pretty=TRUE) #from location
COUNTRY.json <- toJSON(business.COUNTRY, pretty=TRUE) #from location


#To matrix
RATINGS.matrix <- fromJSON(RATINGS.json)
NAME.matrix <- fromJSON(NAME.json)
CITY.matrix <- fromJSON(CITY.json)
STATE.matrix <- fromJSON(STATE.json)
POSTAL.matrix <- fromJSON(POSTAL.json)
COUNTRY.matrix <- fromJSON(COUNTRY.json)

#custom assigned variable
CATEGORY <- "Chinese"

#new dataframe object to store needed variables
df <- data.frame(NAME.matrix, CATEGORY, CITY.matrix, STATE.matrix, POSTAL.matrix, COUNTRY.matrix, RATINGS.matrix)
df <- df[order(df$NAME.matrix),]

#create csv file for data
fileName <- "chicagoChineseRestaurants.csv"
write.csv(df, file = fileName, row.names = FALSE)