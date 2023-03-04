#ifndef __UCS_POISS_D_H__
#define __UCS_POISS_D_H__

#include <gsl/gsl_vector.h>
#include <gsl/gsl_matrix.h>
#include <math.h>

void ll(gsl_vector *param, gsl_matrix *data, double *val)
{
	double n1 = gsl_matrix_get(data, 0, 1);
	double n2 = gsl_matrix_get(data, 1, 1);
	double a1 = gsl_vector_get(param, 0);
	double a2 = gsl_vector_get(param, 1);
	double b11 = gsl_matrix_get(data, 0, 2);
	double b12 = gsl_matrix_get(data, 0, 3);
	double b21 = gsl_matrix_get(data, 1, 2);
	double b22 = gsl_matrix_get(data, 1, 3);
	*val = n1 * log(a1 * b11 + a2 * b12) +
		n2 * log(a1 * b21 + a2 * b22) -
		a1 * (b11 + b21) -
		a2 * (b12 + b22);
}

void d1(gsl_vector *param, gsl_matrix *data, gsl_vector *val)
{
        double d1_1 = 0;
        double d1_2 = 0;
        double a1 = gsl_vector_get(param, 0);
        double a2 = gsl_vector_get(param, 1);
        for (int i = 0; i < data->size1; ++i) {
                double n = gsl_matrix_get(data, i, 1);
                double b1 = gsl_matrix_get(data, i, 2);
                double b2 = gsl_matrix_get(data, i, 3);
                d1_1 += b1 * (n * pow(a1 * b1 + a2 * b2, -1) - 1);
                d1_2 += b2 * (n * pow(a1 * b1 + a2 * b2, -1) - 1);
        }
        gsl_vector_set(val, 0, d1_1);
        gsl_vector_set(val, 1, d1_2);
}

void d2(gsl_vector *param, gsl_matrix *data, gsl_matrix *val)
{
        double d2_1_1 = 0;
        double d2_1_2 = 0;  /* d2_2_1 == d2_1_2 */
        double d2_2_2 = 0;
        double a1 = gsl_vector_get(param, 0);
        double a2 = gsl_vector_get(param, 1);
        for (int i = 0; i < data->size1; ++i) {
                double n = gsl_matrix_get(data, i, 1);
                double b1 = gsl_matrix_get(data, i, 2);
                double b2 = gsl_matrix_get(data, i, 3);
                d2_1_1 += (-1) * pow(b1, 2) * n * pow(a1 * b1 + a2 * b2, -2);
                d2_1_2 += (-1) * b1 * b2 * n * pow(a1 * b1 + a2 * b2, -2);
                d2_2_2 += (-1) * pow(b2, 2) * n * pow(a1 * b1 + a2 * b2, -2);
        }
        gsl_matrix_set(val, 0, 0, d2_1_1);
        gsl_matrix_set(val, 0, 1, d2_1_2);
        gsl_matrix_set(val, 1, 0, d2_1_2);
        gsl_matrix_set(val, 1, 1, d2_2_2);
}

#endif
