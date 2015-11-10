require("jsonlite")
require("RCurl")
require(ggplot2)
require(dplyr)

KPI_Low_Max_value = .1     
KPI_Medium_Max_value = .15

#stuck on the mutate not sure how to get just yes and just no to do the ratio
#Maybe erade everything and start from scratch again for this file??
dfc <- df %>% group_by(EDUCATION,Y, HOUSING) %>% summarize(AVG_DURATION = mean(DURATION)) %>% mutate(RATIO = sum_price / sum_carat) %>% mutate(KPI = ifelse(RATIO <= KPI_Low_Max_value, '03 Low', ifelse(RATIO <= KPI_Medium_Max_value, '02 Medium', '01 High'))) 

#spread(dfc, COLOR, SUM_PRICE) %>% View

ggplot() + 
  coord_cartesian() + 
  scale_x_discrete() +
  scale_y_discrete() +
  labs(title='Portuguese Bank Marketing Campaign Effectiveness\nCrosstab\nAVG_DURATION') +
  labs(x=paste("EDUCATION/Y"), y=paste("HOUSING")) +
  layer(data=dfc, 
        mapping=aes(x=EDUCATION, y=HOUSING, label=AVG_DURATION), 
        stat="identity", 
        stat_params=list(), 
        geom="text",
        geom_params=list(colour="black"), 
        position=position_identity()
  ) +
  layer(data=df, 
        mapping=aes(x=COLOR, y=CLARITY, label=SUM_CARAT), 
        stat="identity", 
        stat_params=list(), 
        geom="text",
        geom_params=list(colour="black", vjust=2), 
        position=position_identity()
  ) +
  layer(data=df, 
        mapping=aes(x=COLOR, y=CLARITY, label=round(RATIO, 2)), 
        stat="identity", 
        stat_params=list(), 
        geom="text",
        geom_params=list(colour="black", vjust=4), 
        position=position_identity()
  ) +
  layer(data=df, 
        mapping=aes(x=COLOR, y=CLARITY, fill=KPI), 
        stat="identity", 
        stat_params=list(), 
        geom="tile",
        geom_params=list(alpha=0.50), 
        position=position_identity()
  )
