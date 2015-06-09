output.path <- paste("../ptt.data/", format(Sys.time(), "20150302"), sep = "")
output.path <- paste("../ptt.data/", format(Sys.time(), "test"), sep = "")

processed.path <- "../ptt.data/processed"
parseRibTables.csv(processed.path, output.path)

raw.path <- "../ptt.data/base/data-v4"
parseRibTables(raw.path, output.path)

prefixes.path <- "../ptt.data/prefixes"
plotMultipleNetworkPrefixes(prefixes.path, output.path)

parseRibTable()

library("data.table") 
statistics <- read.csv("../ptt.data/20150219/statistics.csv")
statistics <- mutate (statistics,
                      file = as.character(file),
                      lines.total = as.numeric(lines.total), 
                      lines.duplicated = as.numeric(lines.duplicated))


symbols(statistics$lines.total, statistics$lines.duplicated, circles=crime$population)

