#!/usr/bin/env python

################################################################################
# Libraries import
import sys
import matplotlib.pyplot as plt
from matplotlib.font_manager import FontProperties
import numpy as np
import glob
################################################################################

################################################################################
# Constants
MIN_PERMITTED_VALUE = 1        # For excluding unneeded values from graph
INPUT_FOLDER = "prefixes.v6"   # Prefixes tables input folder
FILE_EXTENSION = "*.csv"       # Prefixes tables extensions
SKIP_HEADER_LINES = 1          # Number of lines to skip in the beginning
                               # of the file
GRAPH_LINE_WIDTH = 2
GRAPH_MARKER_SIZE = 11
AXIS_LABEL_SIZE = 20
AXIS_TICK_LABEL_SIZE = 18

default = {"color": "black", "linestyle": "solid",   "marker": " "}
df = {"color": "brown",   "linestyle": "solid", "marker": "o"}
mg = {"color": "blue",  "linestyle": "dotted",  "marker": "D"}
rj = {"color": "red",   "linestyle": "dotted",  "marker": "^"}
rs = {"color": "magenta",  "linestyle": "solid",   "marker": "s"}
vix = {"color": "green", "linestyle": "dotted",  "marker": "h"}

################################################################################

# Files list
files = glob.glob1(INPUT_FOLDER, FILE_EXTENSION)

# Calculate number of files
number_of_files = len(files)

# Terminal welcome message
print("Processing " + str(number_of_files) + " prefixes tables...")

xlim_min = 100;
xlim_max = 0;

################################################################################
# Initiates figure object
fig = plt.figure()
ax1 = fig.add_subplot(111)
################################################################################

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
    x = []; y = []; tx = []; xt = [];
    for line in lines:
        p = line.split(',')
        if float(p[2]) > MIN_PERMITTED_VALUE:
            xlim_min = int(p[0]) if xlim_min > int(p[0]) else xlim_min
            xlim_max = int(p[0]) if xlim_max < int(p[0]) else xlim_max
            x.append(int(p[0]))
            y.append(float(p[1]))
            tx.append('%.1f' % round(float(p[2]), 1) + '%')
    ############################################################################

    ############################################################################
    # Plot graph
    id = ''.join(e for e in file[12:16] if e.isalnum())

    ############################################################################
    # Read color schema from constants file if exists
    # or else set preset with default values
    if (id.lower() in vars()) or (id.lower() in globals()):
        preset = eval(id)
    else:
        preset = default
    ############################################################################

    ############################################################################
    # Read each color setting from the chosen schema
    color = preset.get("color")
    linestyle = preset.get("linestyle")
    marker = preset.get("marker")
    ############################################################################

    # Compute the CDF
    Y = np.cumsum(y)

    ax1.plot(x, Y, markersize=GRAPH_MARKER_SIZE,
             color=color,
             linestyle=linestyle,
             marker=marker,
             linewidth=GRAPH_LINE_WIDTH,
             label=id.upper())
    ############################################################################

################################################################################

tk_lb_u = [];
tk_lb_d = [];

xlim_max += 1
tks = np.arange(xlim_min, xlim_max, 1)

ax1.set_xlim(xlim_min - 1, xlim_max)
ax1.grid(True)
ax1.set_yscale('log')
ax1.set_xticks(tks[0:][::2])
ax1.set_xticklabels(["/" + str(t) for t in tks[0:][::2]])
ax1.tick_params(axis='both', which='major', labelsize=AXIS_TICK_LABEL_SIZE)
ax1.set_xlabel("Prefixes", fontweight='bold', fontsize=AXIS_LABEL_SIZE)
ax1.xaxis.labelpad = 15
ax1.set_ylabel("Amount", fontweight='bold', fontsize=AXIS_LABEL_SIZE)
ax1.yaxis.labelpad = 15

ax2 = ax1.twiny()

ax2.set_xlim(xlim_min - 1, xlim_max)
ax2.grid(True)
ax2.set_yscale('log')
ax2.set_xticks(tks[1:][::2])
ax2.set_xticklabels(["/" + str(t) for t in tks[1:][::2]])
ax2.tick_params(axis='both', which='major', labelsize=AXIS_TICK_LABEL_SIZE)
##

#font_prop = FontProperties()
#font_prop.set_size('small')
#ax1.legend(prop=font_prop, loc='best')
ax1.legend(loc='best')

# plt.yscale('log')
# plt.show()

# Save of file
fig_name = "rib_" + INPUT_FOLDER + "_ipv6_cdf_graph.eps"
plt.savefig(INPUT_FOLDER + "/" + fig_name, bbox_inches='tight')

# Close
plt.close()

## Done message
print("Plotting prefixes done.")


