let split_rows input_text = String.split_on_char '\n' input_text

type safe = Safe | Unsafe | Undefined
type lDiff = Ascending | Descending | Undefined

let filter_level row idx = List.filteri (fun i _ -> i != idx) row

let split_levels row =
  String.trim row |> String.split_on_char ' '
  |> List.filter_map (fun e -> int_of_string_opt e)

let rec count_safe res i =
  match res with
  | [] -> i
  | a :: rest when a = Safe -> count_safe rest (i + 1)
  | _ :: rest -> count_safe rest i

let check_diff_safe = function
  | _, Undefined -> Unsafe
  | Ascending, Ascending | Descending, Descending | Undefined, _ -> Safe
  | Descending, Ascending | Ascending, Descending -> Unsafe

(** Check safety of row *)
let rec check_safe levels diff safe =
  match safe with
  | Safe | Undefined -> check_distance levels diff safe
  | Unsafe -> Unsafe

and check_distance levels diff safe =
  match levels with
  | [] | _ :: [] -> safe
  | a :: b :: rest -> (
      match (a, b) with
      | a, b when Int.abs (b - a) > 3 -> Unsafe
      | _ -> check_direction (a :: b :: rest) diff safe)

and check_direction levels diff safe =
  match levels with
  | [] | _ :: [] -> safe
  | a :: b :: rest -> (
      match (a, b) with
      | a, b when a > b ->
          check_safe (b :: rest) Descending (check_diff_safe (diff, Descending))
      | a, b when a < b ->
          check_safe (b :: rest) Ascending (check_diff_safe (diff, Ascending))
      | a, b when a = b -> Unsafe
      | _ -> safe)

(** Check how many unsafe cases for part 2 *)
let rec check_unsafe_cases levels idx count =
  let filtered_levels = filter_level levels idx in
  let safe = check_safe filtered_levels Undefined Undefined in
  if idx <= List.length levels - 1 then
    match safe with
    | Safe -> check_unsafe_cases levels (idx + 1) (count + 1)
    | Unsafe | Undefined -> check_unsafe_cases levels (idx + 1) count
  else if count != 1 then Safe
  else Unsafe

let part1 (input_text : string) : string =
  let results =
    List.map
      (fun lvls -> check_safe (split_levels lvls) Undefined Undefined)
      (split_rows input_text)
  in
  count_safe results 0 |> string_of_int

let part2 (input_text : string) : string =
  let results =
    List.filter_map
      (fun lvls ->
        let levels = split_levels lvls in
        if List.length levels > 0 then
          let safety = check_safe levels Undefined Undefined in
          match safety with
          | Safe -> Some Safe
          | Unsafe -> Some (check_unsafe_cases levels 0 1)
          | Undefined -> None
        else None)
      (split_rows input_text)
  in
  count_safe results 0 |> string_of_int
