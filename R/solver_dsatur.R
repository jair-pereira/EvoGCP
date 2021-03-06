#' DSatur Solver
#'
#' Solves the 3-GCP problem using DSatur heuristic
#'
#' DSatur heuristic function, adapted from the description by Daniel Brelaz,
#' "New methods to Color the Vertices of a Graph" Communications of the ACM. 22(4): 251?..256 (1979).
#'
#' The algorithm follows 5 steps:
#' 1. Arrange the vertices by decreasing order of degrees (or any given permutation).
#' 2. Color a vertex of maximal degree with color 1.
#' 3. Choose a vertex with a maximal saturation degree.
#' 4. Color the chosen vertex with the least possible (lowest numbered) color.
#' 5. If all the vertices are colored, stop. Otherwise, return to 3.
#'
#' @param G the graph to be solved, represented by a list where G$V is the number of nodes, G$E is a |E|x2 edge matrix,
#' G$adj is the adjacency list.
#' @param nfe the number of iterations allowed
#' @param args a list with arguments for the method. The list must contain the
#' following names:
#' \itemize{
#' \item \emph{weight}: List of weights, which will be used to build a permutation of vertices.
#' \item \emph{return_satur}: Boolean, if the final saturation degrees should be returned (used by some methods like heuristical swap)
#' }
#'
#' @return a list containing the total number of violations of the best coloring, the best coloring
#' (a V vector of 1:3) and the total number of evaluations spent
#'
#' @examples
#' solver_dsatur(10,2)
solver_dsatur <- function(G, nfe, args){#wrapper
  assertthat::assert_that(
    all(assertthat::has_name(args,
                             c("weight", "return_satur")
    )))

  # Parameters:
  weight <- args[["weight"]]
  return_satur <- args[["return_satur"]]

  result <- dsatur(G, nfe, weight) #doesn't color all vertices, doesn't generate violation

  if(return_satur == TRUE){
    r <- list(violation = result[["violation"]], best=result[["best"]], evals=result[["evals"]], satur=result[["satur"]])
  } else{
    r <- list(violation = result[["violation"]], best=result[["best"]], evals=result[["evals"]])
  }

  return(r)

}

#' DSatur (doesn't color all vertices, doesn't generate violation)
dsatur <- function(G, nfe, weight){
  #Init: solution, adjacent colors of each vertex, saturation degrees
  solution <- sample(0, G$V, replace=T)
  adjacent_color <- matrix(0, 3, G$V)

  colored <- which(solution!=0) #set of colored vertices and vertices that could not be colored due to violation.
  satur <- sapply(1:G$V, FUN = function(x) { sum(adjacent_color[,x]) })
  satur[colored] <- -1

  #if tie in saturation, use this permutation
  perm <- order(weight, decreasing = T)

  nit <- 0
  while((nit < nfe) & (length(colored)<G$V)){
    #Next vertex
    v <- perm[which(satur[perm] == max(satur))[1]]

    #possible colors for the vertex v
    colors <- which(adjacent_color[,v] == 0)

    #if it is possible to color v without violation, color it
    #otherwise, leave it with no color
    if(length(colors) > 0){
      #color <- sample(colors, 1) #choose one color randomly
      color <- colors[1] #lowest numbered color

      #Color vertex
      solution[v] <- color

      #update counter of adjacent colors
      adjacent_color[color, G$adj[[as.character(v)]]] <- 1
      adjacent_color[color, v] <- 1

      #update saturation degree
      satur <- sapply(1:G$V, FUN = function(x) { sum(adjacent_color[,x]) })
    }
    #update list of already processed vertices and reduce their priority
    colored <- c(colored, v)
    satur[colored] <- -1

    nit <- nit + 1
  }

  violation <- sum(solution==0)
  evals2 <- ((G$V^2) + nrow(G$E)) / nrow(G$E)
  satur <- sapply(1:G$V, FUN = function(x) { sum(adjacent_color[,x]) })

  return(list(violation = violation, best = solution, evals = evals2, satur = satur))
}

#' Auxiliar function for DSatur
#' Given a set of colors of G, compute adjancent colors to each vertex
#' This is an auxiliary struture to compute the saturation degrees of G
#' @param s, set of colors, size |V|
#' @return a matrix (col: vertices, row: colors) containing the colors adjacent to each vertex
#' (a V vector of 1:3) and the total number of evaluations spent
#'
#' @export
adjacent_color_set <- function(s, G){
  adjacent_color <- matrix(0, 3, G$V)

  for(j in 1:3){
    for(i in which(s == j)){
      adjacent_color[j, G$adj[[as.character(i)]]] <- 1
      adjacent_color[j, i] <- 1
    }
  }

  return(adjacent_color)
}
