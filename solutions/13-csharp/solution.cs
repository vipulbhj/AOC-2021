using System;
using System.IO;
using System.Collections.Generic;

public class Solution {
  static void PartOne(int[,] sheet, List<string> cuts, int width, int height) {
    foreach(var cut in cuts) {
      string[] t = cut.Trim().Split("=");
      int num = int.Parse(t[1]);
      if(t[0] == "y") {
        for(int row = 1; row < (height - num); ++row) {
          int sourceRow = num + row;
          int targetRow = num - row;
          for(int col = 0; col < width; ++col) {
              sheet[targetRow, col] += sheet[sourceRow, col];
          }    
        }
        height = num;
      } else {
        for(int col = 1; col < (width - num); ++col) {
          int sourceCol = num + col;
          int targetCol = num - col;
          for(int row = 0; row < height; ++row) {
            sheet[row, targetCol] += sheet[row, sourceCol];
          }
        }
        width = num;
      }
      break;
    }

    int res = 0;
    for(int i = 0; i < height; ++i) {
      for(int j = 0; j < width; ++j) {
        if(sheet[i, j] > 0) {
          ++res;

          // System.Console.Write("#");
        } else {
          // System.Console.Write(".");
        }
      }
      // System.Console.WriteLine();
    }

    System.Console.WriteLine("Part 1: {0}", res);
  }

  static void PartTwo(int[,] sheet, List<string> cuts, int width, int height) {
    foreach(var cut in cuts) {
      string[] t = cut.Trim().Split("=");
      int num = int.Parse(t[1]);
      if(t[0] == "y") {
        for(int row = 1; row < (height - num); ++row) {
          int sourceRow = num + row;
          int targetRow = num - row;
          for(int col = 0; col < width; ++col) {
              sheet[targetRow, col] += sheet[sourceRow, col];
          }    
        }
        height = num;
      } else {
        for(int col = 1; col < (width - num); ++col) {
          int sourceCol = num + col;
          int targetCol = num - col;
          for(int row = 0; row < height; ++row) {
            sheet[row, targetCol] += sheet[row, sourceCol];
          }
        }
        width = num;
      }
    }

    System.Console.WriteLine("Part 2:");

    for(int i = 0; i < height; ++i) {
      for(int j = 0; j < width; ++j) {
        if(sheet[i, j] > 0) {
          System.Console.Write("#");
        } else {
          System.Console.Write(".");
        }
      }
      System.Console.WriteLine();
    }
  }

  public static void Main(string[] args) {
    int width = -1;
    int height = -1;
    int SIZE = 1500;

    string line;
    int[,] sheet = new int[SIZE, SIZE];
    List<string> SHEET_CUTS = new List<string>();

    StreamReader file = new StreamReader("input.txt");
    while((line = file.ReadLine()) != "") {
      int[] coords = Array.ConvertAll(line.Trim().Split(","), s => int.Parse(s));
      if(coords[0] > width) width = coords[0];
      if(coords[1] > height) height = coords[1];
      sheet[coords[1], coords[0]] = 1;
    }

    for(int i = 0; ; ++i) {
      line = file.ReadLine();
      if(line == null) break;
      string t = (line.Trim().Split(" "))[2];
      SHEET_CUTS.Add(t);
    }

    PartOne(sheet.Clone() as int[,], SHEET_CUTS, width + 1, height + 1);
    PartTwo(sheet.Clone() as int[,], SHEET_CUTS, width + 1, height + 1);
  }
}
