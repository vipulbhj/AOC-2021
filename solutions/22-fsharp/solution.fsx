let LOWER_BOUND  = -50
let HIGHER_BOUND = 50

let valid_range (x:int) (y:int) =  not (x > HIGHER_BOUND || y < LOWER_BOUND);;

let transform_line (l: string) = 
  let res = l.Split ' '
  let action = res.[0]
  let cuboid = res.[1].Split ',' 
                |> Array.map (fun x -> 
                    let r = ((x.Split '=').[1]).Split '.'
                    (r.[0] |> int |> max LOWER_BOUND, r.[2] |> int |> min HIGHER_BOUND)
                  )
  (action, cuboid)

let process_line acc (command, [| (x1, x2); (y1, y2); (z1, z2) |]) = 
  let pts = [for x in x1 .. x2 do for y in y1 .. y2 do for z in z1 .. z2 -> (x, y, z)]
  let local_set = Set.ofSeq pts
  if command = "on" then Set.union acc local_set else Set.difference acc local_set

let lines = System.IO.File.ReadAllLines(@"./input.txt") 
            |> Array.map transform_line

let part_one lines = 
  let res_set = lines |> Array.fold (fun acc line -> process_line acc line) Set.empty
  printfn "%A" res_set.Count


part_one lines
