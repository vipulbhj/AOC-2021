val WIDTH = 100
val DEPTH = 100

(* Take O(n) *)
fun member_of (x, xs) = List.exists (fn i => i = x) xs

fun add_to_lst (x, xs) = if member_of(x, xs) then xs else x::xs

fun combine_lst (xs, ys) = List.foldl (fn (x, acc) => add_to_lst(x, ys)) ys xs

fun is_smallest (org_val, other_vals) = Bool.not (List.exists (fn i => i <= org_val) other_vals)

fun remove_duplicates [] = []
  | remove_duplicates (x::xs) = x::remove_duplicates(List.filter (fn y => y <> x) xs)

fun get_valid_index_mapping num = 
    let val base     = num div WIDTH
        val v_lst    = [num + WIDTH, num - WIDTH]
        val h_lst    = [num + 1, num - 1]
        val f_v_lst  = List.filter (fn n => n >= 0 andalso n < WIDTH * DEPTH) v_lst
        val f_h_lst  = List.filter (fn n => (n div WIDTH) = base) h_lst
        val f_lst    = f_v_lst@f_h_lst
    in (num, f_lst)
end

fun read_lines filename =
    let val file = TextIO.openIn filename
        val fileContent = TextIO.inputAll file
        val _ = TextIO.closeIn file
    in String.tokens (fn c => c = #"\n") fileContent
end

fun get_input () = 
    let val lines = read_lines "input.txt"
        val lines_chr_lst = map explode lines
        val mapped_inp = List.concat (map (fn chr_lst => map (fn c => valOf (Int.fromString (Char.toString c))) chr_lst) lines_chr_lst)
    in mapped_inp
end

fun find_low_points (inp_lst, (x, xs)) =
    let val org_val    = List.nth(inp_lst, x)
        val other_vals = map (fn i => List.nth(inp_lst, i)) xs
    in is_smallest (org_val, other_vals)
end

fun part_one () = 
    let val file_input    = get_input ()
        val idx_mapping   = List.tabulate(WIDTH * DEPTH, get_valid_index_mapping)
        val f_idx_mapping = List.filter (fn p => find_low_points(file_input, p)) idx_mapping
    in List.foldl (fn ((i, _), acc) => List.nth(file_input, i) + acc + 1) 0 f_idx_mapping
end

fun calc_basin(inp_lst, idx, seen_idxes) =
    let val mapping        = get_valid_index_mapping idx
        val idx_mappings   = #2(mapping)
        val f_idx_mappings = List.filter (fn i => List.nth(inp_lst, i) <> 9 andalso Bool.not(member_of(i, seen_idxes))) idx_mappings
        val f_len          = List.length(f_idx_mappings)
    in if f_len = 0
        then add_to_lst (idx, seen_idxes) 
        else calc_basin_helper(inp_lst, idx, seen_idxes, f_idx_mappings)
end
and
calc_basin_helper (inp_lst, idx, seen_idxes, next_idxes) =
    let val updated_seen_idxes = add_to_lst (idx, seen_idxes)
        val edge_values        = apply_in_order (inp_lst, updated_seen_idxes, next_idxes)
    in edge_values
end
and apply_in_order (inp_lst, seen_idxes, [])      = seen_idxes
  | apply_in_order (inp_lst, seen_idxes, (x::xs)) = 
    let val seen_idxes_for_branch = calc_basin(inp_lst, x, seen_idxes)
    in apply_in_order (inp_lst, combine_lst(seen_idxes, seen_idxes_for_branch), xs)
end

fun calc_part_two_res (a::b::c::_) = a * b * c

fun part_two () = 
    let val file_input          = get_input ()
        val idx_mapping         = List.tabulate(WIDTH * DEPTH, get_valid_index_mapping)
        val low_points          = List.filter (fn p => find_low_points(file_input, p)) idx_mapping
        val f_low_point_indexes = List.map (fn (idx, _) => idx) low_points
        val low_point_density   = List.map (fn i => List.length(remove_duplicates (calc_basin(file_input, i, [])))) f_low_point_indexes
        val sorted_lst          = ListMergeSort.sort (fn (a,b) => b - a >= 0) low_point_density
    in calc_part_two_res(sorted_lst)
end

