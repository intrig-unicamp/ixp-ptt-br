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

public class Density {
    private static final String OUTPUT_FILE = "ix-ptt-br/Density/201510/";
    private static final String INPUT_PATH = "../../IXP-PTT-BR/201510/PTT_PATH_Filtered/";
    private static long startTime;
    private static final String[] lstIXP = { "BA", "BEL", "CAS", "CE", "CPV",
            "CXJ", "DF", "GYN", "LAJ", "LDA", "MAO", "MG", "MGF", "NAT", "PE",
            "PR", "RJ", "RS", "SC", "SJC", "SJP", "SP", "VIX" };

    public static void main(String[] args) throws URISyntaxException,
            IOException {

        try {
            System.setOut(new PrintStream(new FileOutputStream(OUTPUT_FILE
                    + "LogDensity" + ".txt")));
            System.out.println("Start");

            Density();

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

    private static void Density() throws Exception {
        // TODO Auto-generated method stub
        FileInputStream fstream = null;
        String strLine;

        List<String> lstFinal = null;
        String[] lstSubAS = null;

        BufferedReader br = null;
        HashMap<String, List<String>> lstDensity = new HashMap<String, List<String>>();

        for (String strIXP : lstIXP) {
            System.out.println("\t" + strIXP);
            List<String> lstPTTConnect = AS_Connect_PTT(strIXP);

            lstFinal = new ArrayList<String>();

            try {
                fstream = new FileInputStream(INPUT_PATH + "PTT_Path_" + strIXP
                        + ".txt");

                br = new BufferedReader(new InputStreamReader(fstream));

                while ((strLine = br.readLine()) != null) {
                    lstSubAS = strLine.split(" ");
                    if (lstSubAS.length > 1) {
                        for (int i = 0; i < lstSubAS.length - 1; i++) {
                            String strAS1 = lstSubAS[i];
                            String strAS2 = lstSubAS[i + 1];
                            if (!strAS1.equals(strAS2)
                                    && lstPTTConnect.contains(strAS1)
                                    && lstPTTConnect.contains(strAS2)
                                    && !lstFinal
                                            .contains(strAS1 + " " + strAS2)
                                    && !lstFinal
                                            .contains(strAS2 + " " + strAS1)) {
                                lstFinal.add(strAS1 + " " + strAS2);
                            }
                        }
                    }
                }

            } catch (Exception e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }

            System.out.println("Existent Peers: " + lstFinal.size());
            System.out.println(lstFinal);

            String strExistentPeers = Integer.toString(lstFinal.size());
            String strPossiblePeers = Integer
                    .toString((lstPTTConnect.size() * (lstPTTConnect.size() - 1)) / 2);

            lstDensity.put(strIXP,
                    Arrays.asList(strExistentPeers, strPossiblePeers));
        }

        CsvFileWriter csv = new CsvFileWriter();
        csv.writeCsvFile(OUTPUT_FILE + "Density.csv", lstDensity);

        br.close();
        fstream.close();

        long endTime = System.currentTimeMillis();
        System.out.println("Execution time: " + (endTime - startTime) + "ms");

        System.out.println("End function: " + new Object() {
        }.getClass().getEnclosingMethod().getName() + " " + getData());
    }

    private static List<String> AS_Connect_PTT(String strAuxIXP) {
        System.out.println("start function: " + new Object() {
        }.getClass().getEnclosingMethod().getName() + " " + getData());
        startTime = System.currentTimeMillis();
        // //////////////////////////////////////////////////////////////////////////////

        FileInputStream fstream = null;
        String strLine, strAS;
        List<String> lstAS = null;

        try {
            fstream = new FileInputStream(INPUT_PATH + "PTT_Path_" + strAuxIXP
                    + ".txt");

        } catch (FileNotFoundException e1) {
            // TODO Auto-generated catch block
            e1.printStackTrace();
        }
        BufferedReader br = new BufferedReader(new InputStreamReader(fstream));

        lstAS = new ArrayList<String>();
        try {
            while ((strLine = br.readLine()) != null) {
                String[] lstSubAS = strLine.split(" ");
                strAS = lstSubAS[0];

                if (!lstAS.contains(strAS)) {
                    lstAS.add(strAS);
                    System.out.println(strAuxIXP + ": " + strAS);

                }
            }
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

        // Close the input stream
        try {
            br.close();
            fstream.close();
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

        System.out.println(lstAS.size());

        return lstAS;
    }

    private static String getData() {
        SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date now = new Date();
        return "[" + sdfDate.format(now) + "] ";
    }
}