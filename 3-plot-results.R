library(ggplot2)

spelling_change <- readRDS('word-data/spelling_change.RDS')

ggplot(spelling_change, aes(x = year, y = match_pct, group = word)) +
    geom_line(alpha = .3) +
    facet_wrap('letter_change') + 
    xlab('Year') +
    ylab('Percent of American Spelling') + 
    theme_bw(20)

ggplot(spelling_change[spelling_change$letter_change == 'ou', ],
       aes(x = year, y = match_pct, group = word)) +
    geom_line(alpha = .3) +
    facet_wrap('word') + 
    xlab('Year') +
    ylab('Percent of American Spelling') + 
    theme_bw(20)






