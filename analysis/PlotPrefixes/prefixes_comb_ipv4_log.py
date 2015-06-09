#!/usr/bin/env python

################################################################################
# Libraries import
import sys
import matplotlib.pyplot as plt
from matplotlib import rcParams
rcParams.update({'figure.autolayout': True})
from matplotlib.font_manager import FontProperties
import numpy as np
import glob
################################################################################

################################################################################
# Constants
MIN_PERMITTED_VALUE = 1        # For excluding unneeded values from graph
INPUT_FOLDER = "prefixes.v4"   # Prefixes tables input folder
FILE_EXTENSION = "*.csv"       # Prefixes tables extensions
SKIP_HEADER_LINES = 1          # Number of lines to skip in the beginning
                               # of the file
GRAPH_LINE_WIDTH = 2
GRAPH_MARKER_SIZE = 11
AXIS_LABEL_SIZE = 20
AXIS_TICK_LABEL_SIZE = 18

default = {"color": "black", "linestyle": "solid",   "marker": " "}
df = {"color": "brown",   "linestyle": "solid", "marker": "o"}
mg = {"color": "blue",  "linestyle": "solid",  "marker": "D"}
rj = {"color": "red",   "linestyle": "solid",  "marker": "^"}
rs = {"color": "magenta",  "linestyle": "solid",   "marker": "s"}
vix = {"color": "green", "linestyle": "solid",  "marker": "h"}

################################################################################

# Files list
files = glob.glob1(INPUT_FOLDER, FILE_EXTENSION)

# Calculate number of files
number_of_files = len(files)

# Terminal welcome message
print("Processing " + str(number_of_files) + " prefixes tables...")

xlim_min = 100;
xlim_max = 0;
ylim_min = 100;
ylim_max = 0;

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

    ############################################################################
    # Compute axis max and min
    xlim_min = min(x) if xlim_min > min(x) else xlim_min
    xlim_max = max(x) if xlim_max < max(x) else xlim_max
    ylim_min = min(y) if xlim_min > min(y) else ylim_min
    ylim_max = max(y) if ylim_max < max(y) else ylim_max
    ############################################################################

    ax1.plot(x, y, markersize=GRAPH_MARKER_SIZE,
             color=color,
             linestyle=linestyle,
             marker=marker,
             linewidth=GRAPH_LINE_WIDTH,
             label=id.upper())
    ############################################################################

################################################################################

xlim_max += 1
ticks = np.arange(xlim_min - 1, xlim_max + 1, 1)

# ax1.set_ylim(ylim_min - 50, ylim_max + 100000)

ax1.set_xlim(xlim_min - 2 , xlim_max + 1)
# ax1.grid(True)
ax1.set_yscale('log')
ax1.set_xticks(ticks[0:][::2])
ax1.set_xticklabels(["/" + str(t) for t in ticks[0:][::2]])
ax1.tick_params(axis='both', which='major', labelsize=AXIS_TICK_LABEL_SIZE)
ax1.set_xlabel("Prefixes IPv4",
               fontweight='bold',
               fontsize=AXIS_LABEL_SIZE)
ax1.xaxis.labelpad = 15
ax1.set_ylabel("Amount",
               fontweight='bold',
               fontsize=AXIS_LABEL_SIZE)
ax1.yaxis.labelpad = 15

ax2 = ax1.twiny()

ax2.set_xlim(xlim_min - 2 , xlim_max + 1)
# ax2.set_ylim(ylim_min, ylim_max + 1000000)

# ax2.grid(True)
ax2.set_xticks(ticks[1:][::2])
ax2.set_xticklabels(["/" + str(t) for t in ticks[1:][::2]])
ax2.tick_params(axis='both', which='major', labelsize=AXIS_TICK_LABEL_SIZE)
##

font_prop = FontProperties()
font_prop.set_size('large')
ax1.legend(prop=font_prop, loc='best')

# plt.yscale('log')
# plt.show()

# Save of file
fig_name = "rib_" + INPUT_FOLDER + "_ipv4_log_graph.eps"
plt.savefig(INPUT_FOLDER + "/" + fig_name)

# Close
plt.close()

## Done message
# print("Plot saved at " + INPUT_FOLDER + "/" + fig_name)
print("Plotting prefixes done.")


