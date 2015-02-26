#!/usr/bin/env python

################################################################################
# version: 1.0
# data: 2015-02-26
################################################################################

################################################################################
# Libraries import
import matplotlib
matplotlib.use('Agg')
from constants import *
import matplotlib.pyplot as plt
import numpy as np
import os.path
import re
################################################################################

################################################################################
# Default color schema
default = {"color": 'white',
           "ecolor": 'black',
           "edgecolor": 'black',
           "hatch": " " }
################################################################################

################################################################################
# Function for plotting bar graph
def bar_graph_plot(id, x, y, output_path, graph_name, title,
                    x_label="X", y_label="Y", x_ticks=None, y_ticks=None,
                    bar_texts=None, log=False):
    """!
    This function makes a bar plot with the values in input file.
    @:param id String: name of the color pre-settings
    @:param x Vector: X values
    @:param y Vector: Y values
    @:param output_path String: path for graph output
    @:param graph_name String: graph file name
    @:param title String: graph title
    @:param x_label String: X axis label
    @:param y_label String: Y axis label
    @:param x_ticks Vector: X axis tick labels
    @:param y_ticks Vector: Y axis tick labels
    @:param bar_texts String: texts to be plotted on top of each bar
    @:param log Boolean: plot graph either using logarithmic scale or not
    """
    ############################################################################
    # Welcome message
    print("Plotting " +
          (eval(graph_name) if re.search("[\"']", graph_name) is not None
           else graph_name) + "... ", end='')
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
    # Read each color setting from the chosen schema
    hatch = preset.get("hatch")
    color = preset.get("color")
    ecolor = preset.get("ecolor")
    edgecolor = preset.get("edgecolor")
    ############################################################################

    ############################################################################
    # Plotting
    #
    # Initialize variables for plotting
    fig, ax = plt.subplots()
    #
    # Define bar object
    bars = ax.bar(np.array(x), np.array(y), 0.8, linewidth=1.3, color=color,
                   ecolor=ecolor, edgecolor=edgecolor,
                   hatch=hatch, align='center')
    #
    # Set log scale if needed
    if log:
        ax.set_yscale('log')
    #
    # Internal function for attaching text on the top of the each bar
    def add_label_to_bars(bars, bars_labels):
        i = 0
        for rect in bars:
            height = rect.get_height() * 1.02
            ax.text(rect.get_x() + rect.get_width() / 2, height, bars_labels[i],
                    ha='center', va='bottom', color=ecolor)
            i = i + 1
    #
    # Call the internal "add_label_to_bars" if required
    if not (bar_texts is None):
        add_label_to_bars(bars, bar_texts)
    #
    # Define plotting title
    plt.title(eval(title) if re.search("[\"']", title) is not None else title)
    #
    # Define X axis and Y axis titles
    plt.xlabel(
        eval(x_label) if re.search("[\"']", x_label) is not None else x_label,
        fontsize=11)
    plt.ylabel(
        eval(y_label) if re.search("[\"']", y_label) is not None else y_label,
        fontsize=11)
    #
    # Tick parameters settings
    plt.tick_params(axis='both', which='major', labelsize=14)
    #
    # Define tick strings if required
    if not (x_ticks is None):
        plt.xticks(x, x_ticks)
    if not (y_ticks is None):
        plt.yticks(y, y_ticks)
    #
    # Create output dir if it does not exist
    if not os.path.exists(output_path):
        os.makedirs(output_path)
    #
    # Define file name for plotting
    fig_name = eval(graph_name) if re.search("[\"']", graph_name) is not None else graph_name
    #
    # Save of file
    plt.savefig(output_path + "/" + fig_name)
    #
    # Free memory cleaning graphic object
    plt.close()
    ############################################################################

    # Print done
    print("Done.")

    # Return
    return

