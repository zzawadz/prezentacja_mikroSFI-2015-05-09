#include "RcppMLPACK.h"
#include <mlpack/methods/cf/cf.hpp>
using namespace Rcpp;

// [[Rcpp::plugins("cpp11")]]
// [[Rcpp::depends(RcppMLPACK)]]

// [[Rcpp::export]]
XPtr<mlpack::cf::CF<> > cf_new(arma::mat data)
{
  return XPtr<mlpack::cf::CF<> >(new mlpack::cf::CF<>(data));
}

// [[Rcpp::export]]
arma::Mat<size_t> cf_get_recs(const XPtr<mlpack::cf::CF<> >& ptr, arma::Col<size_t> users, size_t n)
{
  arma::Mat<size_t> recs;
  ptr->GetRecommendations(n, recs, users);
  return recs;
}
