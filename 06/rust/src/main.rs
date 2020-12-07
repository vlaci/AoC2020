const USAGE: &str = "
Day 3: Day 6: Custom Customs

Usage: customs <input-file>
       customs --help

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
    customs(input_file);
}

fn customs(input_file: &str) {
    let forms = std::fs::read_to_string(input_file).expect("unable to open file");
    let forms = Forms::parse(&forms);

    let result = forms.count_any_yes();

    println!("The sum of unique question answered with yes: {}", result);
    let result = forms.count_all_yes();
    println!("The sum of questions where everyone ansered yes {}", result);
}

#[derive(Debug)]
struct Forms {
    forms: Vec<Vec<String>>,
}

impl Forms {
    fn parse(s: &str) -> Self {
        let forms: Vec<_> = s
            .split("\n\n")
            .map(|frm| frm.lines().map(|l| l.to_string()).collect::<Vec<String>>())
            .collect();
        Forms { forms }
    }

    fn count_any_yes(&self) -> usize {
        self.forms
            .iter()
            .map(|frm| {
                frm.iter()
                    .flat_map(|l| l.chars())
                    .collect::<HashSet<char>>()
                    .len()
            })
            .sum()
    }

    fn count_all_yes(&self) -> usize {
        self.forms
            .iter()
            .map(|frm| -> usize {
                frm.iter()
                    .fold(frm[0].chars().collect::<HashSet<_>>(), |chars, l| {
                        &chars & &l.chars().collect()
                    })
                    .len()
            })
            .sum()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_form_parsing() {
        let forms = "abc

a
b
c

ab
ac

a
a
a
a

b
";
        let frm = Forms::parse(forms);

        assert_eq!(frm.count_any_yes(), 11);
        assert_eq!(frm.count_all_yes(), 6);
    }
}
