% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/problemset.R
\name{problemset}
\alias{problemset}
\title{Problemset Generator}
\usage{
problemset(P, N, density, method)
}
\arguments{
\item{P}{number of problems to be generated}

\item{N}{number of vertices in each problem}

\item{density}{edge density in each problem}

\item{method}{a string defining the function for problem generation. Will load a "graph_method" from the package}
}
\value{
a list with P instances of 3GCP problems with N vertices and N*density edges
}
\description{
Generate a set of 3GCP problems
}

