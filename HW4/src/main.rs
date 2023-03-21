use ferris_says::say;
use std::io::{stdout, stderr, BufWriter};
use std::env;
use std::fs::File;
use std::io::BufReader;
use std::io::BufRead;
use nalgebra::{DMatrix};
fn main() {
    
    greeting();

    let args: Vec<String> = env::args().collect();
    let p1_p_path: &String = &args[1];
    let p1_pi_path: &String = &args[2];
    let p1_x0_path: &String = &args[3];

    let p1_p_matrix = matrix_from_file(p1_p_path);
    let p1_pi_matrix = matrix_from_file(p1_pi_path);
    let p1_x0_matrix = matrix_from_file(p1_x0_path);
    eprintln!("p:\n{}", p1_p_matrix);
    eprintln!("pi:\n{}", p1_pi_matrix);
    eprintln!("x0:\n{}", p1_x0_matrix);
}







fn greeting() {
    let stderr = stderr();
    let message = String::from("Optimzing...");
    let width = message.chars().count();
    let mut writer = BufWriter::new(stderr.lock());
    say(message.as_bytes(), width, &mut writer).unwrap();
}


fn matrix_from_file(path: &String) -> DMatrix<f64> {
    let file = File::open(path).expect("file not found");
    let mut reader = BufReader::new(file).lines().skip(2);
    let dims:String = match reader.next() {
        None => panic!("Check file format"),
        Some(line) => line.unwrap(),
    };
    let dims_parts: Vec<&str> = dims.split(' ').collect();
    let rows = dims_parts[0].parse::<usize>().unwrap();
    let cols = dims_parts[1].parse::<usize>().unwrap();
    let mut raw_data: Vec<f64> = Vec::with_capacity(rows * cols);
    for line in reader {
        raw_data.push(line.unwrap().parse::<f64>().unwrap());
    }
    let matrix: DMatrix<f64> = DMatrix::from_vec(rows, cols, raw_data);
    return matrix;
}

