use std::io::Read;

fn part_one(tokens: Vec<&str>) {
   let mut res = 0;
   for n in 1..tokens.len() {
      let prev: i64 = tokens[n-1].parse().unwrap();
      let curr: i64 = tokens[n].parse().unwrap();

      if curr > prev { res += 1; }
   }

   println!("{}", res);
}

fn part_two(tokens: Vec<&str>) {
   let mut res = 0;
   for n in 3..tokens.len() {
      let prev: i64 = tokens[n-3].parse().unwrap();
      let curr: i64 = tokens[n].parse().unwrap();

      if curr > prev { res += 1; }
   }

   println!("{}", res);
}

fn main() {
   let mut file = std::fs::File::open("input.txt").unwrap();
   let mut contents = String::new();
   file.read_to_string(&mut contents).unwrap();
   let tokens:Vec<&str> = contents.trim().split("\n").collect();

   part_one(tokens.clone());
   part_two(tokens.clone());
}
