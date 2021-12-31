import Array._;

@main def solution() = {
  // val inpStr = "target area: x=20..30, y=-10..-5";
  val inpStr = "target area: x=137..171, y=-98..-73";

  val Array(xStr, yStr) = inpStr.replaceFirst("target area: ", "").split(", "); // ["x=20..30", "y=-10..-5"]
  val Array(xStart, xEnd) = xStr.replaceFirst("x=", "").split("""\.\.""").map(i => i.toInt);
  val Array(yStart, yEnd) = yStr.replaceFirst("y=", "").split("""\.\.""").map(i => i.toInt);

  var top = 0;
  var bottom = 0;
  var yJumpSize = 0;
  if(yStart >= 0 && yEnd >= 0) {
    top = yEnd;
    bottom = yStart;
    yJumpSize = yEnd - yStart;
  } else if(yStart >= 0 && yEnd < 0) {
    top = yStart;
    bottom = yEnd;
    yJumpSize = yStart + yEnd.abs;
  } else if(yStart < 0 && yEnd >= 0) {
    top = yEnd;
    bottom = yStart;
    yJumpSize = yStart + yEnd.abs;
  } else {
    top = yEnd;
    bottom = yStart;
    yJumpSize = yStart.abs - yEnd.abs;
  }

  val maxY = top.abs + yJumpSize - 1;
  println("Part 1: " + calc_sum(maxY));

  var possible_external_pair_count = 0;
  for(num <- 1 to ((xEnd / 2) + 1)) {
    if(is_valid_x_point(num, xStart, xEnd)) {
      for (i <- yStart to maxY) {
        if(is_vel_valid(num, i, top, bottom, xStart, xEnd)) possible_external_pair_count += 1;
      }
    }
  }
  
  val zeroStepDepth = xEnd - xStart + 1;

  val ans_part_two = possible_external_pair_count + zeroStepDepth * (yJumpSize + 1);
  
  println("Part 2: " + ans_part_two);
}

def is_valid_x_point(n: Int, start: Int, end: Int): Boolean = {      
  var f = 0;
  for(i <- 1 to n) {
    f = f + i;
    if(f >= start && f <= end) {
      return true;
    }
  }
  return false;
}


def is_vel_valid(initX: Int, initY: Int, top: Int, bottom: Int, xStart: Int, xEnd: Int): Boolean = {
  var x = 0;
  var y = 0;
  var dx = initX;
  var dy = initY;

  while(y >= bottom && x <= xEnd) {
    x += dx;
    y += dy;

    if(y >= bottom && y <= top && x >= xStart && x <= xEnd) return true;

    if(dx != 0) dx -= 1;

    dy -= 1;
  }

  return false;
}

def calc_sum(n: Int): Int = {      
  var f = 0;
  for(i <- 1 to n) {
    f = f + i;
  }

  return f;  
}
