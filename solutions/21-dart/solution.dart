void partOne() {
  var p1Pos = 4;
  var p2Pos = 2;
  var p1Score = 0;
  var p2Score = 0;
  
  var i = 1;
  var turnsCount = 0;

  bool p1Turn = true;
 
  while(true) {
    if(p1Score >= 1000) {
      print(turnsCount * p2Score);
      break;
    }

    if(p2Score >= 1000) {
      print(turnsCount * p1Score);
      break;
    }
    
    var sum = i;
    if(++i > 100) i = 1;
    sum += i;
    if(++i > 100) i = 1;
    sum += i;
    
    if(p1Turn) {
      p1Pos += sum;
      p1Pos = p1Pos % 10;
      if(p1Pos == 0) p1Pos = 10;
      p1Score += p1Pos;
    } else {
      p2Pos += sum;
      p2Pos = p2Pos % 10;
      if(p2Pos == 0) p2Pos = 10;
      p2Score += p2Pos;
    }
    
    if(++i > 100) i = 1;
    
    turnsCount += 3;
    
    p1Turn = !p1Turn;
  }
}

var p1WinCount = 0;
var p2WinCount = 0;

var cache = List.generate(2, (_) => List.generate(15, (_) => List.generate(15, (_) => List.generate(25, (_) => List.generate(25, (_) => -1)))));

void playTurn(isP1Turn, p1Pos, p2Pos, p1Score, p2Score) {
  // print("P1, $p1Pos");
  // print(p2Pos);
  if(p1Score >= 21) {
    ++p1WinCount;
    cache[0][p1Pos][p2Pos][p1Score][p2Score] = 1;
    return;
  }

  if(p2Score >= 21) {
    ++p2WinCount;
    cache[1][p1Pos][p2Pos][p1Score][p2Score] = 1;
    return;
  }

  for(var a = 1; a < 4; ++a) {
    for(var b = 1; b < 4; ++b) {
      for(var c = 1; c < 4; ++c) {
        if(isP1Turn) {
          var tPos = (p1Pos + a + b + c - 1) % 10 + 1;
          var tScore = p1Score + tPos;
          if(tScore >= 21) {
            ++p1WinCount;
            cache[0][p1Pos][p2Pos][p1Score][p2Score] = 1;
          } else if(cache[0][tPos][p2Pos][tScore][p2Score] != -1) {
            p1WinCount += cache[0][tPos][p2Pos][tScore][p2Score];
          } else {
            var current = p1WinCount;
            playTurn(false, tPos, p2Pos, tScore, p2Score);
            cache[0][tPos][p2Pos][tScore][p2Score] = p1WinCount - current;  
          }
        } else {
          var tPos = (p2Pos + a + b + c - 1) % 10 + 1;
          var tScore = p2Score + tPos;
          if(tScore >= 21) {
            ++p2WinCount;
            cache[1][p1Pos][p2Pos][p1Score][p2Score] = 1;
          } else if(cache[1][p1Pos][tPos][p1Score][tScore] != -1) {
            p2WinCount += cache[1][p1Pos][tPos][p1Score][tScore];
          } else {
            var current = p2WinCount;
            playTurn(true, p1Pos, tPos, p1Score, tScore);
            cache[1][p1Pos][tPos][p1Score][tPos] = p2WinCount - current;
          }
        }
      }
    }
  }
}

void partTwo() {
  playTurn(true, 4, 8, 0, 0);
  print("P1 Win Count: ${p1WinCount}");
  print("P2 Win Count: ${p2WinCount}");
}

void main() {
  // partOne();
  partTwo();
}
