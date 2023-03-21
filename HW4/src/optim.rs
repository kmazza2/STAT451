use nalgebra::{DMatrix};
use simple_error::SimpleError;

pub fn min_quad_w_equal(
    P: &DMatrix<f64>,
    q: &DMatrix<f64>,
    r: &DMatrix<f64>,
    A: &DMatrix<f64>,
    b: &DMatrix<f64>
)-> Result<DMatrix<f64>, SimpleError> {
    let P_dims = P.shape();
    let q_dims = q.shape();
    let A_dims = A.shape();
    let b_dims = b.shape();
    if P_dims.0 + A_dims.0 != q_dims.0 + b_dims.0 || q_dims.1 != 1 || b_dims.1 != 1 {
        return Err(SimpleError::new("Arguments unconformable"));
    } else {
        let mut lhs: DMatrix<f64> = DMatrix::<f64>::zeros(
            P_dims.0 + A_dims.0,
            P_dims.1  + A_dims.0
        );
        for i in 0..P.nrows() {
            for j in 0..P.ncols() {
                lhs[(i,j)] = P[(i,j)];
            }
        }
        for i in 0..A.nrows() {
            for j in 0..A.ncols() {
                lhs[(P.nrows() + i, j)] = A[(i,j)]; 
                lhs[(j, P.ncols() + i)] = A[(i,j)];
            }
        }
        let mut rhs: DMatrix<f64> = DMatrix::<f64>::zeros(P_dims.0 + A_dims.0, 1);
        for i in 0..q.nrows() {
            rhs[(i,0)] = -q[(i,0)];
        }
        for i in 0..b.nrows() {
            rhs[(q.nrows() + i, 0)] = b[(i,0)];
        }
        eprintln!("{}", rhs);
        unimplemented!();
        return Ok(lhs);
    }

}

#[test]
fn min_univar_quad_w_equal() {
    let P: DMatrix<f64> = DMatrix::from_vec(1, 1, vec![2.0]);
    let q: DMatrix<f64> = DMatrix::from_vec(1, 1, vec![-8.0]);
    let r: DMatrix<f64> = DMatrix::from_vec(1, 1, vec![16.0]);
    let A: DMatrix<f64> = DMatrix::from_vec(1, 1, vec![3.0]);
    let b: DMatrix<f64> = DMatrix::from_vec(1, 1, vec![5.0]);
    let result = min_quad_w_equal(&P, &q, &r, &A, &b);
    let x = result.unwrap()[(0,0)];
    assert_eq!(x, 3.0/5.0);

}