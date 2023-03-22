use std::env;
mod matrix_rdr;
mod optim;
mod status;
mod test_utils;

fn main() {
    status::init();

    let args: Vec<String> = env::args().collect();
    let p1_p_path: &String = &args[1];
    let p1_pi_path: &String = &args[2];
    let p1_x0_path: &String = &args[3];

    let p1_p_matrix = matrix_rdr::matrix_from_file(p1_p_path);
    let p1_pi_matrix = matrix_rdr::matrix_from_file(p1_pi_path);
    let p1_x0_matrix = matrix_rdr::matrix_from_file(p1_x0_path);
}
