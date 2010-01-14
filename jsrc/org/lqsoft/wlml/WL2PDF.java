package org.lqsoft.wlml;

import java.io.*;

import javax.xml.transform.*;
import javax.xml.transform.sax.SAXResult;
import javax.xml.transform.sax.TransformerHandler;
import javax.xml.transform.stream.*; 
import javax.xml.transform.*;

import org.apache.fop.fo.ValidationException;

import net.sf.saxon.TransformerFactoryImpl;
import net.sf.saxon.trans.XPathException;

import org.apache.fop.apps.*;
import org.xml.sax.SAXException;

public class WL2PDF 
{
	
	private Templates wl2fo_tmplt;
	private Templates norm_tmplt;
	private FopFactory fop_factory;
	private TransformerFactoryImpl xfrm_factory;
	
	public WL2PDF(String homePath, String fopConfigPath) 
		throws TransformerConfigurationException, SAXException, IOException
	{		
		this.fop_factory = FopFactory.newInstance();
		this.fop_factory.setUserConfig(new File(fopConfigPath));
		
		this.xfrm_factory = new TransformerFactoryImpl();
				
		this.wl2fo_tmplt = xfrm_factory.newTemplates( new StreamSource(
				new File(homePath, "xslt/wl2fo.xslt") ) );
		
		this.norm_tmplt = xfrm_factory.newTemplates( new StreamSource(
				new File(homePath, "xslt/normalize.xslt") ) );	
	}
	
	public void process(InputStream ins, OutputStream outs) 
		throws FOPException, IOException, TransformerException 
	{
		FOUserAgent agent = this.fop_factory.newFOUserAgent();
	    Fop fop = this.fop_factory.newFop(MimeConstants.MIME_PDF, agent, outs);
	    
	    TransformerHandler normalize_xfrm = this.xfrm_factory.newTransformerHandler(this.norm_tmplt);
	    TransformerHandler wl2fo_xfrm = xfrm_factory.newTransformerHandler(wl2fo_tmplt);
	    normalize_xfrm.setResult(new SAXResult(wl2fo_xfrm));
	    wl2fo_xfrm.setResult(new SAXResult(fop.getDefaultHandler()));
	    
	    ByteArrayOutputStream filtered = new ByteArrayOutputStream();
	    
	    BufferedReader text_input = new BufferedReader( new InputStreamReader(ins) );
	    String line = null;

	    while( (line = text_input.readLine()) != null ) 
	    {
	    	if( line.endsWith("/") ) {
	    		filtered.write(line.substring(0, line.length()-1).getBytes());
	    		filtered.write("<br />\n".getBytes());
	    	}
	    	else {
	    		filtered.write(line.getBytes());
	    		filtered.write("\n".getBytes());
	    	}
	    }	    		

	    ins = new ByteArrayInputStream(filtered.toByteArray());	    
	    Transformer xfrm = xfrm_factory.newTransformer();	    
	    xfrm.transform( new StreamSource(ins), new SAXResult(normalize_xfrm));		
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) 
	{
		System.out.println("WLML To PDF converter. Copyright © Łukasz Rekucki under GPLv3 License.");
		
		File file = new File(args[1]);
		String filename = file.getName();
		String[] base_and_ext = filename.split("\\.", -1);
		File output = new File(file.getParent(), base_and_ext[0] + ".pdf");
		
		System.out.printf("%s -> %s\n", filename, output.getPath());
					
		try 
		{			
			WL2PDF app = new WL2PDF(".", args[0]);
			InputStream _if = new FileInputStream(file);
			OutputStream _of = new FileOutputStream(output);
			
			app.process(_if, _of);
			
			_of.close();
			_if.close();
			System.out.print("Success");
		}
		catch(Exception e) {
			e.printStackTrace();
		}			
	}

}
