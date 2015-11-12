#!/usr/bin/env python
'''
Compare two GENIE spline files with formatting circa 2.8.N.
Usage:
    python plot_res_spline_comp.py spline1.xml spline2.xml
'''
from __future__ import print_function
import sys
from xml.etree import ElementTree as ET
from math import log10, floor
import subprocess

meter = 5.07e+15  # 5.07e+15 / GeV
centimeter = 0.01 * meter
cm2 = centimeter * centimeter
p_has_dvipng = False


def round_sig(x, sig=3):
    return round(x, sig-int(floor(log10(abs(x))))-1)


def decode_flavor(flavor):
    """
    Change the PDG code into a string.
    """
    return {
        '-16': 'Tau Antineutrino',
        '-14': 'Muon Antineutrino',
        '-12': 'Electron Antineutrino',
        '12': 'Electron Neutrino',
        '14': 'Muon Neutrino',
        '16': 'Tau Neutrino'
    }.get(flavor, 'Unknown')


def decode_target(targetcode):
    """
    Change the PDG ion code into a named string. Growing into this...
    """
    return {
        '1000010010': 'Hydrogen',
        '1000060120': 'Carbon',
        '1000080160': 'Oxygen',
        '1000180400': 'Argon40'
    }.get(targetcode, 'PDG Ion Code: ' + targetcode)


def decode_nc_cc(proc):
    """
    Figure out whether a proc is CC or NC.
    """
    import re
    cc_pat = re.compile(r"\[CC\]")
    nc_pat = re.compile(r"\[NC\]")
    if cc_pat.search(proc):
        return 'CC'
    if nc_pat.search(proc):
        return 'NC'
    return 'Unknown Current'


def get_neutrino_description(description):
    """
    Take a GENIE description string like:
        'genie::ReinSeghalCOHPiPXSec/Default/nu:-14;tgt:1000060120;
         proc:Weak[CC],COH;hmult:(p=0,n=0,pi+=0,pi-=1,pi0=0);'
    and return:
    {'algorithm': 'ReinSeghalCOHPiPXSec',
     'flavor': 'muon_antineutrino',
     'hmult': '(p=0,n=0,pi+=0,pi-=1,pi0=0)',
     'proc': 'Weak[CC],COH',
     'tgt': '1000060120'}
    """
    components = description.split(';')
    alg_flavor = components[0].split('/')
    alg = alg_flavor[0].split(':')[-1]
    flavor = decode_flavor(alg_flavor[-1].split(':')[-1])
    ddict = {'algorithm': alg, 'flavor': flavor}
    components = components[1:]
    for component in components:
        elem = component.split(':')
        if len(elem) > 1:
            ddict[elem[0]] = elem[1]

    return ddict


def process_spline(spline, sig=6):
    """
    Transform a spline (object) from an ElementTree retrieval
    into a dictionary containing the relevant information.

    The number of significant figures to include in the spline
    is an optional argument.
    """
    knots = spline.findall('./knot')
    xsecs = []
    for knot in knots:
        e = knot.find('./E')
        x = knot.find('./xsec')
        e = float(e.text)
        x = float(x.text)
        if x > 0:
            x = round_sig(x, sig)
        xsecs.append((e, x))
    description = get_neutrino_description(spline.get('name'))
    return {'description': description, 'xsecs': xsecs}


def xml_to_list_of_dicts(xml_file_name, sig=6):
    """
    Take an xml file and return a list of dictionaries, where each dictionary
    contains a description and a list of tuples for energy and cross section.
    The description key is 'description' and the cross sections key is 'xsecs'.

    The number of significant figures to include in the spline
    is an optional argument.
    """
    xsec_xml = ET.parse(xml_file_name)
    splines = xsec_xml.findall('./spline')
    neutrino_xsecs = []

    for spline in splines:
        xsec_dict = process_spline(spline, sig)
        neutrino_xsecs.append(xsec_dict)

    return neutrino_xsecs


