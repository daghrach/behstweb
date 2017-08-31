#!/usr/bin/env python2.7 

"""
This script takes a HiCCUPS_looplist.txt file as input, deletes columns apart from chromosome #'s and
looping coordinates, adjusts these coordinates from 1-based to 0-based, duplicates each looping pair
and swaps x1/x2 and y1/y2, and outputs this as a .bed file.
"""

import sys, csv, os

dir = os.getcwd()
output_name = str(os.path.basename(sys.argv[1])).split('.txt')[0] + '_filtered.bed'
output = os.path.join(dir, ('../data/temp/' + output_name))

with open(sys.argv[1], 'rb') as hi_c_file:
    hi_c_reader = csv.reader(hi_c_file, delimiter = '\t')
    hi_c_filtered_output = csv.writer(sys.stdout, delimiter='\t')

    next(hi_c_file, None) # skip header row

    for row in hi_c_reader:
        hi_c_filtered_output.writerow((("chr" + row[0]),
                                       str(int(row[1]) - 1),
                                       str(int(row[2]) - 1),
                                       ("chr" + row[3]),
                                       str(int(row[4]) - 1),
                                       str(int(row[5]) - 1)))
    hi_c_file.seek(0) # reset csv.reader to top of file
    next(hi_c_file, None) # skip header row

    for row in hi_c_reader:
        hi_c_filtered_output.writerow((("chr" + row[3]),
                                       str(int(row[4]) - 1),
                                       str(int(row[5]) - 1),
                                       ("chr" + row[0]),
                                       str(int(row[1]) - 1),
                                       str(int(row[2]) - 1)))


