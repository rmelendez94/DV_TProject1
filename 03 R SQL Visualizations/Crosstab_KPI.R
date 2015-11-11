require("jsonlite")
require("RCurl")
require(ggplot2)
require(dplyr)

KPI_Low_Max_value = .1     
KPI_Medium_Max_value = .15

df %>% group_by(JOB) %>% summarize() %>% View()

#stuck on the mutate not sure how to get just yes and just no to do the ratio
#Maybe erade everything and start from scratch again for this file??
dfc <- df %>% mutate(Yyes = ifelse(Y == 'yes', 1, 0), Yno = ifelse(Y == 'no', 1, 0)) %>% group_by(EDUCATION) %>% mutate(Ratio = sum(Yyes)/sum(Yno)) %>% ungroup() %>% group_by(EDUCATION, Y, HOUSING) %>% summarize(AVG_DURATION = round(mean(DURATION),1), Ratio = mean(Ratio)) %>% mutate(KPI = ifelse(Ratio <= KPI_Low_Max_value, '03 Low', ifelse(Ratio <= KPI_Medium_Max_value, '02 Medium', '01 High')))

spread(dfc, Y, AVG_DURATION) %>% View

dfc$EDUCATION <- factor(dfc$EDUCATION, levels = c("illiterate", "basic4y", "basic6y", "basic9y", "highschool", "universitydegree", "professionalcourse", "unknown"))

ggplot() + 
  coord_cartesian() + 
  scale_x_discrete() +
  scale_y_discrete() +
  scale_fill_manual(values = c("green","yellow","red")) + 
  facet_grid(.~EDUCATION) + 
  labs(title='Portuguese Bank Marketing Campaign Effectiveness\nCrosstab\nAVG_DURATION') +
  labs(x=paste("EDUCATION/Y"), y=paste("HOUSING")) +
  layer(data=dfc, 
        mapping=aes(x=Y, y=HOUSING, label=AVG_DURATION), 
        stat="identity", 
        stat_params=list(), 
        geom="text",
        geom_params=list(colour="black"), 
        position=position_identity()
  ) +
  layer(data=dfc, 
        mapping=aes(x=Y, y=HOUSING, fill=KPI), 
        stat="identity", 
        stat_params=list(), 
        geom="tile",
        geom_params=list(alpha=0.50), 
        position=position_identity()
  )
