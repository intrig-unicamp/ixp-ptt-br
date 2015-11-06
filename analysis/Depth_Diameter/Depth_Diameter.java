package ixp_ptt_br;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.net.URISyntaxException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import test.CsvFileWriter;

public class Depth_Diameter {
	private static final String OUTPUT_FILE = "ix-ptt-br/Depth/201510/";
	private static final String INPUT_PATH = "../../IXP-PTT-BR/201510/PTT_PATH_Filtered/";

	private static long startTime;
	private static final String[] lstIXP = { "BA", "BEL", "CAS", "CE", "CPV",
        "CXJ", "DF", "GYN", "LAJ", "LDA", "MAO", "MG", "MGF", "NAT", "PE",
        "PR", "RJ", "RS", "SC", "SJC", "SJP", "SP", "VIX" };

	public static void main(String[] args) throws Exception {

		try {
			System.setOut(new PrintStream(new FileOutputStream(OUTPUT_FILE
					+ "LogDepth" + ".txt")));
			System.out.println("Start");

			Depth();

		} catch (Exception e) {
			// TODO Auto-generated catch block
			// System.out.println(e.getMessage());

			StringWriter writer = new StringWriter();
			PrintWriter printWriter = new PrintWriter(writer);
			e.printStackTrace(printWriter);
			printWriter.flush();

			System.out.println(writer.toString());

			long endTime = System.currentTimeMillis();
			System.out.println("Total execution time: " + (endTime - startTime)
					+ "ms");
		}

		System.out.println("End");
	}

	private static void Depth() throws Exception {
		// TODO Auto-generated method stub
		FileInputStream fstream = null;
		String strLine;
		List<String> lstAS = new ArrayList<String>();
		HashMap<Integer, Integer> lstDepth = null;
		BufferedReader br = null;

		for (String strIXP : lstIXP) {
			lstDepth = new HashMap<Integer, Integer>();

			System.out.println("\t" + strIXP);

			try {
				fstream = new FileInputStream(INPUT_PATH + "PTT_Path_" + strIXP
						+ ".txt");

				br = new BufferedReader(new InputStreamReader(fstream));

				while ((strLine = br.readLine()) != null) {
					String[] lstSubAS = strLine.split(" ");
					Integer intDepthAux = 1;
					if (lstSubAS.length > 1) {
						for (int i = 0; i < lstSubAS.length - 1; i++) {
							if (!lstSubAS[i].equals(lstSubAS[i + 1]))
								intDepthAux++;
						}
					}

					Integer intDepth = lstDepth.get(intDepthAux);
					lstDepth.put(intDepthAux, (intDepth == null) ? 1
							: intDepth + 1);
				}

			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			CsvFileWriter csv = new CsvFileWriter();
			csv.writeCsvFileInt(OUTPUT_FILE + "lg." + strIXP + ".ptt.br.csv",
					lstDepth);
		}

		br.close();
		fstream.close();

		long endTime = System.currentTimeMillis();
		System.out.println("Execution time: " + (endTime - startTime) + "ms");

		System.out.println("End function: " + new Object() {
		}.getClass().getEnclosingMethod().getName() + " " + getData());
	}

	private static String getData() {
		SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date now = new Date();
		return "[" + sdfDate.format(now) + "] ";
	}
}
