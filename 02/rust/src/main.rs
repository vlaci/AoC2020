const USAGE: &str = "
Day 2: Password Philosophy

Usage: password <input-file>
       password --help

Options:
    -h, --help  Print this help.
";
use std::fs::File;
use std::io::prelude::*;
use std::io::BufReader;

use docopt::Docopt;
use lazy_static::lazy_static;
use regex::Regex;

fn main() {
    let args = Docopt::new(USAGE)
        .and_then(|d| d.parse())
        .unwrap_or_else(|e| e.exit());

    let input_file = args.get_str("<input-file>");
    password(input_file);
}

fn password(input_file: &str) {
    let file = File::open(input_file).expect("unable to open file");
    let inputs: Vec<Policy> = BufReader::new(file)
        .lines()
        .map(|line| Policy::parse(&line.expect("invalid file encoding")))
        .collect();

    let result = inputs.iter().filter(|p| p.is_valid()).count();
    println!("The count of valid passwords is: {}", result);

    let result = inputs.iter().filter(|p| p.is_valid2()).count();
    println!(
        "The count of valid passwords is according to the new policy: {}",
        result
    );
}

#[derive(Debug, PartialEq)]
struct Policy {
    char: char,
    min: usize,
    max: usize,
    pwd: String,
}

lazy_static! {
    static ref PATTERN: Regex =
        Regex::new(r"(?P<min>\d+)-(?P<max>\d+) (?P<char>\w): (?P<pwd>\w+)").unwrap();
}

impl Policy {
    fn parse(line: &str) -> Self {
        let cap = PATTERN.captures(line).expect("Invalid policy");
        Policy {
            char: cap.name("char").unwrap().as_str().chars().next().unwrap(),
            min: cap
                .name("min")
                .unwrap()
                .as_str()
                .parse()
                .expect("min: not a number"),
            max: cap
                .name("max")
                .unwrap()
                .as_str()
                .parse()
                .expect("max: not a number"),
            pwd: cap.name("pwd").unwrap().as_str().to_string(),
        }
    }

    fn is_valid(&self) -> bool {
        let count = self.pwd.chars().filter(|c| *c == self.char).count();
        count >= self.min && count <= self.max
    }

    fn is_valid2(&self) -> bool {
        let chars: Vec<char> = self.pwd.chars().collect();
        chars[self.min - 1] == self.char && chars[self.max - 1] != self.char
            || chars[self.min - 1] != self.char && chars[self.max - 1] == self.char
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_parse() {
        /* 1-3 a: abcde
           1-3 b: cdefg
           2-9 c: ccccccccc
        */
        assert_eq!(
            Policy::parse("1-3 a: abcde"),
            Policy {
                char: 'a',
                min: 1,
                max: 3,
                pwd: "abcde".to_string()
            }
        );
        assert_eq!(
            Policy::parse("1-3 b: cdefg"),
            Policy {
                char: 'b',
                min: 1,
                max: 3,
                pwd: "cdefg".to_string()
            }
        );
        assert_eq!(
            Policy::parse("2-9 c: ccccccccc"),
            Policy {
                char: 'c',
                min: 2,
                max: 9,
                pwd: "ccccccccc".to_string()
            }
        );
    }

    #[test]
    fn test_policy() {
        assert_eq!(
            Policy {
                char: 'a',
                min: 1,
                max: 3,
                pwd: "abcde".to_string()
            }
            .is_valid(),
            true
        );
        assert_eq!(
            Policy {
                char: 'b',
                min: 1,
                max: 3,
                pwd: "cdefg".to_string()
            }
            .is_valid(),
            false
        );
        assert_eq!(
            Policy {
                char: 'c',
                min: 2,
                max: 9,
                pwd: "ccccccccc".to_string()
            }
            .is_valid(),
            true
        );
    }
    #[test]
    fn test_policy2() {
        assert_eq!(
            Policy {
                char: 'a',
                min: 1,
                max: 3,
                pwd: "abcde".to_string()
            }
            .is_valid2(),
            true
        );
        assert_eq!(
            Policy {
                char: 'b',
                min: 1,
                max: 3,
                pwd: "cdefg".to_string()
            }
            .is_valid2(),
            false
        );
        assert_eq!(
            Policy {
                char: 'c',
                min: 2,
                max: 9,
                pwd: "ccccccccc".to_string()
            }
            .is_valid2(),
            false
        );
    }
}
