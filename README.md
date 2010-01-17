WL2PDF is an XSL-FO based converter from WLML (format 
used by [wolnelektury.pl][1] to print-friendly PDFs).
                 
    
License
-------
    
    Copyright © 2009,2010 Łukasz Rekucki

    WL2PDF is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    WL2PDF is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with WL2PDF.  If not, see <http://www.gnu.org/licenses/>.
    
    
Requirements
------------
      
  * Fairly new Java Runtime (1.5+)
    
  * [Apache FOP][2] 
    (at least version 0.95, trunk is recommended)
          
  * [Saxon][3] for XSLT2
          
  * Hyphenation is done via FOP, so read a section on it in their docs.
           
  * Some unicode-capable font, like DejaVu. 
           
    
Configuration
-------------
    
  1. Compile FOP if needed.
  2. Generate font metrics (refer to FOP Documentation on that)
  3. Make a "fop-config.xml" out of the supplied example and place it in this directory.    
     
Running
-------
   
With Jython:
    
    jython wl2pdf <list_of_files_to_convert>
      
With Java:
    
    java org.lqsoft.wlml.WL2PDF <path_to_config> <file_to_convert>
    
Rember to place FOP, it's libraries and Saxon under your classpath.

  [1]: http://wolnelektury.pl/
  [2]: http://xmlgraphics.apache.org/fop/index.html
  [3]: http://www.saxonica.com/index.html  