def plot_xsec_dicts(xsd1, xsd2, plot_cm2=True):
    import matplotlib.pyplot as plt
    import re

    global p_has_dvipng
    plt.clf()
    plt.ioff()
    plt.rc('font', **{'family': 'sans-serif', 'sans-serif': ['Helvetica']})
    if p_has_dvipng:
        plt.rc('text', usetex=True)

    title = xsd1['description']['flavor'] + " " + \
        decode_nc_cc(xsd1['description']['proc']) + \
        " on " + decode_target(xsd1['description']['tgt'])
    if xsd1['description'].has_key('res'):
        title += ' Res ' + xsd1['description']['res']
    if xsd1['description'].has_key('N'):
        title += ' N ' + xsd1['description']['N']
    file_name = re.sub(r'\s+', '_', title)

    y_axis_title = r''
    if p_has_dvipng:
        y_axis_title = r'Cross Section (per GeV$^{-2}$)'
        if plot_cm2:
            y_axis_title = r'Cross Section (per $10^{-38}$ cm$^{2}$)'
    else:
        y_axis_title = r'Cross Section (per GeV^(-2))'
        if plot_cm2:
            y_axis_title = r'Cross Section (per 10^(-38) cm^2)'
            
    x_axis_title = r'Neutrino Energy (GeV)'
    xsecs_tup1 = xsd1['xsecs']
    xsecs_tup2 = xsd2['xsecs']
    # assume energies are the same in both tups
    energies = []
    xsecs1 = []
    xsecs2 = []
    for tup in xsecs_tup1:
        energies.append(tup[0])
        xsecs1.append(tup[1] / cm2 / 1e-38 if plot_cm2 else tup[1])
    for tup in xsecs_tup2:
        xsecs2.append(tup[1] / cm2 / 1e-38 if plot_cm2 else tup[1])

    plt.plot(energies, xsecs1, label=xsd1['description']['algorithm'])
    plt.plot(energies, xsecs2, label=xsd2['description']['algorithm'])
    plt.xlabel(x_axis_title)
    plt.ylabel(y_axis_title)
    plt.legend(loc='best')
    plt.title(title)
    plt.savefig(file_name + ".pdf")


if __name__ == '__main__':
    if '-h' in sys.argv or '--help' in sys.argv:
        print(__doc__)
        sys.exit(1)

    if len(sys.argv) < 3:
        print(__doc__)
        sys.exit(2)

    xml_file1 = sys.argv[1]
    xml_file2 = sys.argv[2]

    global p_has_dvipng
    p = subprocess.Popen(["which", "dvipng"],
                         stdout=subprocess.PIPE,
                         stderr=subprocess.PIPE)
    (dvipng_out, dvipng_err) = p.communicate()
    if len(dvipng_err) == 0:
        p_has_dvipng = True

    # Create a list of cross-sections, where each cross section is represented
    # by a dictionary containing a description and the numerical x-sections.
    list_of_dicts1 = xml_to_list_of_dicts(xml_file1)
    list_of_dicts2 = xml_to_list_of_dicts(xml_file2)

    list_of_res = []
    for d1 in list_of_dicts1:
        if 'CC' in d1['description']['proc']:
            list_of_res.append(d1['description']['res'])

    # do 2112 first
    for Ncheck in ['2112', '2212']:
        list_of_pairs = []
        for res in list_of_res:
            pair = []
            for d1 in list_of_dicts1:
                if d1['description']['res'] == str(res) and \
                        'CC' in d1['description']['proc'] and \
                        d1['description']['N'] == Ncheck:
                    pair.append(d1)
            for d2 in list_of_dicts2:
                if d2['description']['res'] == str(res) and \
                        'CC' in d2['description']['proc'] and \
                        d2['description']['N'] == Ncheck:
                    if d2['description']['N'] == pair[0]['description']['N']:
                        pair.append(d2)
            if len(pair) == 2:
                list_of_pairs.append(pair)

        for pair in list_of_pairs:
            for p in pair:
                print(p['description'])
            print("\n")
            plot_xsec_dicts(pair[0], pair[1])
