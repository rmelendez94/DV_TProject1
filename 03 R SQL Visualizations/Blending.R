require(tidyr)
require(dplyr)
require(extrafont)
require(ggplot2)

dfbl <-
  data.frame(fromJSON(getURL(
    URLencode(
      gsub(
        "\n", " ", 'skipper.cs.utexas.edu:5001/rest/native/?query=
        """select JOB_TYPE as job_name, \\\'AVERAGE_SALARY\\\' as measure_names, 
sum(AVERAGE_SALARY) as measure_values 
        from JOBTYPE
        group by JOB_TYPE
        union all
        select JOB as job_name, \\\'CAMPAIGN\\\' as measure_names, sum(CAMPAIGN) as measure_values from BNKMKTG
        group by JOB;"""'
      )
      ), httpheader = c(
        DB = 'jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER =
          'C##cs329e_rm46926', PASS = 'orcl_rm46926', MODE = 'native_mode', MODEL = 'model', returnDimensions = 'False', returnFor = 'JSON'
      ), verbose = TRUE
    ))); View(dfbl)

# Rearranges measure_names into usable columns
ndfbl <- spread(dfbl, MEASURE_NAMES, MEASURE_VALUES) %>% arrange(desc(AVERAGE_SALARY))

# Creates an ordered column of job type to be used for ordering in ggplot
ndfbl$ORDERED_JOBS <- reorder(ndfbl$JOB_NAME, ndfbl$AVERAGE_SALARY)

ggplot() +
  coord_cartesian() +
  scale_x_discrete() +
  scale_y_continuous(limits = c(0,100000)) +
  scale_fill_gradient(low = "grey90", high = "darkgreen", na.value = "grey90", guide = "colourbar") +
  # I don't think we will need facet_wrap
  #facet_wrap(~CLARITY, ncol=1) +
  labs(title = 'Portuguese Bank Marketing Campaign Effectiveness\nBlending\nAVG_SALARY, JOB_TYPE') +
  labs(x = paste("JOB TYPE"), y = paste("AVERAGE SALARY")) +
  theme(panel.background=element_rect(fill='grey100')) +
  layer(
    data = ndfbl,
    mapping = aes(x = ORDERED_JOBS, y = AVERAGE_SALARY, fill = CAMPAIGN),
    stat = "identity",
    stat_params = list(),
    geom = "bar",
    geom_params = list(),
    position = position_identity()
  ) +
  
  # need to add text value of campaign count on end of bar
  layer(
    data = ndfbl,
    mapping = aes(
      x = ORDERED_JOBS, y = CAMPAIGN, label = round(CAMPAIGN)
    ),
    stat = "identity",
    stat_params = list(),
    geom = "text",
    
    # I cannot get the hjust to work!
    geom_params = list(colour = "black", hjust = -5),
    position = position_identity()
  ) + coord_flip() 
