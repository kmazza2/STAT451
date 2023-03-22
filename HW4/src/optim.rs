use nalgebra::DMatrix;
use simple_error::SimpleError;

pub struct OptimResult {
    pub x: DMatrix<f64>,
    pub iter: usize,
    pub converged: bool,
}

pub fn newton_w_equal(
    f: fn(&DMatrix<f64>) -> f64,
    grad: fn(&DMatrix<f64>) -> DMatrix<f64>,
    hess: fn(&DMatrix<f64>) -> DMatrix<f64>,
    x0: DMatrix<f64>,
    A: DMatrix<f64>,
    b: DMatrix<f64>,
    eps: f64,
    max_iter: usize,
) -> OptimResult {
    let mut x = x0.clone();
    let init_resid = &A * &x - b;
    if init_resid.norm() > 0.0001 {
        panic!("Invalid initial guess");
    }
    let r: DMatrix<f64> = DMatrix::from_vec(0, 0, vec![]);
    let b: DMatrix<f64> = DMatrix::repeat(A.shape().0, 1, 0.0);
    for iter in 0..max_iter {
        let step = match min_quad_w_equal(&hess(&x), &grad(&x), &r, &A, &b) {
            Err(e) => {
                break;
            }
            Ok(result) => result,
        };
        let dec = newton_dec(&step, &A);
        if f64::powf(dec, 2.0) / 2.0 < eps {
            return OptimResult {
                x: x,
                iter: iter,
                converged: true,
            };
        }
        x += step;
    }
    return OptimResult {
        x: x,
        iter: max_iter,
        converged: false,
    };
}

pub fn newton_dec(h: &DMatrix<f64>, A: &DMatrix<f64>) -> f64 {
    if h.shape().0 != A.shape().0 || A.shape().1 != h.shape().0 {
        panic!("Arguments unconformable");
    }
    let prod = h.transpose() * A * h;
    return prod[(0, 0)];
}

pub fn min_quad_w_equal(
    P: &DMatrix<f64>,
    q: &DMatrix<f64>,
    r: &DMatrix<f64>,
    A: &DMatrix<f64>,
    b: &DMatrix<f64>,
) -> Result<DMatrix<f64>, SimpleError> {
    let P_dims = P.shape();
    let q_dims = q.shape();
    let A_dims = A.shape();
    let b_dims = b.shape();
    if P_dims.0 + A_dims.0 != q_dims.0 + b_dims.0 || q_dims.1 != 1 || b_dims.1 != 1 {
        panic!("Arguments unconformable");
    } else {
        let lhs: DMatrix<f64> = min_quad_w_equal_lhs(P, A);
        let rhs: DMatrix<f64> = min_quad_w_equal_rhs(q, b);
        let decomp = &lhs.lu();
        let sol = match decomp.solve(&rhs) {
            None => return Err(SimpleError::new("Could not compute LU decomp")),
            Some(decomp) => decomp,
        };
        let result = min_quad_w_equal_result(sol, A_dims.1);
        return Ok(result);
    }
}

fn min_quad_w_equal_lhs(P: &DMatrix<f64>, A: &DMatrix<f64>) -> DMatrix<f64> {
    let P_dims = P.shape();
    let A_dims = A.shape();
    let mut lhs: DMatrix<f64> = DMatrix::<f64>::zeros(P_dims.0 + A_dims.0, P_dims.1 + A_dims.0);
    for i in 0..P.nrows() {
        for j in 0..P.ncols() {
            lhs[(i, j)] = P[(i, j)];
        }
    }
    for i in 0..A.nrows() {
        for j in 0..A.ncols() {
            lhs[(P.nrows() + i, j)] = A[(i, j)];
            lhs[(j, P.ncols() + i)] = A[(i, j)];
        }
    }
    return lhs;
}

fn min_quad_w_equal_rhs(q: &DMatrix<f64>, b: &DMatrix<f64>) -> DMatrix<f64> {
    let mut rhs: DMatrix<f64> = DMatrix::<f64>::zeros(q.nrows() + b.nrows(), 1);
    for i in 0..q.nrows() {
        rhs[(i, 0)] = -q[(i, 0)];
    }
    for i in 0..b.nrows() {
        rhs[(q.nrows() + i, 0)] = b[(i, 0)];
    }
    return rhs;
}

