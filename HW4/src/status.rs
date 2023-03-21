use ferris_says::say;
use std::io::{stderr, BufWriter};

pub fn init() {
    let stderr = stderr();
    let message = String::from("Optimzing...");
    let width = message.chars().count();
    let mut writer = BufWriter::new(stderr.lock());
    say(message.as_bytes(), width, &mut writer).unwrap();
}
