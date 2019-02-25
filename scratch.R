library(lubridate)

x <- period(num = 10000, units = "seconds")

Sys.time() - seconds(10)


second(Sys.time())


countdown <- function(x) {
  
  x <- x - 1
  Sys.sleep(1)
  print(x)
}

library(gganimate)
library(ggplot2)

secs <- data.frame(x=1,t = 1:1000)

??gganimate

ggplot(secs, aes(x,t)) +
  geom_col() +
  scale_y_continuous(limits = c(1,1000)) +
  transition_time(t)


  
