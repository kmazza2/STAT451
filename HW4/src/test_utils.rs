use crate::optim;
use nalgebra::DMatrix;

fn f(x: &DMatrix<f64>) -> f64 {
    return f64::powf(x[(0, 0)], 2.0) + f64::powf(x[(0, 1)], 2.0) + f64::powf(x[(0, 2)], 2.0);
}

fn grad(x: &DMatrix<f64>) -> DMatrix<f64> {
    return DMatrix::from_vec(
        3,
        1,
        vec![
            2.0 * x[(0, 0)],
            2.0 * x[(1, 0)],
            3.0 * f64::powf(x[(2, 0)], 2.0),
        ],
    );
}

fn hess(x: &DMatrix<f64>) -> DMatrix<f64> {
    return DMatrix::from_vec(
        3,
        3,
        vec![2.0, 0.0, 0.0, 0.0, 2.0, 0.0, 0.0, 0.0, 6.0 * x[(2, 0)]],
    );
}

#[test]
fn simple_newton_w_equal() {
    let x0: DMatrix<f64> = DMatrix::from_vec(3, 1, vec![1.3, 1.3, -1.3]);
    let A: DMatrix<f64> =
        DMatrix::from_vec(3, 3, vec![-1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0, 0.0]);
    let b: DMatrix<f64> = DMatrix::repeat(3, 1, 0.0);
    let result: optim::OptimResult = optim::newton_w_equal(f, grad, hess, x0, A, b, 0.00001, 100);
    let expected: DMatrix<f64> = DMatrix::from_vec(3, 1, vec![0.0, 0.0, 0.0]);
    assert_eq!(expected, result.x);
}

#[test]
fn grad_at_prime() {
    let x: DMatrix<f64> = DMatrix::from_vec(3, 1, vec![3.0, 5.0, 7.0]);
    let result = grad(&x);
    let expected: DMatrix<f64> =
        DMatrix::from_vec(3, 1, vec![2.0 * 3.0, 2.0 * 5.0, 3.0 * f64::powf(7.0, 2.0)]);
    assert_eq!(expected, result);
}

#[test]
fn hess_at_prime() {
    let x: DMatrix<f64> = DMatrix::from_vec(3, 1, vec![3.0, 5.0, 7.0]);
    let result = hess(&x);
    let expected: DMatrix<f64> =
        DMatrix::from_vec(3, 3, vec![2.0, 0.0, 0.0, 0.0, 2.0, 0.0, 0.0, 0.0, 42.0]);
    assert_eq!(expected, result);
}
