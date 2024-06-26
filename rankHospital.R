rankhospital <- function(state, outcome, num = "best"){
  ## Read table
  data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  
  ## Select the colums that are required and naming them
  data <- data[c(2, 7, 11, 17, 23)]
  names(data)[1] <- "name"
  names(data)[2] <- "state"
  names(data)[3] <- "heart attack"
  names(data)[4] <- "heart failure"
  names(data)[5] <- "pneumonia"
  
  ## Validate the outcome string
  outcomes = c("heart attack", "heart failure", "pneumonia")
  if(outcome %in% outcomes == FALSE) stop("invalid outcome name")
  
  # Validate the state string
  states <- data[, 2]
  states <- unique(states)
  if(state %in% states == FALSE) stop("invalid state name")
  
  ## Validate the num value
  if(num != "best" && num != worst && num%%1 != 0) stop("invalid num")
  
  ## Grab only those rows which matches the required state value and
  ## whose data is available
  data <- data[data$state == state & data[outcome] != "Not Available", ]
  
  ## Ordering the data in ascending order, firast according to the
  ## names column and then according to their ranks for the specific
  ## outcome column
  data[outcome] <- as.data.frame(sapply(data[outcome], as.numeric))
  data <- data[order(data$name, decreasing = FALSE), ]
  data <- data[order(data[outcome], decreasing = FALSE), ]
  
  ##Processing the num argument for various conditions
  vals <- data[, outcome]
  if(num == "best"){
    rowNum <- which.min(vals)
  }else if (num == "worst"){
    rowNum <- which.max(vals)
  }else{
    rowNum <- num
  }
  ## Return Hospital name in that state with lowest 30-day death rate
  data[rowNum, ]$name
}