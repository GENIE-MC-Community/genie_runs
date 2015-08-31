#!/usr/bin/env python
'''
Read a GENIE spline and print it back with cross section units of cm2 instead
of inverse GeV.

Usage:
    python spl_gevinv_to_cm2.py spline.xml
'''
from __future__ import print_function
import sys
from xml.etree import ElementTree as ET


def process_xml(root):
    """
    """
    meter = 5.07e+15  # 5.07e+15 / GeV
    centimeter = 0.01 * meter
    cm2 = centimeter * centimeter

    for spline in root.findall('./spline'):
        for knot in spline.findall('./knot'):
            x = knot.find('./xsec')
            xsec = float(x.text) / cm2
            x.text = " " + str(xsec) + " cm2 "

    return root


if __name__ == '__main__':
    
    if '-h' in sys.argv or '--help' in sys.argv:
        print(__doc__)
        sys.exit(1)

    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(2)

    xml_file = sys.argv[1]

    with open(sys.argv[1], "r") as f:
        xsec_tree = ET.parse(xml_file)
        root = xsec_tree.getroot()
        root = process_xml(root)
        xsec_tree.write("cm2_" + xml_file)
