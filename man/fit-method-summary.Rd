% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fit.R
\name{fit-method-summary}
\alias{fit-method-summary}
\alias{summary}
\alias{fit-method-print}
\alias{print.CmdStanMCMC}
\alias{print.CmdStanMLE}
\alias{print.CmdStanVB}
\title{Compute a summary table of estimates and diagnostics}
\usage{
summary(variables = NULL, ...)
}
\arguments{
\item{variables}{(character vector) The variables to include.}

\item{...}{Optional arguments to pass to \code{\link[posterior:draws_summary]{posterior::summarise_draws()}}.}
}
\value{
The \verb{$summary()} method returns the tibble data frame created by
\code{\link[posterior:draws_summary]{posterior::summarise_draws()}}.

The \verb{$print()} method returns the fitted model object itself (invisibly),
which is the standard behavior for print methods in \R.
}
\description{
The \verb{$summary()} method runs
\code{\link[posterior:draws_summary]{summarise_draws()}} from the \pkg{posterior}
package and returns the output. For MCMC, only post-warmup draws are
included in the summary.

There is also a \verb{$print()} method that prints the same summary stats but
removes the extra formatting used for printing tibbles and returns the
fitted model object itself. The \verb{$print()} method may also be faster than
\verb{$summary()} because it is designed to only compute the summary statistics
for the variables that will actually fit in the printed output whereas
\verb{$summary()} will compute them for all of the specified variables in order
to be able to return them to the user. See \strong{Examples}.
}
\examples{
\dontrun{
fit <- cmdstanr_example("logistic")
fit$summary()
fit$print()
fit$print(max_rows = 2) # same as print(fit, max_rows = 2)

# include only certain variables
fit$summary("beta")
fit$print(c("alpha", "beta[2]"))

# include all variables but only certain summaries
fit$summary(NULL, c("mean", "sd"))

# can use functions created from formulas
# for example, calculate Pr(beta > 0)
fit$summary("beta", prob_gt_0 = ~ mean(. > 0))
}

}
\seealso{
\code{\link{CmdStanMCMC}}, \code{\link{CmdStanMLE}}, \code{\link{CmdStanVB}}, \code{\link{CmdStanGQ}}
}
