#!/usr/bin/env python
'''
Open a GENIE spline file with formatting circa 2.9.N.
Usage:
    python plot_splines.py <-f>/<-flag> <arg>
                           -c / --cm2         : Plot cross seciton in cm^{2}
                           -s / --splines spline1,spline2,spline3,...

'''
from __future__ import print_function
from xml.etree import ElementTree as ET
import subprocess

meter = 5.07e+15  # 5.07e+15 / GeV
centimeter = 0.01 * meter
cm2 = centimeter * centimeter
p_has_dvipng = False


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
        '1000080160': 'Oxygen'
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
     'flavor': 'Muon Antineutrino',
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


def process_spline(spline):
    """
    Transform a spline (object) from an ElementTree retrieval
    into a dictionary containing the relevant information.
    """
    knots = spline.findall('./knot')
    xsecs = []
    for knot in knots:
        e = knot.find('./E')
        x = knot.find('./xsec')
        en = float(e.text)
        xs = float(x.text)
        xsecs.append((en, xs))
    description = get_neutrino_description(spline.get('name'))
    return {'description': description, 'xsecs': xsecs}


def xml_to_list_of_dicts(xml_file_name):
    """
    Take an xml file and return a list of dictionaries, where each dictionary
    contains a description and a list of tuples for energy and cross section.
    The description key is 'description' and the cross sections key is 'xsecs'.
    """
    xsec_xml = ET.parse(xml_file_name)
    splines = xsec_xml.findall('./spline')
    neutrino_xsecs = []

    for spline in splines:
        xsec_dict = process_spline(spline)
        neutrino_xsecs.append(xsec_dict)

    return neutrino_xsecs


def plot_xsec_dict(xsd, plot_cm2):
    import matplotlib.pyplot as plt
    import re

    global p_has_dvipng
    plt.clf()
    plt.ioff()
    plt.rc('font', **{'family': 'sans-serif', 'sans-serif': ['Helvetica']})
    if p_has_dvipng:
        plt.rc('text', usetex=True)

    title = xsd['description']['algorithm'] + " " + \
        xsd['description']['flavor'] + " " +\
        decode_nc_cc(xsd['description']['proc']) + \
        " on " + decode_target(xsd['description']['tgt'])
    if xsd['description'].has_key('res'):
        title += ' Res ' + xsd['description']['res']
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
    xsecs_tup = xsd['xsecs']
    energies = []
    xsecs = []
    for tup in xsecs_tup:
        energies.append(tup[0])
        xsecs.append(tup[1] / cm2 / 1e-38 if plot_cm2 else tup[1])

    plt.plot(energies, xsecs)
    plt.xlabel(x_axis_title)
    plt.ylabel(y_axis_title)
    plt.title(title)
    plt.savefig(file_name + ".pdf")


def spline_list_split(option, opt, value, parser):
    setattr(parser.values, option.dest, value.split(','))


if __name__ == '__main__':
    from optparse import OptionParser

    parser = OptionParser(usage=__doc__)
    parser.add_option('-c', '--cm2', dest='plot_cm2', default=False,
                      help=r'Plot in cm^{2}', action='store_true')
    parser.add_option('-s', '--splines', type='string', action='callback',
                      callback=spline_list_split, dest='spline_files')
    (options, args) = parser.parse_args()

    global p_has_dvipng
    p = subprocess.Popen(["which", "dvipng"],
                         stdout=subprocess.PIPE,
                         stderr=subprocess.PIPE)
    (dvipng_out, dvipng_err) = p.communicate()
    if len(dvipng_err) == 0:
        p_has_dvipng = True
    
    list_of_dicts = []
    for spline_file in options.spline_files:
        list_of_dicts.extend(xml_to_list_of_dicts(spline_file))

    for d in list_of_dicts:
        print(d['description'])
        plot_xsec_dict(d, options.plot_cm2)
