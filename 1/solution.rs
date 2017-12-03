use std::env;
use std::fs::File;
use std::io::prelude::*;

fn main() {
    let args: Vec<String> = env::args().collect();
    let filename = &args[1];

    let mut f = File::open(filename).expect("file not found");

    let mut captcha = String::new();
    f.read_to_string(&mut captcha)
        .expect("could not read file");

    println!("Part 1: {}", solve_part_one(&captcha));
    println!("Part 2: {}", solve_part_two(&captcha));
}

/// Return the sum of all elements equal to their immediate successor.
fn solve_part_one(captcha: &str) -> u32 {
    let mut chars: Vec<char> = captcha.chars().collect();
    let len = chars.len();

    // Append the first element onto the end of the CAPTCHA.
    if len > 0 {
        let first_digit = chars[0];
        chars[len - 1] = first_digit;
    } else {
        panic!("empty CAPTCHA");
    }

    chars
        .windows(2)
        .fold(0u32, |sum, window| if window[0] == window[1] {
            sum + window[0].to_digit(10).unwrap()
        } else {
            sum
        })
}

/// Return the sum of all elements equal to the element halfway around
/// the captcha.
/// Assumes the captcha has an even number of digits.
fn solve_part_two(captcha: &str) -> u32 {
    let mut chars: Vec<char> = captcha.chars().collect();

    // Compute length and skip for vector without the last
    // element, the newline character.
    let len = chars.len() - 1;
    let skip = len / 2;

    chars.truncate(len);

    chars
        .iter()
        .enumerate()
        .filter(|&(i, &digit)| digit == chars[(i + skip) % len])
        .fold(0u32, |sum, (_, digit)| sum + digit.to_digit(10).unwrap())
}
