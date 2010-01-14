#!/usr/bin/env jython
# -*- coding: utf-8 -*-
#
#    Copyright © 2009,2010 Łukasz Rekucki
#
#    This file is part of WL2PDF
#
#    WL2PDF is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    WL2PDF is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with WL2PDF.  If not, see <http://www.gnu.org/licenses/>.

from __future__ import with_statement

import os
import sys

from java.io import *
from java.lang import *

from net.sf.saxon import TransformerFactoryImpl as TransformerFactory
from javax.xml.transform import Transformer

from javax.xml.transform import Source
from javax.xml.transform import Result
from javax.xml.transform.stream import StreamSource, StreamResult
from javax.xml.transform.sax import SAXResult

from org.apache.fop.fo import ValidationException
from net.sf.saxon.trans import XPathException

from org.apache.fop.apps import *;

RUNTIME_PATH = os.path.abspath(os.path.dirname(__file__))

CONFIG_PATH = os.path.join(RUNTIME_PATH, 'fop-config.xml')

fop_factory = FopFactory.newInstance()
fop_factory.setUserConfig(File(CONFIG_PATH));

xfrm_factory = TransformerFactory()

wl2fo_tmplt = xfrm_factory.newTemplates(StreamSource(\
        File(os.path.join(RUNTIME_PATH, "xslt", "wl2fo.xslt"))))

normalize_tmplt = xfrm_factory.newTemplates(StreamSource(\
        File(os.path.join(RUNTIME_PATH, "xslt", "normalize.xslt"))))


def process_file(filename):

    base, ext = os.path.splitext(filename)
    print "Transforming %s (%s)... " % (base, os.path.abspath(filename)) ,

    source = File(filename)

    if not source.canRead():
        print "can't read source. :("
        return

    dest = File(base + '.pdf')
    dest_stream = FileOutputStream(dest)
    agent = fop_factory.newFOUserAgent()

    # configure user agent & factory
    fop = fop_factory.newFop(MimeConstants.MIME_PDF, agent, dest_stream)

    # stylesheets
    normalize_xfrm = xfrm_factory.newTransformerHandler(normalize_tmplt)
    wl2fo_xfrm = xfrm_factory.newTransformerHandler(wl2fo_tmplt)
    normalize_xfrm.setResult(SAXResult(wl2fo_xfrm))
    wl2fo_xfrm.setResult(SAXResult(fop.getDefaultHandler()))

    # transform
    filtered = ByteArrayOutputStream()

    # pre-fetch and prepare
    with open(filename, 'rb') as input_file:
        for line in input_file:
            if line.endswith('/\n'):
                filtered.write(line[:-2] + '<br />\n')
            else:
                filtered.write(line)

    source = ByteArrayInputStream(filtered.toByteArray())

    xfrm = xfrm_factory.newTransformer()
    try:
        xfrm.transform(StreamSource(source), SAXResult(normalize_xfrm));
    except (XPathException, ValidationException), exc:
        print "exception: %s" % exc
    else:
        print "done."
    finally:
        dest_stream.close()
        # print some stuff for debuging
        pass

def print_usage():
    print """
Usage: book2pdf.py file [file...]"""

if __name__ == '__main__':
    print "WLML To PDF converter. Copyright © Łukasz Rekucki under GPLv3 License."

    if len(sys.argv) == 1:
        print_usage()
    else:
        for filename in sys.argv[1:]:
            process_file(filename)
