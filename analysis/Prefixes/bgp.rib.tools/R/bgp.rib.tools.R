################################################################################
# Libraries loading
library("data.table")
library("R.utils")
library("dplyr")
library("ggplot2")
################################################################################

################################################################################
# Global variables
GRAPH.DEFAULT.WIDTH              <- 8
GRAPH.DEFAULT.HEIGHT             <- 4
OUTPUT.DEFAULT.GRAPH.SUBPATH     <- "graphs"
OUTPUT.DEFAULT.PROCESSED.SUBPATH <- "processed"
OUTPUT.DEFAULT.PREFIXES.SUBPATH  <- "prefixes"
################################################################################

################################################################################
# Classes declaration
# setClass(Class="bgp.rib",
#          representation(
#              table = "data.table",
#              prefixes = "data.table"
#          ),
#          prototype=prototype(
#              table = data.table(),
#              prefixes = data.table()
#          )
# )
################################################################################

################################################################################
#' This funciton parses rib table in IPv4 format and output a datable.table
#' with that command's output. The parameter \code{rdl} is used for removing
#' duplicated lines from parsed table and accepts either \code{TRUE} or
#' \code{FALSE} as input value. The parameter \code{rdp} is used for removing
#' duplicated Autonomous System (AS) for the parsed table for each line. The
#' parameter \code{rdp} accepts either \code{TRUE} or \code{FALSE} as input
#' value
#'
#' @param filename The path to rib table file
#' @param rdl Remove duplicated lines from parsed data.
#'            The default value is \code{TRUE}.
#' @param rdp Remove duplicated AS from path.
#'            The default value is \code{TRUE}.
#' @param verbose Print status information
#' @result \code{bgp.rib.table} with \code{data.table} of the parsed
#'         show ip bgp result table
#' @example
#' bgp.rib.parse("data/lg.sp.ptt.br-BGPv4.txt.gz")
#'
bgp.rib.ipv4.parse <- function(filename, rdl = TRUE, rdp = TRUE,
                               verbose = FALSE, debug = FALSE){
    .bgp.rib.parse(filename, 4, rdl, rdp, verbose, debug)
}
################################################################################

################################################################################
#' This funciton parses rib table in IPv6 format and output a datable.table
#' with that command's output. The parameter \code{rdl} is used for removing
#' duplicated lines from parsed table and accepts either \code{TRUE} or
#' \code{FALSE} as input value. The parameter \code{rdp} is used for removing
#' duplicated Autonomous System (AS) for the parsed table for each line. The
#' parameter \code{rdp} accepts either \code{TRUE} or \code{FALSE} as input
#' value
#'
#' @param filename The path to rib table file
#' @param rdl Remove duplicated lines from parsed data.
#'            The default value is \code{TRUE}.
#' @param rdp Remove duplicated AS from path.
#'            The default value is \code{TRUE}.
#' @param verbose Print status information
#' @result \code{bgp.rib.table} with \code{data.table} of the parsed
#'         show ip bgp result table
#' @example
#' bgp.rib.parse("data/lg.sp.ptt.br-BGPv4.txt.gz")
#'
bgp.rib.ipv6.parse <- function(filename, rdl = TRUE, rdp = TRUE,
                               verbose = FALSE, debug = FALSE){
    .bgp.rib.parse(filename, 6, rdl, rdp, verbose, debug)
}
################################################################################

