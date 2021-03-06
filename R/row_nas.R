#' Conditions related to missing values
#'
#' @export
#' @templateVar par match_type
#' @templateVar choices ("all", "any", "none", "which_first", "count")
#'
#' @template data-param
#' @template generic-choices
#' @inheritDotParams op_ctrl -output_mode -na_action
#'
#' @examples
#'
#' # any base type supported
#' row_nas(data.frame(NA, NA_integer_, NA_real_, NA_complex_), "all", output_class = "data.frame")
#'
row_nas <- function(.data, match_type = "none", ...) {
    UseMethod("row_nas")
}

#' @rdname row_nas
#' @export
#'
row_nas.matrix <- function(.data, match_type = "none", ...) {
    match_type <- match.arg(match_type, c("all", "any", "none", "which_first", "count"))
    output_mode <- if (match_type %in% c("which_first", "count")) "integer" else "logical"

    metadata <- op_ctrl(input_class = "matrix",
                        input_modes = typeof(.data),
                        output_mode = output_mode,
                        na_action = "pass",
                        ...)

    metadata <- validate_metadata(.data, metadata)
    ans <- prepare_output(.data, metadata)

    extras <- list(
        match_type = match_type
    )

    if (NROW(ans) > 0L) {
        .Call(C_row_nas, metadata, .data, ans, extras)
    }

    ans
}

#' @rdname row_nas
#' @export
#'
row_nas.data.frame <- function(.data, match_type = "none", ...) {
    match_type <- match.arg(match_type, c("all", "any", "none", "which_first", "count"))
    output_mode <- if (match_type %in% c("which_first", "count")) "integer" else "logical"

    metadata <- op_ctrl(input_class = "data.frame",
                        input_modes = sapply(.data, typeof),
                        output_mode = output_mode,
                        na_action = "pass",
                        ...)

    metadata <- validate_metadata(.data, metadata)
    ans <- prepare_output(.data, metadata)

    extras <- list(
        match_type = match_type
    )

    if (NROW(ans) > 0L) {
        .Call(C_row_nas, metadata, .data, ans, extras)
    }

    ans
}
