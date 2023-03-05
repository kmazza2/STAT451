#include <gsl/gsl_vector.h>
#include <math.h>

double norm(gsl_vector *param)
{
        double result = 0;
        for (int i = 0; i < param->size; ++i) {
                result += pow(gsl_vector_get(param, i), 2);
        }
        return sqrt(result);
}