################################################################################
#' This internal function parses rib table, either using IPv4 or IPv6 formats,
#' and output a datable.table with that command's output.
#' The parameter \code{rdl} is used for removing duplicated lines from
#' parsed table and accepts either \code{TRUE} or
#' \code{FALSE} as input value. The parameter \code{rdp} is used for removing
#' duplicated Autonomous System (AS) for the parsed table for each line. The
#' parameter \code{rdp} accepts either \code{TRUE} or \code{FALSE} as input
#' value
#'
#' @param filename The path to rib table file
#' @param ip.version the version of IP used in the table, either 4 or 6
#' @param rdl Remove duplicated lines from parsed data.
#'            The default value is \code{TRUE}.
#' @param rdp Remove duplicated AS from path.
#'            The default value is \code{TRUE}.
#' @param verbose Print status information
#' @result \code{bgp.rib.table} with \code{data.table} of the parsed
#'         show ip bgp result table
#' @example
#' bgp.rib.parse("data/lg.sp.ptt.br-BGPv4.txt.gz")
#'
.bgp.rib.parse <- function(filename, ip.version, rdl = TRUE, rdp = TRUE,
                                   verbose = FALSE, debug = FALSE){

    ############################################################################
    ## The required list of libraries for running this function
    require("data.table", quietly = TRUE)
    if ( !(packageVersion("data.table") >= "1.9.4")) {
        stop("data.table package has to be version 1.9.4 or newer.")
    }
    require("R.utils", quietly = TRUE)
    require("dplyr", quietly = TRUE)
    ############################################################################

    ############################################################################
    ## Check if input file exists
    if (!file.exists(filename)){
        stop(paste(filename," not found.",sep=""))
    }
    if (file.info(filename)$isdir){
        stop(paste(filename," is not a file.",sep=""))
    }
    ############################################################################

    ############################################################################
    ## show ip bgp
    ##
    ## BGP table version is 6, local router ID is 10.0.96.2
    ## Status codes: s suppressed, d damped, h history, * valid, > best,
    ##                i internal, r RIB-failure, S Stale, m multipath,
    ##                b backup-path, x best-external, f RT-Filter,
    ##                a additional-path
    ## Origin codes: i - IGP, e - EGP, ? - incomplete
    ## RPKI validation codes: V valid, I invalid, N Not found
    ##
    ##      Network         Next Hop         Metric LocPrf Weight Path
    ##
    ## N*   10.0.0.1        10.0.0.3              0              0 3 ?
    ##
    ## N*>                  10.0.3.5              0              0 4 ?
    ##
    ## Nr   10.0.0.0/8      10.0.0.3              0              0 3 ?
    ##
    ## Nr>                  10.0.3.5              0              0 4 ?
    ##
    ## Nr>  10.0.0.0/24     10.0.0.3              0              0 3 ?
    ##
    ## V*>  10.0.2.0/24     0.0.0.0               0                32768 i
    ##
    ## Vr>  10.0.3.0/24     10.0.3.5              0              0 4 ?
    ##
    ##
    ## The table below describes the significant fields shown in the
    ## display.
    ##
    ## show ip bgp Field Descriptions
    ## Field
    ##    Description
    ##
    ## BGP table version
    ##     Internal version number of the table.
    ##     This number is incremented whenever the table changes.
    ##
    ## local router ID
    ##     IP address of the router.
    ##
    ## Status codes
    ##     Status of the table entry.
    ##     The status is displayed at the beginning of each line in the
    ##     table.
    ##     It can be one of the following values:
    ##         s   The table entry is suppressed.
    ##         d   The table entry is dampened.
    ##         h   The table entry history.
    ##         *   The table entry is valid.
    ##         >   The table entry is the best entry to use for that
    ##             network.
    ##         i   The table entry was learned via an internal BGP (iBGP)
    ##             session.
    ##         r   The table entry is a RIB-failure.
    ##         S   The table entry is stale.
    ##         m   The table entry has multipath to use for that network.
    ##         b   The table entry has a backup path to use for that
    ##             network.
    ##         x   The table entry has a best external route to use for the
    ##             network.
    ##
    ## Origin codes
    ##     Origin of the entry. The origin code is placed at the end of each
    ##     line in the table. It can be one of the following values:
    ##         a   Path is selected as an additional path.
    ##         i   Entry originated from an Interior Gateway Protocol (IGP)
    ##             and was
    ##             advertised with a network router configuration command.
    ##         e   Entry originated from an Exterior Gateway Protocol (EGP).
    ##         ?   Origin of the path is not clear. Usually, this is a
    ##             router that is redistributed into BGP from an IGP.
    ##
    ## RPKI validation codes
    ##     If shown, the RPKI validation state for the network prefix, which
    ##     is downloaded from the RPKI server.
    ##     The codes are shown only if the bgp rpki server or neighbor
    ##     announce rpki state command is configured.
    ##
    ## Network
    ##     IP address of a network entity.
    ##
    ## Next Hop
    ##     IP address of the next system that is used when forwarding a
    ##     packet to destination network. An entry of 0.0.0.0 indicates that
    ##     the router has some non-BGP routes to this network.
    ##
    ## Metric
    ##     If shown, the value of the inter-autonomous system metric.
    ##
    ## LocPrf
    ##     Local preference value as set with the set local-preference
    ##     route-map configuration command. The default value is 100.
    ##
    ## Weight
    ##     Weight of the route as set via autonomous system filters.
    ##
    ## Path
    ##     Autonomous system paths to the destination network. There can be
    ##     one entry in this field for each autonomous system in the path.
    ##
    ## (stale)
    ##     Indicates that the following path for the specified autonomous
    ##     system is marked as “stale” during a graceful restart process.
    ############################################################################

    ############################################################################
    ## Table header
    rib.table.vars <- c("status",
                        "network",
                        "netmask",
                        "nexthop",
                        "metric",
                        "locprf",
                        "weight",
                        "path",
                        "origin")
    #
    rib.table.start.pattern <-
        c(" *Network *Next Hop *Metric *LocPrf *Weight *Path")
    ############################################################################

    ############################################################################
    ## End of the table
    rib.table.end.pattern <- "Total number of prefixes"
    ############################################################################

    ############################################################################
    ## IP mask regex
    ##
    if (!(ip.version == 4 || ip.version == 6)){
        stop("Wrong value for IP version entered.")
    }
    if (ip.version == 4) {
        ip.address.pattern <- "[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}"
        ip.netmask.pattern <- "/[0-9]+$"
    }
    if (ip.version == 6) {
        ip.address.pattern <- "(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))"
        ip.netmask.pattern <- "/[0-9]{1,2}"
    }
    ############################################################################

    ############################################################################
    ## Status codes (show ip bgp)
    ##     Status of the table entry.
    ##     The status is displayed at the beginning of each line in the
    ##    table.
    ##     It can be one of the following values:
    ##         s   The table entry is suppressed.
    ##         d   The table entry is dampened.
    ##         h   The table entry history.
    ##         *   The table entry is valid.
    ##         >   The table entry is the best entry to use for that
    ##             network.
    ##         i   The table entry was learned via an internal BGP (iBGP)
    ##             session.
    ##         r   The table entry is a RIB-failure.
    ##         S   The table entry is stale.
    ##         m   The table entry has multipath to use for that network.
    ##         b   The table entry has a backup path to use for that
    ##             network.
    ##         x   The table entry has a best external route to use for the
    ##             network.
    ##
    status.width   <- 3
    status.pattern <- "^[*>Sbdhimrsx]{1,2}"
    ############################################################################

    ############################################################################
    ## Network (show ip bgp)
    ##     IP address of a network entity.
    ##
    network.width   <- 17
    network.pattern <- paste("(",ip.address.pattern,"(\\/",
                             ip.netmask.pattern, "){0,1}){0,1}", sep="")
    ############################################################################

    ############################################################################
    ## Nex hop (show ip bgp)
    ##     IP address of the next system that is used when forwarding
    ##    a packet to the destination network. An entry of 0.0.0.0
    ##    indicates that the router has some non-BGP routes to this
    ##    network.
    ##
    next.hop.width <- 20
    ############################################################################

    ############################################################################
    ## Metric (show ip bgp)
    ##     If shown, the value of the inter-autonomous system metric.
    ##
    metric.width <- 7
    ############################################################################

    ############################################################################
    ## LocPrf (show ip bgp)
    ##     Local preference value as set with the set local-preference
    ##     route-map configuration command. The default value is 100.
    ##
    locprf.width <- 7
    ############################################################################

    ############################################################################
    ## Weight (show ip bgp)
    ##     Weight of the route as set via autonomous system filters.
    ##
    weight.width <- 7
    ############################################################################

    ############################################################################
    ## Path (show ip bgp)
    ##     Autonomous system paths to the destination network. There can be
    ##     one entry in this field for each autonomous system in the path.
    ##
    path.width <- 1000000L
    ############################################################################

    ############################################################################
    ## Origin codes (show ip bgp)
    ##     Origin of the entry. The origin code is placed at the end of each
    ##     line in the table. It can be one of the following values:
    ##         a   Path is selected as an additional path.
    ##         i   Entry originated from an Interior Gateway Protocol (IGP)
    ##             and was advertised with a network router configuration
    ##             command.
    ##         e   Entry originated from an Exterior Gateway Protocol (EGP).
    ##         ?   Origin of the path is not clear. Usually, this is a
    ##             router that is redistributed into BGP from an IGP.
    ##
    origin.pattern   <- "[aie?]$"
    ############################################################################

    ############################################################################
    ## Line pattern
    ##
    ##      Network         Next Hop         Metric LocPrf Weight Path
    ## N*   10.0.0.1        10.0.0.3              0              0 3 ?
    ##
    ##    Network          Next Hop            Metric LocPrf Weight Path
    ## *  2001:500:3::/48  2001:12f8::175                         0 20144 i
    ##
    ## Partial table entry pattern
    ############################################################################

    ############################################################################
    ## Helper function for extrating string from string based on input
    ## pattern
    ## getPatternMatchFromString <- function(pattern, string, trim = TRUE){
    ##    if (grepl(pattern,string)){
    ##        m <- regexpr(pattern, string)
    ##        s <- m[1]
    ##        e <- s + attr(m,"match.length") - 1
    ##        o <- substr(string,s,e)
    ##        if (trim){
    ##            o <- gsub("^\\s+|\\s+$", "", o)
    ##        }
    ##        return(o)
    ##    }
    ##}
    ############################################################################

    ############################################################################
    ## Initial loop variables
    rib.table.found <- FALSE
    network <- character()
    rib.table <- list()
    lines.skipped <- 0
    ############################################################################

    ############################################################################
    ## Open file for reading
    file.conn <- file(filename, open = "r")
    ############################################################################

    ############################################################################
    ## Verbose/Debug
    if (verbose || debug){
        i <- 0
    }
    if (verbose & !debug){
        pb <- txtProgressBar(0, countLines(filename), char = "=", style=3)
    }
    ############################################################################

    ############################################################################
    ## Loop for reading file lines
    while (length(line <- readLines(file.conn, n = 1, warn = FALSE)) > 0) {

        tryCatch({

            ####################################################################
            ## Verbose/Debug
            if (verbose || debug){
                i <- i + 1
            }
            if (verbose & !debug){
                setTxtProgressBar(pb,i)
            }
            ####################################################################

            ####################################################################
            ## Skip undesired lines before the table header
            ##
            ## Skip lines before the table header
            if(rib.table.found == FALSE){
                lines.skipped <- lines.skipped + 1
                if(grepl(rib.table.start.pattern,line)){
                    rib.table.found <- TRUE
                    if (debug){
                        cat("[", i,"] Table header found\n", sep="")
                    }
                    next
                }
                if (debug){
                    if(i == 1){
                        cat("Running in debug mode...\n")
                    }
                    cat("[", i,"] Skippig line \"", line, "\"\n", sep="")
                }
                next
            }

            ##
            ## Skip empty lines in the middle of the table
            if(grepl("^ *$", line)){
                if (debug){
                    cat("\r[", i,"] Skippig line \"", line, "\"\n", sep="")
                }
                next
            }

            if(debug){
                cat("\rProcessing [",i,"]... ",sep="")
            }

            ##
            ## Stop processing once the end of the table has been found
            if(grepl(rib.table.end.pattern,line)){
                if (debug){
                    cat("\r[",i,"] End of table found", sep="")
                }
                break
            }
            ####################################################################

            ####################################################################
            ## Parse line
            var.widths <- c(status.width,
                            network.width,
                            next.hop.width,
                            metric.width,
                            locprf.width,
                            weight.width,
                            path.width)

            bgp.vars <- data.table(t(split.fwf(line,
                                               var.widths,
                                               trim.spaces = TRUE,
                                               force.partial = TRUE,
                                               append.remaining = TRUE,
                                               na.string = "")))
            ####################################################################

            ####################################################################
            ## Path origin information extraction
            if (ncol(bgp.vars)>6){
                if (!is.na(bgp.vars[[7]])){
                    bgp.vars[[8]] <-
                        regmatches(bgp.vars[[7]],
                                   regexpr(origin.pattern,bgp.vars[[7]]))

                    bgp.vars[[7]] <- gsub(origin.pattern, "", bgp.vars[[7]])
                }
            }
            ####################################################################

            ####################################################################
            ## Split network and net mask into two variables
            ## This piece of code also fixes network address/mask values split
            ## when occur
            if (ncol(bgp.vars)>1){

                idx <- ncol(bgp.vars) + 1

                if (ncol(bgp.vars) > 1 && !is.na(bgp.vars[[2]])){

                    if (ncol(bgp.vars) > 2 && !is.na(bgp.vars[[3]])){

                        tmp_nehop <-
                            regmatches(bgp.vars[[3]],
                                       regexpr(ip.address.pattern,
                                               bgp.vars[[3]]))
                        if(length(tmp_nehop) == 0){
                            bgp.vars[[2]] <- paste(bgp.vars[[2]],
                                                   bgp.vars[[3]], sep="")
                            bgp.vars[[3]] <- NULL
                            idx <- idx -1

                            if (debug){
                                cat("\r[",i,"] Fixed network mask\n", sep="")
                            }

                        }

                    }

                    tmp_mask <- regmatches(bgp.vars[[2]],
                                           regexpr(ip.netmask.pattern,
                                                   bgp.vars[[2]]))

                    if (!identical(tmp_mask, character(0))){
                        bgp.vars[[idx]] <- tmp_mask
                        bgp.vars[[idx]] <- gsub("/", "", bgp.vars[[idx]])
                        bgp.vars[[2]] <- gsub(ip.netmask.pattern, "",
                                              bgp.vars[[2]])

                    } else {
                        bgp.vars[[idx]] <- NA
                    }

                } else {
                    bgp.vars[[idx]] <- NA
                }

                if (idx>3){
                    setcolorder(bgp.vars ,c(1,2,idx,3:ncol(bgp.vars))[-idx-1])
                }

            }
            ####################################################################

            ####################################################################
            ## Add empty variables  for lines that don't have all column values
            if (ncol(bgp.vars) < length(rib.table.vars)){
                for(j in c(eval(ncol(bgp.vars) + 1):length(rib.table.vars))){
                    bgp.vars[[j]] <- NA
                }
            }
            ####################################################################

            ####################################################################
            ## Set table var names
            setnames(bgp.vars, rib.table.vars)
            ####################################################################

            ####################################################################
            ## Remove duplicated AS entries from path if requested
            if(rdp){
                if ((!is.na(bgp.vars$path)) ) {
                    bgp.vars$path <-
                        paste(unique(strsplit(bgp.vars$path," +")[[1]]),
                                           collapse = ' ')
                }
            }

            ####################################################################

            ####################################################################
            ## In case the current line is a part of the previous line,
            ## this pice of code appends it to previous line.
            if(is.na(bgp.vars$status)){

                for(k in 1:ncol(bgp.vars)){
                    if (!is.na(bgp.vars[[k]])){
                        rib.table[[length(rib.table)]][[k]] <- bgp.vars[[k]]
                    }
                }

                if (debug){
                    cat("\r[",i,"] Line concatenated to previous line\n",
                        sep="")
                }

                ## Can follow to next line after the append
                next

            }
            ####################################################################

            ####################################################################
            ## Add network and network mask in lines without this information
            if(is.na(bgp.vars$network)){
                bgp.vars$network = rib.table[[length(rib.table)]]$network
                bgp.vars$netmask = rib.table[[length(rib.table)]]$netmask

                if (debug){
                    cat("\r[",i,"] Added network address and mask\n", sep="")
                }
            }
            ####################################################################

            ####################################################################
            ## Net mask adjustments for IPv4 network address without mask data
            if (ip.version == 4 && is.na(bgp.vars$netmask)) {

                ## CLASS A:   0.0.0.0 <-> 127.255.255.255 -> /08
                ## CLASS B: 128.0.0.0 <-> 191.255.255.255 -> /16
                ## CLASS B: 192.0.0.0 <-> 223.255.255.255 -> /24
                octect.first <- strsplit(bgp.vars$network, "\\.")[[1]][1]
                if(octect.first < 128){
                    bgp.vars$netmask <- 8
                } else if(octect.first < 192){
                    bgp.vars$netmask <- 16
                } else if(octect.first > 192){
                    bgp.vars$netmask <- 16
                }

                if (debug && !is.na(bgp.vars$netmask)){
                    cat("\r[",i,"] Added missing netmask\n", sep="")
                }

            }
            ####################################################################

            ####################################################################
            ## NOTE:
            ## For reference it follows some code benchmarking done with
            ## different appending approaches
            ####################################################################

            ####################################################################
            ## Assemble ouput table
            rib.table[[length(rib.table) + 1]] <-
                as.list(bgp.vars[,rib.table.vars, with = FALSE])
            ##    user  system   elapsed
            ##   72.71    0.20     73.38
            ####################################################################

            ####################################################################
            ## Assemble ouput table (another way to do it)
            ## rib.table <- c(rib.table,
            ##              c(network,next.hop,metric,locprf,weight,path)
            ##              )
            ##    user  system   elapsed
            ## 1022.04    0.43   1031.75
            ####################################################################

            ####################################################################
            ## Assemble ouput table (another way to do it)
            ## c <- c + 1
            ## rib.table[[as.character(c)]] <- c(
            ##        network,next.hop,metric,locprf,weight,path)
            ##    user  system   elapsed
            ## 404.29     0.44    410.11
            ####################################################################

        }, error = function(e) {
            stop("Error handling line [", i,
                 "].\n Could not handle string\n --> \"", line, "\".")
        })

    }
    ############################################################################

    ############################################################################
    ## Close connection to file
    close(file.conn)
    ############################################################################

    ############################################################################
    ## If verbose, close progress bar
    if (verbose & !debug){
        ## Close progress bar
        close(pb)
    }
    ############################################################################

    ############################################################################
    ## Bind per row all elements in the list
    rib.table <- rbindlist(rib.table)
    ############################################################################

    ############################################################################
    ## If table has no data return NA
    if(length(rib.table) == 0){
        return(NA)
    }
    ############################################################################

    ############################################################################
    ## RIB table header
    setnames(rib.table, rib.table.vars)
    ############################################################################

    ############################################################################
    ## Adjust column classes
    rib.table <-
        mutate(rib.table,
               netmask = as.factor(netmask),
               metric = as.numeric(metric),
               locprf = as.numeric(locprf),
               weight = as.numeric(weight))
    ############################################################################

    ############################################################################
    ## Remove duplicated lines if option marked as TRUE
    if (rdl){
        rib.table <- unique(rib.table)
    }

    ############################################################################
    ## Return RIB object
    return(rib.table)
    ############################################################################

}
################################################################################


