require(tidyr)
require(dplyr)
require(extrafont)
require(ggplot2)

dfb <- df %>% group_by(POUTCOME, Y) %>% summarise(AVG_CAMPAIGN = mean(CAMPAIGN))
dfb1 <- dfb %>% ungroup %>% group_by(POUTCOME) %>% summarise(WINDOW_AVG_CAMPAIGN = mean(AVG_CAMPAIGN))
dfb <- inner_join(dfb, dfb1, by="POUTCOME") 

#spread(dfb, Y, AVG_CAMPAIGN) %>% View

ggplot() + 
  coord_cartesian() + 
  scale_x_discrete() +
  scale_y_continuous() +
  facet_wrap(~POUTCOME, ncol=1) +
  labs(title='Portuguese Bank Marketing Campaign Effectiveness\nBar Chart\nAVG_CAMPAIGN, WINDOW_AVG_CAMPAIGN') +
  labs(x=paste("Y (OUTCOME)"), y=paste("AVG_CAMPAIGN")) +
  layer(data=dfb, 
        mapping=aes(x=Y, y=AVG_CAMPAIGN, color=Y, fill=Y), 
        stat="identity", 
        stat_params=list(), 
        geom="bar",
        geom_params=list(width=.25), 
        position=position_identity()
  ) + coord_flip() +
  layer(data=dfb, 
        mapping=aes(x=Y, y=AVG_CAMPAIGN, label=round(AVG_CAMPAIGN, 4)), 
        stat="identity", 
        stat_params=list(), 
        geom="text",
        geom_params=list(colour="black", hjust=-0.5, size=3.5), 
        position=position_identity()
  ) +
  layer(data=dfb, 
        mapping=aes(x=Y, y=AVG_CAMPAIGN, label=round(WINDOW_AVG_CAMPAIGN, 4)), 
        stat="identity", 
        stat_params=list(), 
        geom="text",
        geom_params=list(colour="black", hjust=-2, size=3.5), 
        position=position_identity()
  ) +
  layer(data=dfb, 
        mapping=aes(x=Y, y=AVG_CAMPAIGN, label=round(AVG_CAMPAIGN - WINDOW_AVG_CAMPAIGN, 4)), 
        stat="identity", 
        stat_params=list(), 
        geom="text",
        geom_params=list(colour="black", hjust=-5, size=3.5), 
        position=position_identity()
  ) +
  layer(data=dfb, 
        mapping=aes(yintercept = WINDOW_AVG_CAMPAIGN), 
        geom="hline",
        geom_params=list(colour="red")
  ) 
