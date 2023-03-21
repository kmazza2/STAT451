use std::fs::File;
use std::io::BufReader;
use std::io::BufRead;
use nalgebra::{DMatrix};

pub fn matrix_from_file(path: &String) -> DMatrix<f64> {
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