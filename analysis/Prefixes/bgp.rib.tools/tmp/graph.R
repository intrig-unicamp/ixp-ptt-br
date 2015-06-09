library("bgp.rib.tools")

################################################################################
#'
#' This function plots a bar graph with percentage of network prefixes that 
#' appear in a data sample. If allows saving the graph on a file either in PDF
#' or PNG. Header and the dimension of the plot can be defined in the function 
#' call.
#'
#' @param rib.network.prefixes 
#'        The \code{rib.network.prefixes} object class with rib 
#'        prefixes.
#' @param file The file name for saving the graph.
#' @param header The graph header
#' @param width The graph width
#' @param height The graph height
#' @exaple
#' prefixes <- bgp.rib.prefixes.count(
#'                   bgp.rib.parse("data/lg.sp.ptt.br-BGPv4.txt.gz")
#'                   )
#' bgp.rib.plotPrefixes(prefixes)
#'
bgp.rib.plotPrefixes <- function(rib.network.prefixes, file,
                                 header = "Prefixes Occurrences %",
                                 width = GRAPH.DEFAULT.WIDTH,
                                 height = GRAPH.DEFAULT.HEIGHT){
    
    require("data.table", quietly = TRUE)
    require("ggplot2", quietly = TRUE)
    
    ## Return if rib.network.prefixes is either null or NA
    if (is.null(rib.network.prefixes) 
        || is.na(rib.network.prefixes))
        return()
    
    ## Creates a prefixes table with ordered data from prefix column
    prefixes <- rib.network.prefixes[
        order(rib.network.prefixes$prefix),] 
    
    ## TODO
    text.label <- paste(format(round(prefixes$percentage, 2), nsmall = 2),
                        "%",sep="")
    
    ## Create a ploting object 
    prefixes.plot <- ggplot(data = prefixes, 
                            aes(x = prefix, y = percentage, fill = percentage), 
                            environment = environment()) +
        guides(fill = FALSE) +
        geom_bar(stat="identity") +
        geom_text(aes(label=text.label, fontface="bold"), 
                  vjust = -0.5, 
                  size = width/5, 
                  colour = "red3") +
        scale_x_discrete(limits = c(1:32))  + 
        labs(title = header, x = "Prefixes", y = "Percentages") +
        theme(axis.title.x = element_text(face = "bold", color = "black", 
                                          size = 12), 
              axis.title.y = element_text(face = "bold", color = "black", 
                                          size = 12), 
              plot.title = element_text(face = "bold", color = "black", 
                                        size = 15, vjust = 1), 
              legend.position = c(1, 1), legend.justification = c(1, 1))
    
    ## Plot on screen if output file is null.
    ## If output file is not null save on file
    if (is.null(file)){
        prefixes.plot  
    } else {
        
        file.name = gsub(".*/", "", file)
        
        image.path = gsub(paste("/", file.name, sep = ""), "", x = file, 
                          fixed = TRUE)
        
        if (! file.exists(image.path)){
            dir.create(image.path, recursive = TRUE)
        }
        
        ggsave(filename = file.name, path = image.path,
               plot = prefixes.plot, width = width, height = height)        
    }        
}
################################################################################

################################################################################
#'
#' This is a help function for processing multiple prefixes files
#'
#' @param input.data The folder or file for multiple or single prefixes table 
#' @param output.data The folder for outputing the results 
#' @param single.plot If the output should output single graphs for each prefix
#'                    input table
#' @param combined.plot If the output should combine multiple graphs in a single
#'                      picture
#' @param width The graph width
#' @param height The graph height
#'
bgp.rib.m.plotPrefixes <- function(input.data, output.path, 
                                   single.plot = TRUE,
                                   combined.plot = TRUE, 
                                   width = GRAPH.DEFAULT.WIDTH, 
                                   height = GRAPH.DEFAULT.HEIGHT ){
    
    require("data.table", quietly = TRUE)
    require("ggplot2", quietly = TRUE)
    
    time.start <- Sys.time()
    
    cat("Start time: ", format(time.start, "%Y-%m-%d %H:%M:%S"), "\n")
    
    if (file.exists(input.data)){
        if (file.info(input.data)$isdir){
            cat("Processing multiple files in folder \"", 
                input.data, "\"...\n", sep = "")
            files <- list.files(input.data, pattern = "csv$",
                                full.names = TRUE)
            cat ("")
        }else{
            files <- input.data
        }
    } else {
        stop(paste(input.data," not found.",sep = ""))
    }
    
    all.prefixes <- NULL
    
    i <- 0
    
    for(f in files){
        
        cat("Processing \"", f, "\"...\n", sep = "")
        
        name <- gsub(".*/","", sub("\\.[[:alnum:]]+$", "", f))
        
        prefixes <- read.csv(f)
        
        if (single.plot){
            out.prefixes.graph <- 
                paste(output.path, "/",
                      OUTPUT.DEFAULT.GRAPH.SUBPATH,
                      "/", name,
                      ".pdf", sep = "")
            bgp.rib.plotPrefixes(prefixes,
                                 file = out.prefixes.graph, 
                                 header = name,
                                 width = width, height = height)  
        } 
        
        if (combined.plot) {
            prefixes <- mutate(prefixes, name = name)
            all.prefixes <- rbind_list(all.prefixes, prefixes)
        }
    }
    
    if (combined.plot && !is.null(all.prefixes)){
        
        prefixes.plot <- ggplot(data = all.prefixes, 
                                aes(x = prefix, y = percentage, 
                                    fill = percentage), 
                                environment = environment()) +
            guides(fill = FALSE) +
            geom_bar(stat = "identity") +
            geom_text(aes(label = format(round(all.prefixes$percentage, 2), 
                                         nsmall = 2), fontface = "bold"), 
                      vjust = -0.5, size = width / 5, colour = "red3") +
            scale_x_discrete(limits = c(1:32))  + 
            labs(title = "PTT", x = "Prefixes", y = "Percentages") +
            theme(axis.title.x = element_text(face = "bold", color = "black", 
                                              size = 12), 
                  axis.title.y = element_text(face = "bold", color = "black", 
                                              size = 12), 
                  plot.title = element_text(face = "bold", color = "black", 
                                            size = 15, vjust = 1), 
                  legend.position = c(1, 1), legend.justification = c(1, 1)) +
            
            facet_grid(name ~ .)
        
        name <- paste("all_prefixes",".pdf", sep = "")
        
        image.output.path <- paste(output.path, OUTPUT.DEFAULT.GRAPH.SUBPATH, 
                                   sep="/")
        
        if (!file.exists(image.output.path)){
            dir.create(image.output.path, recursive = TRUE)
        }
        ggsave(filename = name, path = image.output.path, width = width, 
               height = length(unique(all.prefixes$name)) * height, 
               limitsize=FALSE)          
    }
    
    time.end <- Sys.time()
    time.diff <- difftime(time.end, time.start, units = c("auto", "secs", 
                                                          "mins", "hours",
                                                          "days", "weeks"))
    
    cat("Start time: ", format(time.start, "%Y-%m-%d %H:%M:%S"), 
        ", End time: ", format(time.end, "%Y-%m-%d %H:%M:%S"), "\n", sep = "")
    cat("Total execution time:",time.diff,attr(time.diff,"units"),"\n")
    cat("Done.\n", sep = "")
}
################################################################################