const USAGE: &str = "
Day 3: Toboggan Trajectory

Usage: trajectory <input-file>
       trajectory --help

Options:
    -h, --help  Print this help.
";
use std::collections::HashSet;

use docopt::Docopt;

fn main() {
    let args = Docopt::new(USAGE)
        .and_then(|d| d.parse())
        .unwrap_or_else(|e| e.exit());

    let input_file = args.get_str("<input-file>");
    trajectory(input_file);
}

fn trajectory(input_file: &str) {
    let strmap = std::fs::read_to_string(input_file).expect("unable to open file");

    let map = Map::parse(&strmap);
    let result = map.counttrees((3, 1));
    println!("The count of trees is: {}", result);

    let slopes = [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)];

    let result: usize = slopes.iter().map(|s| map.counttrees(*s)).product();
    println!("The product of all the sloes is: {}", result);
}

#[derive(Debug)]
struct Map {
    map: HashSet<(usize, usize)>,
    size: (usize, usize),
}

impl Map {
    fn parse(strmap: &str) -> Self {
        let map: HashSet<_> = strmap
            .lines()
            .enumerate()
            .flat_map(|(y, line)| {
                line.chars()
                    .enumerate()
                    .filter(|(_, c)| *c == '#')
                    .map(move |(x, _)| (x, y))
            })
            .collect();

        let size = strmap
            .lines()
            .enumerate()
            .map(|(h, l)| (l.len(), h + 1))
            .last()
            .unwrap();
        Map { map, size }
    }

    fn counttrees(&self, slope: (usize, usize)) -> usize {
        let mut trees = 0;
        let mut pos = (0, 0);

        while pos.1 < self.size.1 {
            pos.0 = (pos.0 + slope.0) % self.size.0;
            pos.1 += slope.1;
            if self.map.contains(&pos) {
                trees += 1;
            }
        }

        trees
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_parse() {
        let map = "..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#";
        let map = Map::parse(map);

        assert_eq!(map.counttrees((3, 1)), 7);
    }
}