################################################################################
#'
#' This is a help function for processing multiple log files
#'
#' @param input.data The folder or file for single or multiple "rib"
#'                  printouts.
#' @param output.path The folder for outputing the processed results.
#' @param save.rib.on.file If the function should save or should not save the
#'                      the processed RIB tables.
#' @param save.prefixes.on.file If the function should save or should not
#'                              save the prefixes tables
#' @param verbose Print verbose information
#'
bgp.rib.m.parse <- function(input.data, output.path,
                            save.rib.on.file = TRUE,
                            save.prefixes.on.file = TRUE,
                            verbose = TRUE,
                            ...){

    ############################################################################
    ## The required list of libraries for running this function
    require("data.table", quietly = TRUE)
    ############################################################################

    ############################################################################
    ## If verbose, print start time
    if (verbose){
        time.start <- Sys.time()
        cat("Start time:", format(time.start, "%Y-%m-%d %H:%M:%S"), "\n")
    }
    ############################################################################

    ############################################################################
    ## If input.data is a folder it searches for TXT or GZ files
    ## If input.data is a file, continue processing
    ## Stop on error if folder or file not found.
    if (file.exists(input.data)){
        if (file.info(input.data)$isdir){

            ####################################################################
            ## If verbose, show information
            if (verbose){
                cat("Processing multiple files in folder \"",
                    input.data, "\"...\n", sep="")
            }
            ####################################################################

            files <- list.files(input.data, pattern = "(txt|gz)$",
                                full.names = TRUE)
        } else {
            files <- input.data
        }
    } else {
        stop(paste(input.data, " not found.", sep=""))
    }
    ############################################################################

    ############################################################################
    ## Loop all files entered
    for(f in files){

        if (verbose){
            cat("Processing \"", f, "\"...\n", sep="")
        }

        name <- gsub(".*/","", sub("\\.[[:alnum:]]+$", "", f))

        rib.table <- .bgp.rib.parse(f, verbose = verbose, ...)

        ########################################################################
        ## Save rib on file is required if needed
        ## or else save on variable
        if (save.rib.on.file){

            path <- paste(output.path, "/",
                          OUTPUT.DEFAULT.PROCESSED.SUBPATH, sep="")

            if (!file.exists(path)){
                dir.create(path, recursive = TRUE)
            }

            gzfile <- gzfile(paste(path, "/", "rib.table.", name, ".csv.gz",
                                   sep=""), "w")
            write.csv(rib.table, gzfile, row.names=FALSE)
            close(gzfile)

            ####################################################################
            ## If verbose, show information
            if (verbose){
                cat("RIB table file \"", path, "/", name,
                    ".rib.csv.gz\" created.\n", sep="")
            }
            ####################################################################

        }
        ########################################################################

        rib.prefixes <- bgp.rib.prefixes.count(rib.table)

        ########################################################################
        ## Save prefixes on file is required if needed
        ## or else save on var
        if (save.prefixes.on.file){

            path <- paste(output.path, "/",
                          OUTPUT.DEFAULT.PREFIXES.SUBPATH, sep= "")

            if (! file.exists(path)){
                dir.create(path, recursive = TRUE)
            }

            write.csv(rib.prefixes,
                      paste(path, "/", "rib.prefixes.", name, ".csv", sep=""),
                      row.names=FALSE)

            ####################################################################
            ## If verbose, show information
            if (verbose){
                cat("Prefixes file \"", path, "/", name,
                    ".prefixes.csv\" created.\n", sep="")
            }
            ####################################################################

        }

        ## Record values in memory variables
        ## It has been commented out in here because it can use a lot of
        ## memory from the computer
        ## assign(paste(name, "rib", sep="."),
        ##       new("RIB", table = rib.table, prefixes = rib.prefixes))

        ########################################################################
    }
    ############################################################################

    ############################################################################
    ## If verbose, print start time, end time and total execution time.
    if (verbose){
        time.end <- Sys.time()

        time.diff <- difftime(time.end, time.start, units = c("auto", "secs",
                                                              "mins", "hours",
                                                              "days", "weeks"))

        cat("Start time: ", format(time.start, "%Y-%m-%d %H:%M:%S"),
            ", End time: ", format(time.end, "%Y-%m-%d %H:%M:%S"),
            "\n", sep = "")
        cat("Total execution time:",time.diff,attr(time.diff,"units"),"\n")
        cat("Done.\n", sep="")
    }
    ############################################################################
}
################################################################################

