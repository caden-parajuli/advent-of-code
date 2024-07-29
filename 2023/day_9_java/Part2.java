import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;

class Part2 {
    public static final String FILENAME = "input";
    public static ArrayList<String> lines = new ArrayList<String>();

    public static void main(String[] args) {
        read_input(FILENAME);

        Integer total = 0;
        for (String line : lines) {
            total += total_line(line);
        }
        System.out.print("Final total: ");
        System.out.println(total);
    }

    public static void read_input(String filename) {
        try (FileReader file = new FileReader(filename);
                BufferedReader reader = new BufferedReader(file)) {
            String line;
            while ((line = reader.readLine()) != null) {
                lines.add(line);
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static Integer total_line(String line) {
        ArrayList<ArrayList<Integer>> seqs = new ArrayList<ArrayList<Integer>>();

        ArrayList<Integer> first = new ArrayList<Integer>();
        for (String numstr : line.split("\\s+")) {
            first.add(Integer.parseInt(numstr));
        }
        seqs.add(first);

        int seq_i = 0;
        while (seq_i < seqs.size()) {
            ArrayList<Integer> seq = seqs.get(seq_i);
            ArrayList<Integer> next_seq = new ArrayList<Integer>();

            int prev = seq.getFirst();
            int j = 1;
            while (j < seq.size()) {
                next_seq.add(seq.get(j) - prev);
                prev = seq.get(j);
                ++j;
            }
            seqs.add(next_seq);

            if (all_zero(next_seq)) {
                break;
            }

            ++seq_i;
        }

        return predict(seqs);
    }

    public static Integer predict(ArrayList<ArrayList<Integer>> seqs) {
        Integer seqs_i = seqs.size() - 2;
        Integer prediction = 0;
        while (seqs_i >= 0) {
            prediction = seqs.get(seqs_i).getFirst() - prediction;
            --seqs_i;
        }

        return prediction;
    }

    public static boolean all_zero(ArrayList<Integer> seq) {
        for (Integer num : seq) {
            if (num != 0) {
                return false;
            }
        }
        return true;
    }
}
