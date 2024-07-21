let filename = "input"
let positions = [ (0, 1); (0, -1); (1, 0); (-1, 0); (1, 1); (1, -1); (-1, 1); (-1, -1) ]
let gears = Hashtbl.create 256

(** Returns a reversed array of the lines of the file.
 *  Note that reversing does not affect the final answer.
 *)
let load_data filename =
  let ic = open_in filename in
  let rec read_to_list l =
    try
      let line = input_line ic in
      read_to_list @@ (line :: l)
    with
    | End_of_file ->
        close_in ic;
        l
    | e ->
        close_in_noerr ic;
        raise e
  in
  let rev_line_list = read_to_list [] in
  Array.of_list rev_line_list

let is_gear ch =
  match ch with
  | '*' -> true
  | _ -> false

let is_num ch =
  match ch with
  | '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9' -> true
  | _ -> false

let clip i upper_bound =
  if i <= 0 then
    0
  else if i >= upper_bound then
    upper_bound - 1
  else
    i

let rec add_to_gears gear_list new_num =
  match gear_list with
  | [] -> ()
  | (gear_line, gear_char) :: tail ->
      (match Hashtbl.find_opt gears (gear_line, gear_char) with
      | None -> Hashtbl.add gears (gear_line, gear_char) [ new_num ]
      | Some gear_nums -> Hashtbl.replace gears (gear_line, gear_char) (new_num :: gear_nums));
      add_to_gears tail new_num

let process_line lines line_num =
  let line = lines.(line_num) in
  let pos = ref 0 in
  let num = ref 0 in
  let curr_gears = ref [] in
  while !pos < String.length line do
    if is_num line.[!pos] then (
      num := (10 * !num) + (Char.code line.[!pos] - Char.code '0');
      let rec do_pos pos_list =
        match pos_list with
        | [] -> ()
        | (line_off, char_off) :: tail ->
            let gear_line = clip (line_num + line_off) (Array.length lines) in
            let gear_char = clip (!pos + char_off) (String.length line) in
            if is_gear lines.(gear_line).[gear_char] then
              if not @@ List.mem (gear_line, gear_char) !curr_gears then
                curr_gears := (gear_line, gear_char) :: !curr_gears;
            do_pos tail
      in
      do_pos positions
    ) else (
      add_to_gears !curr_gears !num;
      num := 0;
      curr_gears := []
    );
    pos := !pos + 1
  done;
  (* Catch end of line values *)
  add_to_gears !curr_gears !num

let get_gear_ratios gear_table =
  Hashtbl.fold
    (fun gear_pos nums total ->
      total
      +
      if List.length nums = 2 then
        List.hd nums * (List.hd @@ List.tl nums)
      else
        0)
    gear_table 0

let () =
  let input = load_data filename in
  let rec do_line lines line_num =
    match line_num with
    | 0 -> process_line lines 0
    | _ ->
        process_line lines line_num;
        do_line lines (line_num - 1)
  in
  do_line input (Array.length input - 1);
  print_endline @@ "\nFinal total: " ^ string_of_int @@ get_gear_ratios gears