################################################################################
#'
#' This is a help function for processing multiple RIB CSV files
#'
#' @param filename The folder or file for single or multiple processed "rib"
#'                  files, either in CSV or CSV.GZ format .
#' @param rdl Remove duplicated lines from parsed data.
#'            The default value is \code{TRUE}.
#'
bgp.rib.read.csv <- function(filename, rdl = TRUE){

    require("data.table", quietly = TRUE)
    require("dplyr", quietly = TRUE)

    ############################################################################
    ## Check if input file exists
    if (!file.exists(filename)){
        stop(paste(filename," not found.",sep=""))
    }
    ############################################################################

    ############################################################################
    ## If verbose, show information
    if (verbose){
        cat("Processing \"", filename, "\"...\n", sep="")
    }
    ############################################################################

    ############################################################################
    ## Read CSV file and adjust variable types
    rib.table <- read.csv(filename)
    ############################################################################

    ############################################################################
    ## Remove duplicated lines if asked for.
    if (rdl){
        rib.table <- unique(rib.table)
    }
    ############################################################################

    ############################################################################
    # Adjust table format
    rib.table <- as.data.table(rib.table)
    ############################################################################

    ############################################################################
    ## Return RIB object
    return(rib.table)
    ############################################################################
}
################################################################################

################################################################################
#'
#' This is a help function for processing multiple RIB CSV files
#'
#' @param input.data The folder or file for single or multiple processed "rib"
#'                  files, either in CSV or CSV.GZ format .
#' @param save.prefixes.on.file If the function should save or should not
#'                              save the prefixes output table
#' @param output.path The folder for outputing the processed results.
#' @param rdl Remove duplicated lines from parsed data.
#'            The default value is \code{TRUE}.
#' @param verbose Print verbose information
#'
bgp.rib.m.read.csv <- function(input.data, output.path,
                               save.prefixes.on.file = TRUE,
                               rdl = TRUE,
                               verbose = TRUE){

    require("data.table", quietly = TRUE)

    ############################################################################
    ## If verbose, show information
    if (verbose){
        time.start <- Sys.time()
        cat("Start time:", format(time.start, "%Y-%m-%d %H:%M:%S"), "\n")
    }
    ############################################################################

    ############################################################################
    ## Check if input file/dir exits
    if (file.exists(input.data)){
        if (file.info(input.data)$isdir){

            ####################################################################
            ## If verbose, show information
            if (verbose){
                cat("Processing multiple files in folder \"",
                    input.data, "\"...\n", sep="")
            }
            ####################################################################

            files <- list.files(input.data, pattern = "(txt|gz)$",
                                full.names = TRUE)
        }else{
            files <- input.data
        }
    } else {
        stop(paste(input.data, " not found.", sep=""))
    }
    ############################################################################

    ############################################################################
    ## Loop through all files in folder.
    ## If a single file was entered, the loop will run only once.
    for(f in files){

        name <- gsub(".*/","", sub("\\.[[:alnum:]]+$", "", f))

        ########################################################################
        # Read RIB table and calculate the prefixes usage
        rib.table <- bgp.rib.read.csv(f, rdl = rdl)
        rib.prefixes <- bgp.rib.prefixes.count(rib.table)
        ########################################################################

        if (save.prefixes.on.file){

            path = paste(output.path, "/",
                         OUTPUT.DEFAULT.PREFIXES.SUBPATH, sep ="")

            if (!file.exists(path)){
                dir.create(path, recursive = TRUE)
            }

            out.prefixes <- paste(path, "/",  name, ".csv", sep="")

            write.csv(rib.prefixes, out.prefixes, row.names=FALSE)
        }

    }

    ############################################################################
    ## If verbose, show information
    if (verbose){
        time.end <- Sys.time()

        time.diff <- difftime(time.end, time.start, units = c("auto", "secs",
                                                              "mins", "hours",
                                                              "days", "weeks"))

        cat("Start time: ", format(time.start, "%Y-%m-%d %H:%M:%S"),
            ", End time: ", format(time.end, "%Y-%m-%d %H:%M:%S"),
            "\n", sep = "")
        cat("Total execution time:",time.diff,attr(time.diff,"units"),"\n")
        cat("Done.\n", sep = "")
    }
    ############################################################################

}
################################################################################

