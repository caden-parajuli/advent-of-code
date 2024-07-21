let filename = "input"

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

let is_symbol ch =
  match ch with
  | '.' | '\n' | '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9' -> false
  | _ -> true

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

let process_line lines line_num =
  let line = lines.(line_num) in
  let total = ref 0 in
  let pos = ref 0 in
  let valid = ref false in
  let num = ref 0 in
  while !pos < String.length line do
    if is_num line.[!pos] then (
      (* print_char line.[!pos]; *)
      num := (10 * !num) + (Char.code line.[!pos] - Char.code '0');
      valid :=
        !valid
        (* Vertical Sides *)
        || is_symbol lines.(clip (line_num - 1) (Array.length lines)).[!pos]
        || is_symbol lines.(clip (line_num + 1) (Array.length lines)).[!pos]
        (* Horizontal Sides *)
        || is_symbol line.[clip (!pos - 1) (String.length line)]
        || is_symbol line.[clip (!pos + 1) (String.length line)]
        (* Diagonals *)
        || is_symbol lines.(clip (line_num - 1) (Array.length lines)).[clip (!pos - 1) (String.length line)]
        || is_symbol lines.(clip (line_num + 1) (Array.length lines)).[clip (!pos - 1) (String.length line)]
        || is_symbol lines.(clip (line_num - 1) (Array.length lines)).[clip (!pos + 1) (String.length line)]
        || is_symbol lines.(clip (line_num + 1) (Array.length lines)).[clip (!pos + 1) (String.length line)]
    ) else (
      if !valid then total := !total + !num;
      num := 0;
      valid := false
    );
    pos := !pos + 1
  done;
  (* Catch end of line values *)
  if !valid then total := !total + !num;
  !total


let () =
  let input = load_data filename in
  let rec do_line lines line_num total =
    (* print_endline @@ string_of_int total; *)
    match line_num with
    | 0 -> total + process_line lines 0
    | _ -> do_line lines (line_num - 1) (total + process_line lines line_num)
  in
  print_endline @@ "\nFinal total: " ^ string_of_int (do_line input (Array.length input - 1) 0)
