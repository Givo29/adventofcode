let split_cols contents col =
  String.split_on_char '\n' contents
  |> List.filter (fun s -> s <> "")
  |> List.map (fun s ->
         int_of_string
           (List.nth
              (String.split_on_char ' ' s |> List.filter (fun s -> s <> ""))
              col))
  |> List.sort compare

let rec sum l = match l with [] -> 0 | h :: t -> h + sum t

let rec find_occurrances l e i =
  match l with
  | [] -> i
  | h :: t when h = e -> find_occurrances t e (i + 1)
  | _ :: t -> find_occurrances t e i

let part1 (input_text : string) : string =
  let left = split_cols input_text 0 in
  let right = split_cols input_text 1 in
  sum (List.map2 (fun i j -> Int.abs (i - j)) left right) |> string_of_int

let part2 (input_text : string) : string =
  let left = split_cols input_text 0 in
  let right = split_cols input_text 1 in
  sum (List.map (fun x -> x * find_occurrances right x 0) left) |> string_of_int