################################################################################
#'
#'This function counts the number occurrences for each network prefix found in
#'rib table and calculates the percentage of each prefix occurrence.
#'This function allows saving the data on a CSV file that the name is entered
#'with the parameter \code{file}.
#'
#'@param rib The \code{rib} object class with rib result table.
#'@return \code{data.table} with prefixes occurrences and percentage
#'@example
#'bgp.rib.prefixes.count(bgp.rib.parse("data/lg.sp.ptt.br-BGPv4.txt.gz"))
#'
bgp.rib.prefixes.count <- function(rib.table){

    ############################################################################
    ## The required list of libraries for running this function
    require("data.table", quietly = TRUE)
    ############################################################################

    ############################################################################
    ## Return if rib.table is either null or NA
    if (is.null(rib.table)) return()
    ############################################################################

    ############################################################################
    ## Return if rib.table is not of class RIB
    if (!is(rib.table, "data.table") && is.na(rib.table)) return(NA)
    ############################################################################

    ############################################################################
    ## Get prefixes from the table and cross-classify factors to build
    ## a contingency table of the counts at each combination of factor levels.
    prefixes <- as.data.table(table(rib.table$netmask))
    ############################################################################

    ############################################################################
    ## Set column names of prefixes table
    setNames(prefixes,c("prefix","occurrence"))
    ############################################################################

    ############################################################################
    ## Calculate percentage
    prefixes <- mutate(prefixes, prefix = as.numeric(prefixes$prefix),
                       occurrence = as.numeric(prefixes$occurrence),
                       percentage = prefixes$occurrence /
                           sum(prefixes$occurrence) * 100
    )
    ############################################################################

    ############################################################################
    ## Return
    return(prefixes[order(prefixes$prefix)])
    ############################################################################
}
################################################################################