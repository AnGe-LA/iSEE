#' The RowDataTable panel
#'
#' The RowDataTable is a panel class for creating a \linkS4class{ColumnTable} where the value of the table is defined as the \code{\link{rowData}} of the \linkS4class{SummarizedExperiment}.
#'
#' @section Slot overview:
#' This class inherits all slots from its parent \linkS4class{ColumnTable} and \linkS4class{Table} classes.
#'
#' @section Constructor:
#' \code{RowDataTable(...)} creates an instance of a RowDataTable class, where any slot and its value can be passed to \code{...} as a named argument.
#'
#' Note that \code{ColSearch} should be a character vector of length equal to the total number of columns in the \code{\link{rowData}}, though only the entries for the atomic fields will actually be used.
#' 
#' @section Supported methods:
#' In the following code snippets, \code{x} is an instance of a \linkS4class{RowDataTable} class.
#' Refer to the documentation for each method for more details on the remaining arguments.
#'
#' For setting up data values:
#' \itemize{
#' \item \code{\link{.cacheCommonInfo}(x)} adds a \code{"RowDataTable"} entry containing \code{valid.rowData.names}, a character vector of names of atomic columns of the \code{\link{rowData}}.
#' This will also call the equivalent \linkS4class{ColumnTable} method.
#' \item \code{\link{.refineParameters}(x, se)} adjusts \code{ColSearch} to a character vector of length equal to the number of atomic fields in the \code{\link{rowData}}.
#' This will also call the equivalent \linkS4class{ColumnTable} method for further refinements to \code{x}.
#' }
#'
#' For defining the interface:
#' \itemize{
#' \item \code{\link{.hideInterface}(x, field)} returns \code{TRUE} if \code{field="DataBoxOpen"}, 
#' otherwise it calls \code{\link{.hideInterface,Table-method}}
#' \item \code{\link{.panelColor}(x)} will return the specified default color for this panel class.
#' }
#'
#' For defining the panel name:
#' \itemize{
#' \item \code{\link{.fullName}(x)} will return \code{"Row data table"}.
#' }
#' 
#' For creating the output:
#' \itemize{
#' \item \code{\link{.generateTable}(x, envir)} will modify \code{envir} to contain the relevant data.frame for display,
#' while returning a character vector of commands required to produce that data.frame.
#' Each row of the data.frame should correspond to a row of the SummarizedExperiment.
#' }
#'
#' @author Aaron Lun
#'
#' @examples
#' #################
#' # For end-users #
#' #################
#'
#' x <- RowDataTable()
#' x[["Selected"]]
#' x[["Selected"]] <- "SOME_ROW_NAME"
#'
#' ##################
#' # For developers #
#' ##################
#'
#' library(scater)
#' sce <- mockSCE()
#'
#' # Sets the search columns appropriately.
#' sce <- .cacheCommonInfo(x, sce)
#' .refineParameters(x, sce)
#'
#' @name RowDataTable-class
#' @aliases RowDataTable RowDataTable-class
#' initialize,RowDataTable-method
#' .cacheCommonInfo,RowDataTable-method
#' .refineParameters,RowDataTable-method
#' .hideInterface,RowDataTable-method
#' .generateTable,RowDataTable-method
#' .panelColor,RowDataTable-method
#' .fullName,RowDataTable-method
#' .generateTable,RowDataTable-method
NULL

#' @export
RowDataTable <- function(...) {
    new("RowDataTable", ...)
}

#' @export
#' @importFrom SummarizedExperiment rowData
setMethod(".cacheCommonInfo", "RowDataTable", function(x, se) {
    if (!is.null(.getCachedCommonInfo(se, "RowDataTable"))) {
        return(se)
    }

    se <- callNextMethod()

    df <- rowData(se)
    available <- .findAtomicFields(df)
    .setCachedCommonInfo(se, "RowDataTable",
        valid.rowData.names=available)
})

#' @export
#' @importFrom SummarizedExperiment rowData
setMethod(".refineParameters", "RowDataTable", function(x, se) {
    x <- callNextMethod()
    if (is.null(x)) {
        return(NULL)
    }

    valid.names <- .getCachedCommonInfo(se, "RowDataTable")$valid.rowData.names
    df <- rowData(se)

    # First, expanding out so that we cover all columns.
    search_vals <- x[[.TableColSearch]]
    N <- ncol(df)
    if (length(search_vals)!=N) {
        search_vals <- character(N)
    }

    # Then, contracting only to those columns that survived.
    keep <- match(valid.names, colnames(df))
    search_vals <- search_vals[keep]
    x[[.TableColSearch]] <- search_vals

    x
})

#' @export
setMethod(".fullName", "RowDataTable", function(x) "Row data table")

#' @export
setMethod(".panelColor", "RowDataTable", function(x) "#E47E04")

#' @export
setMethod(".hideInterface", "RowDataTable", function(x, field) {
    if (field %in% .dataParamBoxOpen) {
        TRUE
    } else {
        callNextMethod()
    }
})

#' @export
#' @importFrom SummarizedExperiment rowData
setMethod(".generateTable", "RowDataTable", function(x, envir) {
    cmds <-"tab <- as.data.frame(rowData(se));"

    if (exists("row_selected", envir=envir, inherits=FALSE)) {
        cmds <- c(cmds, "tab <- tab[unique(unlist(row_selected)),,drop=FALSE]")
    }

    valid.names <- .getCachedCommonInfo(envir$se, "RowDataTable")$valid.rowData.names
    if (!identical(colnames(rowData(envir$se)), valid.names)) {
        cmds <- c(cmds, sprintf("tab <- tab[,%s,drop=FALSE]",
            paste(deparse(valid.names), collapse="\n     ")))
    }

    .textEval(cmds, envir)

    cmds
})