fn min_quad_w_equal_result(sol: DMatrix<f64>, nrows: usize) -> DMatrix<f64> {
    let mut result: DMatrix<f64> = DMatrix::<f64>::zeros(nrows, 1);
    for i in 0..nrows {
        result[(i, 0)] = sol[(i, 0)];
    }
    return result;
}

#[test]
fn dec() {
    let h: DMatrix<f64> = DMatrix::from_vec(2, 1, vec![1.0, 2.0]);
    let A: DMatrix<f64> = DMatrix::from_vec(2, 2, vec![3.0, 5.0, 4.0, 6.0]);
    let result = newton_dec(&h, &A);
    let expected = 45.0;
    assert_eq!(expected, result);
}

#[test]
fn min_univar_quad_w_equal() {
    let P: DMatrix<f64> = DMatrix::from_vec(1, 1, vec![2.0]);
    let q: DMatrix<f64> = DMatrix::from_vec(1, 1, vec![-8.0]);
    let r: DMatrix<f64> = DMatrix::from_vec(1, 1, vec![16.0]);
    let A: DMatrix<f64> = DMatrix::from_vec(1, 1, vec![3.0]);
    let b: DMatrix<f64> = DMatrix::from_vec(1, 1, vec![5.0]);
    let result = min_quad_w_equal(&P, &q, &r, &A, &b);
    let x = result.unwrap()[(0, 0)];
    assert_eq!(x, 5.0 / 3.0);
}

#[test]
fn min_multivar_quad_w_equal() {
    let P: DMatrix<f64> = DMatrix::from_vec(2, 2, vec![2.0, 0.0, 0.0, 2.0]);
    let q: DMatrix<f64> = DMatrix::from_vec(2, 1, vec![0.0, 0.0]);
    let r: DMatrix<f64> = DMatrix::from_vec(1, 1, vec![0.0]);
    let A: DMatrix<f64> = DMatrix::from_vec(1, 2, vec![-1.0, 1.0]);
    let b: DMatrix<f64> = DMatrix::from_vec(1, 1, vec![1.0]);
    let expected: DMatrix<f64> = DMatrix::from_vec(2, 1, vec![-0.5, 0.5]);
    let result = min_quad_w_equal(&P, &q, &r, &A, &b).unwrap();
    assert_eq!(expected, result);
}

#[test]
fn lhs() {
    let P: DMatrix<f64> = DMatrix::from_vec(2, 2, vec![1.0, 2.0, 3.0, 4.0]);
    let A: DMatrix<f64> = DMatrix::from_vec(3, 2, vec![5.0, 6.0, 7.0, 8.0, 9.0, 10.0]);
    let expected: DMatrix<f64> = DMatrix::from_vec(
        5,
        5,
        vec![
            1.0, 2.0, 5.0, 6.0, 7.0, 3.0, 4.0, 8.0, 9.0, 10.0, 5.0, 8.0, 0.0, 0.0, 0.0, 6.0, 9.0,
            0.0, 0.0, 0.0, 7.0, 10.0, 0.0, 0.0, 0.0,
        ],
    );
    let result = min_quad_w_equal_lhs(&P, &A);
    assert_eq!(expected, result);
}

#[test]
fn rhs() {
    let q: DMatrix<f64> = DMatrix::from_vec(3, 1, vec![13.0, 11.0, 7.0]);
    let b: DMatrix<f64> = DMatrix::from_vec(5, 1, vec![5.0, 17.0, 19.0, 23.0, 29.0]);
    let expected: DMatrix<f64> =
        DMatrix::from_vec(8, 1, vec![-13.0, -11.0, -7.0, 5.0, 17.0, 19.0, 23.0, 29.0]);
    let result = min_quad_w_equal_rhs(&q, &b);
    assert_eq!(expected, result);
}
