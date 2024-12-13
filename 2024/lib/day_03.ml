let mul_regex =
  let open Re in
  seq
    [
      str "mul("; repn digit 1 (Some 3); str ","; repn digit 1 (Some 3); str ")";
    ]
  |> compile

let extract_ints_regex =
  let open Re in
  seq [ repn digit 1 (Some 3) ] |> compile

let find_matches regex str = Re.all regex str

let extract_ints match_string =
  let matches = find_matches extract_ints_regex match_string in
  let list =
    List.map
      (fun e -> int_of_string (List.nth (Array.to_list (Re.Group.all e)) 0))
      matches
  in
  match list with a :: b :: _ -> (a, b) | _ -> (0, 0)

let rec sum l = match l with [] -> 0 | h :: t -> h + sum t

let part1 (input_text : string) : string =
  let matches = find_matches mul_regex input_text in
  let res =
    List.map
      (fun e ->
        let a, b = extract_ints (List.nth (Array.to_list (Re.Group.all e)) 0) in
        a * b)
      matches
  in
  string_of_int (sum res)

let part2 (input_text : string) : string = input_text
