let mul_regex =
  let open Re in
  seq
    [
      str "mul("; repn digit 1 (Some 3); str ","; repn digit 1 (Some 3); str ")";
    ]
  |> compile

let do_dont_regex =
  let open Re in
  alt
    [
      str "do()";
      str "don't()";
      seq
        [
          str "mul(";
          repn digit 1 (Some 3);
          str ",";
          repn digit 1 (Some 3);
          str ")";
        ];
    ]
  |> compile

let extract_ints_regex =
  let open Re in
  seq [ repn digit 1 (Some 3) ] |> compile

let extract_ints match_string =
  let matches = Re.all extract_ints_regex match_string in
  let list =
    List.map
      (fun e -> int_of_string (List.nth (Array.to_list (Re.Group.all e)) 0))
      matches
  in
  match list with a :: b :: _ -> (a, b) | _ -> (0, 0)

let rec calc_part_2 matches running multiply =
  match matches with
  | a :: rest ->
      check_match_state
        (List.nth (Array.to_list (Re.Group.all a)) 0)
        running multiply rest
  | [] -> running

and check_match_state reg_match running multiply rest =
  match reg_match with
  | "don't()" -> calc_part_2 rest running false
  | "do()" -> calc_part_2 rest running true
  | _ ->
      if multiply = true then
        calc_part_2 rest
          (running
          +
          let a, b = extract_ints reg_match in
          a * b)
          multiply
      else calc_part_2 rest running multiply

let rec sum l = match l with [] -> 0 | h :: t -> h + sum t

let part1 (input_text : string) : string =
  let matches = Re.all mul_regex input_text in
  let res =
    List.map
      (fun e ->
        let a, b = extract_ints (List.nth (Array.to_list (Re.Group.all e)) 0) in
        a * b)
      matches
  in
  string_of_int (sum res)

let part2 (input_text : string) : string =
  calc_part_2 (Re.all do_dont_regex input_text) 0 true |> string_of_int
