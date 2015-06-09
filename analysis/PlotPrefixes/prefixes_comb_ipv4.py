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
df = {"color": "brown",   "linestyle": "dashdot", "marker": "o"}
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

y_all = [];

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
    x = [];
    y = [];
    tx = [];
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

    ############################################################################
    # Read color schema from constants file if exists
    # or else set preset with default values
    if (id.lower() in vars()) or (id.lower() in globals()):
        preset = eval(id)
    else:
        preset = default
    ############################################################################

    ############################################################################
    # Compute the percentage
    y_total = sum(y)
    y = [(yv / y_total)*100 for yv in y ]
    ############################################################################

    ############################################################################
    # List of all prefixes counting in percentage
    y_all.append(y)
    #
    ############################################################################

################################################################################

################################################################################
# Calculation of the mean graph and std variation for each LG
y_all = np.array(y_all)
y_mean = y_all.mean(0).tolist()
y_std = y_all.std(0).tolist()
y_std = [ys for ys in y_std]
################################################################################

################################################################################
# Create plot
ax1.plot(x, y_mean,
             markersize=10,
             color="red",
             linestyle="",
             marker="s",
             #linewidth=2,
             label="DF, MG, RJ, RS and VIX")

ax1.errorbar(x, y_mean, [ys * 5 for ys in y_std],
             linestyle="dotted",
             #marker="s",
             linewidth=2
             #label="DF, MG, RJ, RS and VIX"
             )
################################################################################

ticks_x = np.arange(min(x) - 1, max(x) + 1, 1)
ticks_y = np.arange(0, max(y) + 10, 10)

ax1.set_xlim(min(x) - 2, max(x) + 1)
ax1.set_ylim(min(y) - 10, max(y) + 10)

for h in range(0,len(x)):
    adj_x = 0 if h != len(x)-1 else -0.7
    adj_y = 3
    if h < len(x)-1:
        if y[h] < y[h+1]:
            adj_y = -4
    ax1.annotate(str(int(y[h])) + "%", xy=(x[h] + adj_x, y[h] + adj_y))

# ax1.grid(True)
ax1.set_xticks(ticks_x[0:][::2])
ax1.set_xticklabels(["/" + str(t) for t in ticks_x[0:][::2]])
ax1.set_yticks(ticks_y)
ax1.set_yticklabels([str(int(t)) + "%" for t in ticks_y])
ax1.tick_params(axis='both',
                which='major',
                labelsize=AXIS_TICK_LABEL_SIZE)
ax1.set_xlabel("Prefixes IPv4",
               fontweight='bold',
               fontsize=AXIS_LABEL_SIZE)
ax1.xaxis.labelpad = 15

ax1.set_ylabel("Percentage",
               fontweight='bold',
               fontsize=AXIS_LABEL_SIZE)
ax1.yaxis.labelpad = 15

font_prop = FontProperties()
font_prop.set_size('large')
ax1.legend(prop=font_prop, loc='upper left')

ax2 = ax1.twiny()
# ax2.grid(True)
ax2.set_xlim(min(x) - 2, max(x) + 1)
ax2.set_xticks(ticks_x[1:][::2])
ax2.set_xticklabels(["/" + str(t) for t in ticks_x[1:][::2]])
ax2.tick_params(axis='both',
                which='major',
                labelsize=AXIS_TICK_LABEL_SIZE)

bbox_props = dict(boxstyle="round,pad=0.3", fc="white", ec="black", lw=1)
ax2.annotate(r"max $\sigma$ = " +
             str(round(max(y_std),2)),
             xy=(20,45),
             bbox=bbox_props, size=15)

# plt.yscale('log')
# plt.show()

# Save of file
fig_name = "rib_" + INPUT_FOLDER + "_ipv4_per_graph.eps"
plt.savefig(INPUT_FOLDER + "/" + fig_name)

## Close
plt.close()

## Done message
print("Plot saved at " + INPUT_FOLDER + "/" + fig_name)
print("Plotting prefixes done.")


