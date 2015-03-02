#!/usr/bin/env python

################################################################################
# Libraries import
import sys
sys.path.append('../MatPlotLibIntrig')
from gnuplot import *
import glob
################################################################################

################################################################################
# Constants
MIN_PERMITTED_VALUE = 1.11  # For excluding unneeded values from graph
INPUT_FOLDER = "prefixes"   # Prefixes tables input folder
FILE_EXTENSION = "*.csv"    # Prefixes tables extensions
SKIP_HEADER_LINES = 1       # Number of lines to skip in the beginning
                            # # of the file
################################################################################

## Files list
files = glob.glob1(INPUT_FOLDER, FILE_EXTENSION)

## Calculate number of files
number_of_files = len(files)

## Terminal welcome message
print("Processing " + str(number_of_files) + " prefixes tables...")

################################################################################
# Loop for processing each prefix table
for file in files:

    ############################################################################
    # Read prefixes table lines
    f = open(INPUT_FOLDER + "/" + file, 'r')
    lines = f.readlines()[SKIP_HEADER_LINES:]
    f.close()
    ############################################################################

    ############################################################################
    # Read each row of the file and extract each column information
    x = []; y = []; t = []; xt = []
    for line in lines:
        p = line.split(',')
        if float(p[2]) > MIN_PERMITTED_VALUE:
            x.append(int(p[0]))
            xt.append("/" + p[0])
            y.append(float(p[1]))
            t.append('%.1f' % round(float(p[2]), 1) + '%')
    ############################################################################

    ############################################################################
    # Plot graph
    id = ''.join(e for e in file[12:16] if e.isalnum())
    bar_graph_plot(id, x, y, "graphics",
                    "'rib.prefixes.graph.' + id + '.eps'",
                    "id.upper() +  ' PREFIXES'", "Prefixes",
                    "Number of Prefixes", xt, None, t, True)
    ############################################################################

################################################################################

## Done message
print("Plotting prefixes done.")
