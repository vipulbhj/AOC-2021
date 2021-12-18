import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;
import java.util.ArrayList;

class Solution {
  private static void partOne(ArrayList<String> lines) {
    final int BIT_SIZE = 12;
    int[] bits = new int[BIT_SIZE];
    String gamma = "", epsilon = "";
    // set all bits to zero.
    for(int i = 0; i < BIT_SIZE; ++i) bits[i] = 0;
    for(int i = 0; i < lines.size(); ++i) {
      String line = lines.get(i);
      for(int j = 0; j < BIT_SIZE; ++j) {
        char bit = line.charAt(j);
        if(bit == '1') {
          bits[j] += 1;
        } else {
          bits[j] -= 1;
        }
      }
    }

    for(int j = 0; j < BIT_SIZE; ++j) {
      int bitVal = bits[j];
      if(bitVal >= 0) {
        gamma += "1";
        epsilon += "0";
      } else {
        gamma += "0";
        epsilon += "1";
      }
    }

    System.out.println(Integer.parseInt(gamma, 2) * Integer.parseInt(epsilon, 2));
  }

  private static String partTwoO2(ArrayList<String> lines, int idx) {
    int size = lines.size();
    if(size == 1) return lines.get(0);

    int count = 0;
    for(int i = 0; i < size; ++i) {
      String line = lines.get(i);
      if(line.charAt(idx) == '1') {
        ++count;
      } else {
        --count;
      }
    }

    ArrayList<String> newLines = new ArrayList<String>();
    if(count >= 0) {
      for(int i = 0; i < size; ++i) {
        String line = lines.get(i);
        if(line.charAt(idx) == '1') {
          newLines.add(line);
        }
      }
    } else {
      for(int i = 0; i < size; ++i) {
        String line = lines.get(i);
        if(line.charAt(idx) == '0') {
          newLines.add(line);
        }
      }
    }

    return partTwoO2(newLines, ++idx);
  }

  private static String partTwoCo2(ArrayList<String> lines, int idx) {
    int size = lines.size();
    if(size == 1) return lines.get(0);

    int count = 0;
    for(int i = 0; i < size; ++i) {
      String line = lines.get(i);
      if(line.charAt(idx) == '1') {
        ++count;
      } else {
        --count;
      }
    }

    ArrayList<String> newLines = new ArrayList<String>();
    if(count >= 0) {
      for(int i = 0; i < size; ++i) {
        String line = lines.get(i);
        if(line.charAt(idx) == '0') {
          newLines.add(line);
        }
      }
    } else {
      for(int i = 0; i < size; ++i) {
        String line = lines.get(i);
        if(line.charAt(idx) == '1') {
          newLines.add(line);
        }
      }
    }

    return partTwoCo2(newLines, ++idx);
  }

  private static void partTwo(ArrayList<String> lines) {
    int index = 0;
    String o2 = partTwoO2(lines, 0);
    String co2 = partTwoCo2(lines, 0);

    System.out.println(Integer.parseInt(o2, 2) * Integer.parseInt(co2, 2));
  }

  public static void main(String[] args) {
    try {
      File f = new File("input.txt");
      Scanner myReader = new Scanner(f);
      ArrayList<String> lines = new ArrayList<String>();
      while (myReader.hasNextLine()) {
        String line = myReader.nextLine();
        lines.add(line.trim());
      }
      myReader.close();

      Solution.partOne(lines);
      Solution.partTwo(lines);
    } catch (FileNotFoundException e) {
      System.out.println("An error occurred.");
      e.printStackTrace();
    }
    
  }
}
