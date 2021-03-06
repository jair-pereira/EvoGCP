% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/util.R
\name{similarity.kui}
\alias{similarity.kui}
\title{Kui's similarity}
\usage{
similarity.kui(x1, x2)
}
\description{
Based on the hamming distance ''similarity'', but with added randomness
for extra fun. The similarity between coloring vectors x and y is
calculated as before, but with an extra factor R.
}
\details{
1 - R * (d / length)

Where d is the number of positions with different colors between x and y,
and R is a random uniform number between 0 and 1.
}

