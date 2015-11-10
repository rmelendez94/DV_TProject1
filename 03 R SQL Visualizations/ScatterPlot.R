require(tidyr)
require(dplyr)
require(extrafont)
require(ggplot2)

dfs <- df %>% select(DURATION, Y, CONS_PRICE_IDX)
dfsY <- df %>% select(DURATION, Y, CONS_PRICE_IDX) %>% filter(Y=='yes')
dfsN <- df %>% select(DURATION, Y, CONS_PRICE_IDX) %>% filter(Y=='no')

ggplot() + 
  coord_cartesian() + 
  scale_x_continuous() +
  scale_y_continuous() +
  labs(title='Portuguese Bank Marketing Campaign Effectiveness') +
  labs(x="Duration", y=paste("Consumer Price Index")) +
  layer(data=dfs, 
        mapping=aes(x=as.numeric(as.character(DURATION)), y=as.numeric(as.character(CONS_PRICE_IDX)), color=Y),
        stat="identity",
        stat_params=list(),
        geom="point",
        geom_params=list(alpha=.8), 
        position=position_jitter(width=0, height=0)
  )+
  layer(data=dfsY, 
        mapping=aes(x=as.numeric(as.character(DURATION)), y=as.numeric(as.character(CONS_PRICE_IDX)), color=Y),
        stat="smooth",
        stat_params=list(method= lm, se= FALSE),
        geom="smooth",
        geom_params=list(alpha= .8), 
        position=position_jitter(width=0, height=0)
  )+
  layer(data=dfsN,
        mapping=aes(x=as.numeric(as.character(DURATION)), y=as.numeric(as.character(CONS_PRICE_IDX)), color=Y),
        stat="smooth",
        stat_params=list(method= lm, se= FALSE),
        geom="smooth",
        geom_params=list(alpha= .8), 
        position=position_jitter(width=0, height=0)
  )

