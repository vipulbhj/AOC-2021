#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include<stdbool.h>

#define LINE_COUNT 90
#define LINE_WIDTH 120

// #define LINE_COUNT 10
// #define LINE_WIDTH 30

void insertionSort(long long arr[], long long int n) {
  long long int i, key, j;
  for (i = 1; i < n; i++) {
    key = arr[i];
    j = i - 1;

    while (j >= 0 && arr[j] > key) {
      arr[j + 1] = arr[j];
      j = j - 1;
    }

    arr[j + 1] = key;
  }
}

int find_chr_score(char c) {
  if(c == ')') {
    return 3;
  } else if(c == ']') {
    return 57;
  } else if(c == '}') {
    return 1197;
  } else if(c == '>') {
    return 25137;
  } else {
    printf("ERROR: find_chr_score for %c", c);
    exit(1);
  }
}

int find_chr_points(char c) {
  if(c == ')') {
    return 1;
  } else if(c == ']') {
    return 2;
  } else if(c == '}') {
    return 3;
  } else if(c == '>') {
    return 4;
  } else {
    printf("ERROR: find_chr_points for %c", c);
    exit(1);
  }
}

char get_expected_chr(char c) {
  if(c == '(') {
    return ')';
  } else if(c == '[') {
    return ']';
  } else if(c == '{') {
    return '}';
  } else if(c == '<') {
    return '>';
  } else {
    printf("ERROR: get_expected_chr for %c", c);
    exit(1);
  }
}

long long int calc_stack_score(char STACK[LINE_WIDTH], int size) {
  long long int score = 0;

  for(int i = size - 1; i >= 0; --i) {
    char closingChr = get_expected_chr(STACK[i]);
    score = score * 5 + find_chr_points(closingChr); 
  }

  return score;
}

void part_one(char lines[LINE_COUNT][LINE_WIDTH]) {
  int score = 0;

  for(int i = 0; i < LINE_COUNT; ++i) {
    char STACK[LINE_WIDTH] = { '\0' };
    int stackIdx = 0;
    for(int j = 0; j < strlen(lines[i]); ++j) {
      char c = lines[i][j];
      if(c == '(' || c == '[' || c == '{' || c == '<') {
        STACK[stackIdx++] = c;
      } else if (c == ')' || c == ']' || c == '}' || c == '>') {
        char expectedChr = get_expected_chr(STACK[stackIdx - 1]);
        if(c != expectedChr) {
          score += find_chr_score(c);
          break;
        } else if(c == expectedChr) {
          --stackIdx;
        }
      }
    }
  }

  printf("Part 1: %d\n", score);
}

void part_two(char lines[LINE_COUNT][LINE_WIDTH]) {
  long long int ALL_SCORES[LINE_COUNT] = { 0 };
  int all_score_idx = 0;

  for(int i = 0; i < LINE_COUNT; ++i) {
    bool corrupt = false;
    char STACK[LINE_WIDTH] = { '\0' };
    int stackIdx = 0;
    for(int j = 0; j < strlen(lines[i]); ++j) {
      char c = lines[i][j];
      if(c == '(' || c == '[' || c == '{' || c == '<') {
        STACK[stackIdx++] = c;
      } else if (c == ')' || c == ']' || c == '}' || c == '>') {
        char expectedChr = get_expected_chr(STACK[stackIdx - 1]);
        if(c != expectedChr) {
          corrupt = true;
          break;
        } else if(c == expectedChr) {
          STACK[--stackIdx] = '\0';
        }
      }
    }

    if(!corrupt) {
      ALL_SCORES[all_score_idx++] = calc_stack_score(STACK, strlen(STACK));
    } 
  }
  
  insertionSort(ALL_SCORES, all_score_idx);
  
  printf("Part 2: %lld\n", ALL_SCORES[all_score_idx / 2]);
}

int main(int argc, char* argv[]) {
  char lines[LINE_COUNT][LINE_WIDTH];

  char* fileName = "input.txt";
  FILE* fptr = fopen(fileName, "r"); 

  if(!fptr) {
    printf("\n Unable to open : %s ", fileName);
    return -1;
  }

  int count = 0;
  while (fscanf(fptr, "%[^\n]", lines[count]) && count < LINE_COUNT) {
    if (fgetc(fptr) == EOF) break; 
    ++count;
  }

  part_one(lines);
  part_two(lines);

  fclose(fptr);
}
