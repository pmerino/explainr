# basic explain S3 function

#' Explain an object in plain English
#'
#' @param x an object
#' @param ... extra arguments
#'
#' @return A text description of the object
explain <- function (x, ...) UseMethod("explain")


#' compile an object using a template
#'
#' @param template a template, typically loaded from \code{load_template}
#' @param theme name of the theme to use
#' @param ... objects to be provided to the template
#'
#' @return A compiled text version of the object
compile_template <- function(template, theme = "default", ...) {
    if (is.character(theme)) {
        # retrieve theme
        theme <- explainr_themes[[theme]]
    }
    tem <- theme[[template]]

    if (is.null(tem)) {
        stop("Template for this object not found. You should write one!")
    }

    # knit content in a new environment
    env <- list2env(list(...))

    # set options, but be able to set them back
    starting_options <- knitr::opts_chunk$get()
    knitr::opts_chunk$set(echo = FALSE, fig.path = "explainr-figures/",
                          message = FALSE, results = 'asis')

    out <- knitr::knit(text = tem$content, envir = env, quiet = TRUE)

    # back to initial options
    do.call(knitr::opts_chunk$set, starting_options)
    explainr_output(out)
}


#' explain an S3 object in plain English
#'
#' @param x an object to be explained
#' @param theme theme to use
#' @param ... extra arguments
#'
#' @import dplyr
explain.default <- function(x, theme = "default", template = NULL, ...) {
    if (is.null(template)) {
        template <- class(x)[1]
    }

    compile_template(template, x = x, theme = theme)
}
