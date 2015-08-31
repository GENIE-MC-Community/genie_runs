#!/usr/bin/env python
'''
Read a GENIE spline and print it back with cross section units of cm2 instead
of inverse GeV.

Usage:
    python spl_gevinv_to_cm2.py spline.xml

Note that we print out a new "spline" file with name cm2_<old file>. While the
new file has the same XML structure as a GENIE spline file, it is NOT usable
as a spline by GENIE (it is meant to be looked at by eye if you want to see 
cross sections in cm2, not to be used by GENIE).
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
