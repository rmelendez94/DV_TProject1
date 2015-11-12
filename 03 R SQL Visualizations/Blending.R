require(tidyr)
require(dplyr)
require(extrafont)
require(ggplot2)

# still need to make it work for crosstab rather than barchart use crosstab_kpi.r as guide?
dfbl <-
  data.frame(fromJSON(getURL(
    URLencode(
      gsub(
        "\n", " ", 'skipper.cs.utexas.edu:5001/rest/native/?query=
        """select region || \\\' \\\' || \\\'Sales\\\' as measure_names, sum(sales) as measure_values from   SUPERSTORE_SALES_ORDERS
        where country_region = \\\'United States of America\\\'
        group by region
        union all
        select market || \\\' \\\' || \\\'Coffee_Sales\\\' as measure_names, sum(coffee_sales) as measure_values from COFFEE_CHAIN
        group by market
        order by 1;"""
        '
      )
      ), httpheader = c(
        DB = 'jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER =
          'C##cs329e_rm46926', PASS = 'orcl_rm46926', MODE = 'native_mode', MODEL = 'model', returnDimensions = 'False', returnFor = 'JSON'
      ), verbose = TRUE
    ))); View(df)

ggplot() +
  coord_cartesian() +
  scale_x_discrete() +
  scale_y_continuous() +
  #facet_wrap(~CLARITY, ncol=1) +
  labs(title = 'Portuguese Bank Marketing Campaign Effectiveness\nBlending\nAVG_SALARY, JOB_TYPE') +
  labs(x = paste("AVG_SALES"), y = paste("JOB_TYPE")) +
  layer(
    data = dfbl,
    mapping = aes(x = MEASURE_NAMES, y = MEASURE_VALUES),
    stat = "identity",
    stat_params = list(),
    geom = "bar",
    geom_params = list(colour = "blue"),
    position = position_identity()
  ) + coord_flip() +
  layer(
    data = dfbl,
    mapping = aes(
      x = MEASURE_NAMES, y = MEASURE_VALUES, label = round(MEASURE_VALUES)
    ),
    stat = "identity",
    stat_params = list(),
    geom = "text",
    geom_params = list(colour = "black", hjust = -0.5),
    position = position_identity()
  ) 
