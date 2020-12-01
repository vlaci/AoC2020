const USAGE: &str = "
Day 1: Report Repair

Usage: report <input-file>
       report --help

Options:
    -h, --help  Print this help.
";
use std::fs::File;
use std::io::prelude::*;
use std::io::BufReader;

use docopt::Docopt;
use itertools::Itertools;

fn main() {
    let args = Docopt::new(USAGE)
        .and_then(|d| d.parse())
        .unwrap_or_else(|e| e.exit());

    let input_file = args.get_str("<input-file>");
    report(input_file);
}

fn report(input_file: &str) {
    let file = File::open(input_file).expect("unable to open file");
    let inputs: Vec<usize> = BufReader::new(file)
        .lines()
        .map(|line| {
            line.expect("invalid file encoding")
                .parse()
                .expect("invalid integer literal")
        })
        .collect();

    let result = sum2020(&inputs, 2);
    println!("Part 1: the product is for: {}", result);

    let result = sum2020(&inputs, 3);
    println!(
        "Part 2: the product is: {}",
        result
    );
}

fn sum2020(coins: &[usize], count: usize) -> usize {
    itertools::repeat_n(coins, count)
        .multi_cartesian_product()
        .filter(|e| e.iter().fold(0, |acc, x| acc + *x) == 2020)
        .map(|e| e.iter().fold(1, |acc, x| acc * *x))
        .take(1)
        .nth(0)
        .expect("No such elements that sum to 2020")
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_sum() {
        /* For example, suppose your expense report contained the following:

               1721
               979
               366
               299
               675
               1456

           In this list, the two entries that sum to `2020` are `1721` and `299`.
           Multiplying them together produces `1721 * 299 = 514579`, so the correct
           answer is `514579`.
        */
        assert_eq!(sum2020(&[1721, 979, 366, 299, 675, 1456], 2), 514579);
        assert_eq!(sum2020(&[1721, 979, 366, 299, 675, 1456], 3), 241861950);
    }
}
