import java.io.File;
import java.io.BufferedReader;

val String.magnitude get() = generateSequence(this) { s ->
    s.replace("""\[(\d+),(\d+)]""".toRegex()) { match ->
        val (left, right) = match.groupValues.drop(1).map { it.toInt() }
        (3 * left + 2 * right).toString()
    }
}.first { """\d+""".toRegex() matches it }.toInt()

fun explode (str: String): String {
  var res = "";
  var depth = 0;
  var i = 0;
  val len = str.length;

  while (i < len) {
    val c = str[i];
    if (c == '[') {
      depth += 1;
      if(depth > 4) {
        i += 1;
        var fStr = "";
        while(i < len) {
          val cccc = str[i];
          if(cccc.isDigit()) fStr += cccc;
          else break;
          i += 1;
        }
        // Skipping comma
        i += 1;
        var sStr = "";
        while(i < len) {
          val ccccc = str[i];
          if(ccccc.isDigit()) sStr += ccccc;
          else break;
          i += 1;
        }

        val f = fStr.toInt();
        val s = sStr.toInt();


        // Check left for number
        var j = i - 2 - fStr.length - sStr.length;
        while (j >= 0) {
          val cc = str[j];
          if(cc.isDigit()) {
            var jStr = "" + cc;
            j -= 1;

            while(j >= 0) {
              val z = str[j];
              if(z.isDigit()) jStr = z + jStr;
              else break;
              j -= 1;
            }

            val prev = str.substring(0, j + 1);
            val num = f + jStr.toInt();
            val next = str.substring(j + 1 + jStr.length, i - 2 - fStr.length - sStr.length);
            res = "${prev}${num}${next}";
            break;
          }
          j -= 1;
        }

        res += "0";

        // Check right for number
        var k = i + 1;
        while (k < len) {
          val ccc = str[k];
          if(ccc.isDigit()) {
            var kStr = "" + ccc;
            k += 1;
            while(k < len) {
              val cccccc = str[k];
              if(cccccc.isDigit()) kStr += cccccc;
              else break;
              k += 1;
            }
            val num = s + kStr.toInt();
            val next = str.substring(k, len);
            res += "${num}${next}";
            break;
          } else {
            res += ccc;
          }
          k += 1;
        }

        return res;
      } 
    } else if(c == ']') {  
      depth -= 1; 
    }
    res += c;
    i += 1;
  }
  return res;
}

fun split(str: String): String {
  val REGEX = "\\d{2,}".toRegex();
  val match = REGEX.find(str);
  if(match?.value != null) {
    val start = match.range.start;
    val end = match.range.last;

    val prev = str.substring(0, start);
    val num = match.value.toInt() / 2.0;
    val floor = Math.floor(num).toInt();
    val ciel = Math.ceil(num).toInt();
    val next = str.substring(end + 1, str.length);
    return "${prev}[${floor},${ciel}]${next}"
  } else {
    return str;
  }
}

fun s_addition(str: String): String {
  val explodedStr = explode(str);
  if(str.length != explodedStr.length) return s_addition(explodedStr);

  val splitStr = split(str);
  if(str.length != splitStr.length) return s_addition(splitStr);

  return str;
}


fun part_one() {
  val input = File("./input.txt").bufferedReader().readLines();

  val len = input.size;
  var i = 1;
  var res = input[0];
  while(i < len) {
    val next = input[i];
    val str = "[${res},${next}]";
    res = s_addition(str)
    i += 1;
  }

  println(res.magnitude);
}

fun part_two() {
  val input = File("./input.txt").bufferedReader().readLines();
  val len = input.size;
  var i = 0;

  var magnitudes = mutableListOf<Int>()

  while(i < len) {
    var res = input[i];
    var j = 0;
    while(j < len) {
      if(j == i) {
        j += 1;
      } else {
        val next = input[j];
        val str = "[${res},${next}]";
        val ans = s_addition(str);
        magnitudes.add(ans.magnitude);
        j += 1;
      }
    }
    i += 1;
  }
  println(magnitudes.maxOrNull());
}

fun main() {
  part_one();
  part_two();
}
