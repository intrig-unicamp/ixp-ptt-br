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
import java.util.Scanner;

import test.CsvFileWriter;

public class AS_PTT_Prepend {	
	private static final String OUTPUT_FILE = "ix-ptt-br/AS_Prepend_Members_PTT/20141208/";
	private static final String INPUT_PATH = "E:\\PTTMetro\\20141208\\PTT_PATH_FIltered\\";

	private static long startTime;
	private static final String[] lstIXP = { "BA", "BEL", "CAS", "CE", "CPV",
			"CXJ", "DF", "GYN", "LAJ", "LDA", "MAO", "MG", "MGF", "NAT", "PE",
			"PR", "RJ", "RS", "SC", "SCA", "SJC", "SJP", "SP", "VIX" };
	private static final String ASN_PTT_LG = "20121";
	private static final String ASN_PTT_RS = "26121";

	public static void main(String[] args) throws Exception {

		try {
			System.setOut(new PrintStream(new FileOutputStream(OUTPUT_FILE
					+ "LogAS_PTT_Prepend" + ".txt")));
			System.out.println("Start");

			AS_PTT_Prepend();

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

	private static void AS_PTT_Prepend() throws Exception {
		// TODO Auto-generated method stub
		FileInputStream fstream = null;
		String strLine;
		BufferedReader br = null;

		List<String> lstAS = TotalAS_PTT();

		HashMap<String, List<String>> lstMatrix = new HashMap<String, List<String>>();
		for (String strAS : lstAS)
			lstMatrix.put(strAS, new ArrayList<String>(Arrays.asList("0")));

		for (String strIXP : lstIXP) {

			System.out.println("\t" + strIXP);

			try {
				fstream = new FileInputStream(INPUT_PATH + "PTT_Path_" + strIXP
						+ ".txt");

				br = new BufferedReader(new InputStreamReader(fstream));

				while ((strLine = br.readLine()) != null) {
					String[] lstSubAS = strLine.split(" ");
					if (!lstSubAS[lstSubAS.length - 1].equals(ASN_PTT_LG)
							&& !lstSubAS[lstSubAS.length - 1]
									.equals(ASN_PTT_RS)) {
						if (lstSubAS.length > 1) {
							for (int i = 0; i < lstSubAS.length - 1; i++) {
								if (lstSubAS[i].equals(lstSubAS[i + 1])
										&& lstMatrix.containsKey(lstSubAS[i]))
									lstMatrix.put(
											lstSubAS[i],
											new ArrayList<String>(Arrays
													.asList("1")));
							}
						}
					}
				}

			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		CsvFileWriter csv = new CsvFileWriter();
		csv.writeCsvFile(OUTPUT_FILE + "AS_PTT_Prepend.csv", lstMatrix);

		br.close();
		fstream.close();

		long endTime = System.currentTimeMillis();
		System.out.println("Execution time: " + (endTime - startTime) + "ms");

		System.out.println("End function: " + new Object() {
		}.getClass().getEnclosingMethod().getName() + " " + getData());
	}

	private static List<String> TotalAS_PTT() throws Exception {
		FileInputStream fstream = null;
		BufferedReader br = null;
		String strLine;
		List<String> lstAS = new ArrayList<String>();
		Scanner scanner = null;

		for (String strIXP : lstIXP) {

			System.out.println("\t" + strIXP);

			fstream = new FileInputStream(INPUT_PATH + "Ptt_Path_" + strIXP
					+ ".txt");
			br = new BufferedReader(new InputStreamReader(fstream));

			while ((strLine = br.readLine()) != null) {
				String[] lstSubAS = strLine.split(" ");
				if (!lstAS.contains(lstSubAS[0])
						&& !lstSubAS[lstSubAS.length - 1].equals(ASN_PTT_LG)
						&& !lstSubAS[lstSubAS.length - 1].equals(ASN_PTT_RS)) {
					lstAS.add(lstSubAS[0]);
				}
			}
		}
		// Close the input stream
		br.close();
		fstream.close();

		return lstAS;
	}

	private static String getData() {
		SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date now = new Date();
		return "[" + sdfDate.format(now) + "] ";
	}
}
