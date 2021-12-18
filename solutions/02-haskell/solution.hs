part_one :: [[String]] -> Int
part_one = (\(pos, depth) -> pos * depth) . foldl (\acc x -> part_one_helper x acc) (0, 0)
            where
              part_one_helper (command:val:_) (pos, depth) =
                let int_val = (read :: String -> Int) val 
                in case command of
                  "forward" -> (pos + int_val, depth)
                  "down" -> (pos, depth + int_val)
                  "up" -> (pos, depth - int_val)


part_two :: [[String]] -> Int
part_two = (\(pos, depth, aim) -> pos * depth) . foldl (\acc x -> part_two_helper x acc) (0, 0, 0)
            where
              part_two_helper (command:val:_) (pos, depth, aim) =
                let int_val = (read :: String -> Int) val 
                in case command of
                  "forward" -> (pos + int_val, depth + int_val * aim, aim)
                  "down" -> (pos, depth, aim + int_val)
                  "up" -> (pos, depth, aim - int_val)

solve = (\xs -> (show $ part_one xs) ++ "\n" ++ (show $ part_two xs) ++ "\n") . map words . lines

main = interact solve
