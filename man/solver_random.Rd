% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/solver_random.R
\name{solver_random}
\alias{solver_random}
\title{Random Solver}
\usage{
solver_random(G, nfe, args)
}
\arguments{
\item{G}{the graph to be solved, represented by a list where G$V is the number of nodes, and G$E is a |E|x2 edge matrix.}

\item{nfe}{the number of function evaluations allowed}

\item{args}{a list of arguments -- none is used in this particular method}
}
\value{
a list containing the total number of violations of the best coloring, the best coloring
(a V vector of 1:3) and the total number of evaluations spent
}
\description{
Solves the 3-GCP problem by generating random colorings
}

