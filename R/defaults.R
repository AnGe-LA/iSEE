.selectByPlot <- "SelectByPlot"
.selectMultiType <- "SelectMultiType"
.selectMultiSaved <- "SelectMultiSaved"

.selectParamBoxOpen0 <- "SelectBoxOpen"
.multiSelectHistory0 <- "MultiSelectHistory"

.selectEffect0 <- "SelectEffect"
.selectColor0 <- "SelectColor"
.selectTransAlpha0 <- "SelectAlpha"

.colorByFeatName0 <- "ColorByFeatName"
.colorByRowTable0 <- "ColorByRowTable"
.colorBySampName0 <- "ColorBySampName"
.colorByColTable0 <- "ColorByColTable"

.colorByFeatNameAssay0 <- "ColorByFeatNameAssay"
.colorBySampNameColor0 <- "ColorBySampNameColor"
.colorBySampNameAssay0 <- "ColorBySampNameAssay"
.colorByFeatNameColor0 <- "ColorByFeatNameColor"

.colorByColData0 <- "ColorByColData"
.shapeByColData0 <- "ShapeByColData"
.sizeByColData0 <- "SizeByColData"

.featAssayXAxisColData0 <- "XAxisColData"
.featAssayXAxisRowTable0 <- "XAxisRowTable"
.featAssayXAxisFeatName0 <- "XAxisFeatName"
.featAssayYAxisRowTable0 <- "YAxisRowTable"
.featAssayYAxisFeatName0 <- "YAxisFeatName"

.sampAssayXAxisColTable0 <- "XAxisColTable"
.sampAssayXAxisSampName0 <- "XAxisSampName"
.sampAssayYAxisColTable0 <- "YAxisColTable"
.sampAssayYAxisSampName0 <- "YAxisSampName"

.colDataXAxisColData0 <- "XAxisColData"

.plotPointSampleRes0 <- "SampleRes"

.lassoData <- "LassoData"

.facetRowsByRowData <- "RowFacetByRowData"
.facetColumnsByRowData <- "ColumnFacetByRowData"
.facetRowsByColData <- "RowFacetByColData"
.facetColumnsByColData <- "ColumnFacetByColData"

#' Deprecated default functions
#'
#' These default-creating functions are deprecated and should be replaced by constructor calls.
#'
#' @param se A SummarizedExperiment object.
#' @param number Integer scalar specfiying the number of panels to use.
#'
#' @details
#' The \code{\link{iSEE}} function will attempt to translate the default parameters here into a
#' the new S4 framework based on the \linkS4class{Panel} and its subclasses.
#'
#' @author Aaron Lun
#'
#' @return
#' A DataFrame containing default settings for parameters of each of \code{number} feature assay panels.
#'
#' @examples
#' example(SingleCellExperiment, echo=FALSE) # mock up 'sce'.
#' redDimPlotDefaults(sce, n=1)
#' featAssayPlotDefaults(sce, n=1)
#' colDataPlotDefaults(sce, n=1)
#'
#' rowStatTableDefaults(sce, n=1)
#' colStatTableDefaults(sce, n=1)
#'
#' rowDataPlotDefaults(sce, n=1)
#' sampAssayPlotDefaults(sce, n=1)
#' heatMapPlotDefaults(sce, n=1)
#' @name defaults
NULL

#' @export
#' @rdname defaults
redDimPlotDefaults <- function(se, number) {
    .Deprecated(new="ReducedDimensionPlot")

    # Ensure that we define all the fields with the right types, using a transient 1-row DF
    # number=0 guarantees that se is not touched to define dummy values of the right type
    waszero <- number == 0
    if (waszero) number <- 1

    out <- new("DataFrame", nrows=as.integer(number))
    out[[.redDimType]] <- 1L
    out[[.redDimXAxis]] <- 1L

    def_yaxis <- NA_integer_
    if (!waszero) def_yaxis <- min(2L, ncol(reducedDim(se, 1L)))
    out[[.redDimYAxis]] <- def_yaxis

    out <- .add_general_parameters_for_column_plots(out, if (waszero) NULL else se)
    if (waszero) out <- out[0, , drop=FALSE]
    return(out)
}

#' @export
#' @rdname defaults
featAssayPlotDefaults <- function(se, number) {
    .Deprecated(new="FeatureAssayPlot")

    # Ensure that we define all the fields with the right types, using a transient 1-row DF
    # number=0 guarantees that se is not touched to define dummy values of the right type
    waszero <- number == 0
    if (waszero) number <- 1

    def_assay <- NA_integer_
    if (!waszero) def_assay <- .set_default_assay(se)

    covariates <- NA_character_
    if (!waszero) covariates <- colnames(colData(se))

    out <- new("DataFrame", nrows=as.integer(number))
    out[[.featAssayAssay]] <- def_assay
    out[[.featAssayXAxis]] <- .featAssayXAxisNothingTitle
    out[[.featAssayXAxisColData]] <- covariates[1]
    out[[.featAssayXAxisFeatName]] <- 1L
    out[[.featAssayXAxisRowTable]] <- .noSelection
    out[[.featAssayYAxisFeatName]] <- 1L
    out[[.featAssayYAxisRowTable]] <- .noSelection

    out <- .add_general_parameters_for_column_plots(out, if (waszero) NULL else se)
    if (waszero) out <- out[0, , drop=FALSE]
    return(out)
}

#' @export
#' @rdname defaults
colDataPlotDefaults <- function(se, number) {
    .Deprecated(new="ColumnDataPlot")

    # Ensure that we define all the fields with the right types, using a transient 1-row DF
    # number=0 guarantees that se is not touched to define dummy values of the right type
    waszero <- number == 0
    if (waszero) number <- 1

    covariates <- NA_character_
    if (!waszero) covariates <- colnames(colData(se))

    out <- new("DataFrame", nrows=as.integer(number))
    out[[.colDataYAxis]] <- covariates[1]
    out[[.colDataXAxis]] <- .colDataXAxisNothingTitle
    out[[.colDataXAxisColData]] <- ifelse(length(covariates) == 1L, covariates[1], covariates[2])

    out <- .add_general_parameters_for_column_plots(out, if (waszero) NULL else se)
    if (waszero) out <- out[0, , drop=FALSE]
    return(out)
}

#' @export
#' @rdname defaults
rowStatTableDefaults <- function(se, number) {
    .Deprecated(new="RowDataTable")

    # Ensure that we define all the fields with the right types, using a transient 1-row DF
    # number=0 guarantees that se is not touched to define dummy values of the right type
    waszero <- number == 0
    if (waszero) number <- 1

    out <- new("DataFrame", nrows=as.integer(number))
    out[[.TableSelected]] <- 1L
    out[[.TableSearch]] <- ""

    # Defining an empty search for each column of the rowData.
    colsearch <- character(0)
    if (!waszero) colsearch <- character(ncol(rowData(se)))
    out[[.TableColSearch]] <- rep(list(colsearch), as.integer(number))

    # Defining the rowDataPlot from which point selections are received.
    out[[.selectParamBoxOpen]] <- FALSE
    out[[.selectByPlot]] <- .noSelection
    out[[.selectMultiType]] <- .selectMultiActiveTitle
    out[[.selectMultiSaved]] <- 0L

    if (waszero) out <- out[0, , drop=FALSE]
    return(out)
}

#' @export
#' @rdname defaults
colStatTableDefaults <- function(se, number) {
    .Deprecated(new="ColumnDataTable")

    # Ensure that we define all the fields with the right types, using a transient 1-row DF
    # number=0 guarantees that se is not touched to define dummy values of the right type
    waszero <- number == 0
    if (waszero) number <- 1

    out <- new("DataFrame", nrows=as.integer(number))
    out[[.TableSelected]] <- 1L
    out[[.TableSearch]] <- ""

    # Defining an empty search for each column of the colData.
    colsearch <- character(0)
    if (!waszero) colsearch <- character(ncol(colData(se)))
    out[[.TableColSearch]] <- rep(list(colsearch), as.integer(number))

    # Defining the colDataPlot from which point selections are received.
    out[[.selectParamBoxOpen]] <- FALSE
    out[[.selectByPlot]] <- .noSelection

    out[[.selectMultiType]] <- .selectMultiActiveTitle
    out[[.selectMultiSaved]] <- 0L

    if (waszero) out <- out[0, , drop=FALSE]
    return(out)
}

#' @export
#' @rdname defaults
rowDataPlotDefaults <- function(se, number) {
    .Deprecated(new="RowDataPlot")

    # Ensure that we define all the fields with the right types, using a transient 1-row DF
    # number=0 guarantees that se is not touched to define dummy values of the right type
    waszero <- number == 0
    if (waszero) number <- 1

    covariates <- NA_character_
    if (!waszero) covariates <- colnames(rowData(se))

    out <- new("DataFrame", nrows=as.integer(number))
    out[[.rowDataYAxis]] <- covariates[1]
    out[[.rowDataXAxis]] <- .rowDataXAxisNothingTitle
    out[[.rowDataXAxisRowData]] <- ifelse(length(covariates)==1L, covariates[1], covariates[2])

    out <- .add_general_parameters_for_row_plots(out, if (waszero) NULL else se)
    if (waszero) out <- out[0, , drop=FALSE]
    return(out)
}

#' @export
#' @rdname defaults
sampAssayPlotDefaults <- function(se, number) {
    .Deprecated(new="SampleAssayPlot")

    # Ensure that we define all the fields with the right types, using a transient 1-row DF
    # number=0 guarantees that se is not touched to define dummy values of the right type
    waszero <- number == 0
    if (waszero) number <- 1

    def_assay <- NA_integer_
    if (!waszero) def_assay <- .set_default_assay(se)

    covariates <- NA_character_
    if (!waszero) covariates <- colnames(rowData(se))

    def_sampname <- NA_integer_
    if (!waszero) def_sampname <- ifelse(ncol(se) == 1L, 1L, 2L)

    out <- new("DataFrame", nrows=as.integer(number))
    out[[.sampAssayYAxisSampName]] <- 1L
    out[[.sampAssayYAxisColTable]] <- .noSelection
    out[[.sampAssayAssay]] <- def_assay
    out[[.sampAssayXAxis]] <- .sampAssayXAxisNothingTitle
    out[[.sampAssayXAxisRowData]] <- covariates[1]
    out[[.sampAssayXAxisSampName]] <- def_sampname
    out[[.sampAssayXAxisColTable]] <- .noSelection

    out <- .add_general_parameters_for_row_plots(out, if (waszero) NULL else se)
    if (waszero) out <- out[0, , drop=FALSE]
    return(out)
}

#' @export
#' @rdname defaults
heatMapPlotDefaults <- function(se, number) {
    .Deprecated(new="ComplexHeatmapPlot")

    # Ensure that we define all the fields with the right types, using a transient 1-row DF
    # number=0 guarantees that se is not touched to define dummy values of the right type
    waszero <- number == 0
    if (waszero) number <- 1

    def_assay <- NA_integer_
    if (!waszero) def_assay <- .set_default_assay(se)

    def_coldata <- NULL
    if (!waszero) def_coldata <- colnames(colData(se))[1]

    out <- new("DataFrame", nrows=as.integer(number))
    out[[.heatMapAssay]] <- def_assay
    out[[.heatMapCustomFeatNames]] <- TRUE
    out[[.heatMapFeatNameText]] <- rownames(se)[1]
    out[[.heatMapClusterFeatures]] <- FALSE
    out[[.heatMapClusterDistanceFeatures]] <- .clusterDistanceSpearman
    out[[.heatMapClusterMethodFeatures]] <- .clusterMethodWardD2
    out[[.dataParamBoxOpen]] <- FALSE

    out[[.heatMapColData]] <- def_coldata
    out[[.heatMapRowData]] <- NA_character_

    out[[.showDimnames]] <- c(.showNamesRowTitle)

    out[[.plotLegendPosition]] <- iSEEOptions$get("legend.position")
    out[[.plotLegendDirection]] <- iSEEOptions$get("legend.direction")
    out[[.visualParamBoxOpen]] <- FALSE

    out[[.selectEffect]] <- .selectColorTitle
    out[[.selectColor]] <- iSEEOptions$get("selected.color")

    out[[.selectByPlot]] <- .noSelection
    out[[.selectMultiType]] <- .selectMultiActiveTitle
    out[[.selectMultiSaved]] <- 0L
    out[[.selectParamBoxOpen]] <- FALSE

    if (waszero) out <- out[0, , drop=FALSE]
    return(out)
}

#' Add general plot defaults
#'
#' Add default values for general plot parameters, including row and column-based plots.
#'
#' @param incoming A DataFrame with non-zero number of rows, containing default parameters that have already been filled for specific panel types.
#'
#' @return A DataFrame with additional fields for general plot parameters, filled with default values.
#'
#' @details
#' The \code{.add_general_parameters} function adds general parameters such as parameter box opening flags,
#' point selection specifications, and zoom, brush and lasso data fields.
#' All parameters are initialized at their default values.
#'
#' The \code{.add_general_parameters_for_column_plots} function adds general parameters for column-based plots,
#' while the \code{.add_general_parameters_for_row_plots} function adds them for row-based plots.
#' These mainly differ in how colouring is performed.
#'
#' The default argument \code{se=NULL} is intended to populate the DataFrame \code{incoming} with dummy values of the appropriate type for each column.
#' This avoids the need to query the \code{se} object for information that will ultimately not be used.
#'
#' @author Aaron Lun
#' @rdname INTERNAL_add_general_parameters
.add_general_parameters <- function(incoming) {
    incoming[[.dataParamBoxOpen]] <- FALSE
    incoming[[.visualParamBoxOpen]] <- FALSE
    incoming[[.selectParamBoxOpen]] <- FALSE

    incoming[[.selectByPlot]] <- .noSelection
    incoming[[.selectEffect]] <- .selectTransTitle
    incoming[[.selectTransAlpha]] <-iSEEOptions$get("selected.alpha")
    incoming[[.selectColor]] <- iSEEOptions$get("selected.color")
    incoming[[.brushData]] <- rep(list(NULL), nrow(incoming))

    incoming[[.multiSelectHistory]] <- rep(list(NULL), nrow(incoming))

    incoming[[.selectMultiType]] <- .selectMultiActiveTitle
    incoming[[.selectMultiSaved]] <- 0L

    incoming[[.visualParamChoice]] <- rep(list(.visualParamChoiceColorTitle), nrow(incoming))

    incoming[[.plotPointSize]] <- iSEEOptions$get("point.size")
    incoming[[.plotPointAlpha]] <- iSEEOptions$get("point.alpha")
    incoming[[.plotPointDownsample]] <- iSEEOptions$get("downsample")
    incoming[[.plotPointSampleRes]] <- iSEEOptions$get("downsample.resolution")

    incoming[[.plotFontSize]] <- iSEEOptions$get("font.size")
    incoming[[.plotLegendPosition]] <- iSEEOptions$get("legend.position")

    incoming[[.zoomData]] <- rep(list(NULL), nrow(incoming))
    incoming[[.lassoData]] <- rep(list(NULL), nrow(incoming))

    incoming[[.contourAdd]] <- FALSE
    incoming[[.contourColor]] <- iSEEOptions$get("contour.color")
    return(incoming)
}

#' @param se A SummarizedExperiment object, or \code{NULL}.
#' @rdname INTERNAL_add_general_parameters
#' @importFrom BiocGenerics colnames
#' @importFrom SummarizedExperiment colData
.add_general_parameters_for_column_plots <- function(incoming, se=NULL) {
    incoming <- .add_general_parameters(incoming)

    def_assay <- NA_integer_
    if (!is.null(se)) def_assay <- .set_default_assay(se)

    def_cov <- NA_character_
    if (!is.null(se)) def_cov <- colnames(colData(se))[1]

    def_discrete <- NA_character_
    if (!is.null(se)) {
        any_discrete <- colnames(colData(se))[.whichGroupable(colData(se))]
        def_discrete <- any_discrete[1]
    }

    def_numeric <- NA_character_
    if (!is.null(se)) {
        any_numeric <- colnames(colData(se))[.whichNumeric(colData(se))]
        def_numeric <- any_numeric[1]
    }

    incoming[[.colorByField]] <- .colorByNothingTitle
    incoming[[.colorByDefaultColor]] <- iSEEOptions$get("point.color")
    incoming[[.colorByColData]] <- def_cov

    incoming[[.shapeByField]] <- .shapeByNothingTitle
    incoming[[.shapeByColData]] <- def_discrete

    incoming[[.sizeByField]] <- .sizeByNothingTitle
    incoming[[.sizeByColData]] <- def_numeric

    incoming[[.colorByRowTable]] <- .noSelection
    incoming[[.colorByFeatName]] <- 1L
    incoming[[.colorByFeatNameAssay]] <- def_assay
    incoming[[.colorByColTable]] <- .noSelection
    incoming[[.colorBySampName]] <- 1L
    incoming[[.colorBySampNameColor]] <- iSEEOptions$get("selected.color")

    incoming[[.facetByRow]] <- FALSE
    incoming[[.facetByColumn]] <- FALSE
    incoming[[.facetRowsByColData]] <- def_discrete
    incoming[[.facetColumnsByColData]] <- def_discrete

    return(incoming)
}

#' @rdname INTERNAL_add_general_parameters
#' @importFrom BiocGenerics colnames
#' @importFrom SummarizedExperiment rowData
.add_general_parameters_for_row_plots <- function(incoming, se=NULL) {
    incoming <- .add_general_parameters(incoming)

    def_cov <- NA_character_
    if (!is.null(se)) def_cov <- colnames(rowData(se))[1]

    def_discrete <- NA_character_
    if (!is.null(se)) {
        any_discrete <- colnames(rowData(se))[.whichGroupable(rowData(se))]
        def_discrete <- any_discrete[1]
    }

    def_numeric <- NA_character_
    if (!is.null(se)) {
        any_numeric <- colnames(rowData(se))[.whichNumeric(rowData(se))]
        def_numeric <- any_numeric[1]
    }

    incoming[[.colorByField]] <- .colorByNothingTitle
    incoming[[.colorByDefaultColor]] <- iSEEOptions$get("point.color")
    incoming[[.colorByRowData]] <- def_cov

    incoming[[.shapeByField]] <- .shapeByNothingTitle
    incoming[[.shapeByRowData]] <- def_discrete

    incoming[[.sizeByField]] <- .sizeByNothingTitle
    incoming[[.sizeByRowData]] <- def_numeric

    incoming[[.colorByRowTable]] <- .noSelection
    incoming[[.colorByFeatName]] <- 1L
    incoming[[.colorByFeatNameColor]] <- iSEEOptions$get("selected.color")
    incoming[[.colorByColTable]] <- .noSelection
    incoming[[.colorBySampName]] <- 1L
    incoming[[.colorBySampNameAssay]] <- 1L

    incoming[[.facetByRow]] <- FALSE
    incoming[[.facetByColumn]] <- FALSE
    incoming[[.facetRowsByRowData]] <- def_discrete
    incoming[[.facetColumnsByRowData]] <- def_discrete

    return(incoming)
}

#' Set the default assay
#'
#' Identifies the index of the assay containing the log-count matrix.
#'
#' @param se A SummarizedExperiment object.
#'
#' @return An integer scalar containing the index of the \code{"logcounts"} assay, if available; otherwise 1L.
#'
#' @details
#' It usually makes most sense to perform visualization (colouring, examination of expression) on the log-expression values,
#' as this provides good dynamic range and easy interpretability.
#' This function conveniently identifies the index of the assay named \code{"logcounts"} for use as the default when it is available.
#'
#' @author Aaron Lun
#' @rdname INTERNAL_set_default_assay
#' @seealso
#' \code{\link{featAssayPlotDefaults}},
#' \code{\link{heatMapPlotDefaults}}
#' @importFrom SummarizedExperiment assayNames
.set_default_assay <- function(se) {
    def_assay <- which(assayNames(se) == "logcounts")

    if (length(def_assay) == 0L) {
        return(1L)
    }

    return(def_assay[1])
}

.create_new_from_old <- function(
    se,
    redDimArgs=NULL,
    colDataArgs=NULL,
    featAssayArgs=NULL,
    rowStatArgs=NULL,
    rowDataArgs=NULL,
    sampAssayArgs=NULL,
    colStatArgs=NULL,
    heatMapArgs=NULL,
    initialPanels=NULL)
{
    if (is.null(redDimArgs) && is.null(colDataArgs) && is.null(featAssayArgs) &&
        is.null(rowStatArgs) && is.null(rowDataArgs) && is.null(sampAssayArgs) &&
        is.null(colStatArgs) && is.null(heatMapArgs) && is.null(initialPanels))
    {
        return(NULL)
    }

    .Deprecated(msg="'*Args' and 'initialPanels' are deprecated.\nUse 'initial' and 'extra' instead.")

    # Generating all of the defaults.
    collected <- list()
    if (is.null(redDimArgs)) {
        suppressWarnings(redDimArgs <- redDimPlotDefaults(se, 5))
    }
    collected <- c(collected, .translate_to_class(redDimArgs, ReducedDimensionPlot, se, FALSE))

    if (is.null(colDataArgs)) {
        suppressWarnings(colDataArgs <- colDataPlotDefaults(se, 5))
    }
    collected <- c(collected, .translate_to_class(colDataArgs, ColumnDataPlot, se, FALSE))

    if (is.null(featAssayArgs)) {
        suppressWarnings(featAssayArgs <- featAssayPlotDefaults(se, 5))
    }
    collected <- c(collected, .translate_to_class(featAssayArgs, FeatureAssayPlot, se, FALSE))

    if (is.null(rowStatArgs)) {
        suppressWarnings(rowStatArgs <- rowStatTableDefaults(se, 5))
    }
    collected <- c(collected, .translate_to_class(rowStatArgs, RowDataTable, se, TRUE))

    if (is.null(rowDataArgs)) {
        suppressWarnings(rowDataArgs <- rowDataPlotDefaults(se, 5))
    }
    collected <- c(collected, .translate_to_class(rowDataArgs, RowDataPlot, se, TRUE))

    if (is.null(sampAssayArgs)) {
        suppressWarnings(sampAssayArgs <- sampAssayPlotDefaults(se, 5))
    }
    collected <- c(collected, .translate_to_class(sampAssayArgs, SampleAssayPlot, se, TRUE))

    if (is.null(colStatArgs)) {
        suppressWarnings(colStatArgs <- colStatTableDefaults(se, 5))
    }
    collected <- c(collected, .translate_to_class(colStatArgs, ColumnDataTable, se, FALSE))

    if (is.null(heatMapArgs)) {
        suppressWarnings(heatMapArgs <- heatMapPlotDefaults(se, 5))
    }
    collected <- c(collected, .translate_to_class(heatMapArgs, ComplexHeatmapPlot, se, FALSE))

    names(collected) <- vapply(collected, .getEncodedName, "")

    # Pulling out the initialPanels only.
    memory <- list()
    for (x in seq_len(max(nrow(initialPanels), 0L))) {
        name <- .convert_old_name_to_new(initialPanels$Name[x])
        if (!name %in% names(collected)) {
            next
        }

        chosen <- collected[[name]]

        if ("Height" %in% colnames(initialPanels)) {
            chosen[[.organizationHeight]] <- as.integer(initialPanels$Height[x])
        }
        if ("Width" %in% colnames(initialPanels)) {
            chosen[[.organizationWidth]] <- as.integer(initialPanels$Width[x])
        }

        memory[[name]] <- chosen
    }

    list(initial=memory, extra=collected)
}

.translate_to_class <- function(df, constructor, se, is_row) {
    collected <- vector("list", nrow(df))
    for (x in seq_len(nrow(df))) {
        parameters <- as.list(df[x,])
        parameters[[.organizationId]] <- x
        nm <- names(parameters)

        # Renaming these fields.
        names(parameters)[nm==.selectByPlot] <- if (is_row) .selectRowSource else .selectColSource
        names(parameters)[nm==.selectMultiType] <- if (is_row) .selectRowType else .selectColType
        names(parameters)[nm==.selectMultiSaved] <- if (is_row) .selectRowSaved else .selectColSaved

        renamer <- list(
            c(.selectParamBoxOpen0, .selectParamBoxOpen),
            c(.multiSelectHistory0, .multiSelectHistory),
            c(.selectEffect0, .selectEffect),
            c(.selectColor0, .selectColor),
            c(.selectTransAlpha0, .selectTransAlpha),
            c(.colorByFeatName0, .colorByFeatName),
            c(.colorByRowTable0, .colorByRowTable),
            c(.colorBySampName0, .colorBySampName),
            c(.colorByColTable0, .colorByColTable),
            c(.colorByColData0, .colorByColData),
            c(.shapeByColData0, .shapeByColData),
            c(.sizeByColData0, .sizeByColData),
            c(.featAssayXAxisColData0, .featAssayXAxisColData),
            c(.colDataXAxisColData0, .colDataXAxisColData),
            c(.colorByFeatNameAssay0, .colorByFeatNameAssay),
            c(.colorBySampNameColor0, .colorBySampNameColor),
            c(.colorBySampNameAssay0, .colorBySampNameAssay),
            c(.colorByFeatNameColor0, .colorByFeatNameColor),
            c(.featAssayXAxisRowTable0, .featAssayXAxisRowTable),
            c(.featAssayXAxisFeatName0, .featAssayXAxisFeatName),
            c(.featAssayYAxisRowTable0, .featAssayYAxisRowTable),
            c(.featAssayYAxisFeatName0, .featAssayYAxisFeatName),
            c(.sampAssayXAxisColTable0, .sampAssayXAxisColTable),
            c(.sampAssayXAxisSampName0, .sampAssayXAxisSampName),
            c(.sampAssayYAxisColTable0, .sampAssayYAxisColTable),
            c(.sampAssayYAxisSampName0, .sampAssayYAxisSampName),
            c(.plotPointSampleRes0, .plotPointSampleRes)
        )

        for (i in renamer) {
            replace <- which(names(parameters) %in% i[1])
            if (length(replace)) {
                names(parameters)[replace] <- i[2]
            }
        }

        # Migrating non-empty lasso to the brush data.
        if (length(parameters[[.lassoData]])) {
            parameters[[.brushData]] <- parameters[[.lassoData]]
            parameters[[.lassoData]] <- NULL
        }

        # Converting the faceting to the new world:
        if (.facetByRow %in% nm) {
            row_target <- if (is_row) .facetRowsByRowData else .facetRowsByColData
            col_target <- if (is_row) .facetColumnsByRowData else .facetColumnsByColData

            parameters[[.facetByRow]] <- parameters[[row_target]]
            if (is.na(parameters[[.facetByRow]])) parameters[[.facetByRow]] <- .noSelection

            parameters[[.facetByColumn]] <- parameters[[col_target]]
            if (is.na(parameters[[.facetByColumn]])) parameters[[.facetByColumn]] <- .noSelection

            parameters[[row_target]] <- NULL
            parameters[[col_target]] <- NULL
        }

        # Converting from lists to their actual entries.
        if (.TableColSearch %in% nm) {
            parameters[[.TableColSearch]] <- as.character(parameters[[.TableColSearch]][[1]])
        }
        if (.zoomData %in% nm) {
            parameters[[.zoomData]] <- as.numeric(parameters[[.zoomData]][[1]])
        }
        if (.brushData %in% nm) {
            parameters[[.brushData]] <- as.list(parameters[[.brushData]][[1]])
        }
        if (.visualParamChoice %in% nm) {
            parameters[[.visualParamChoice]] <- as.character(parameters[[.visualParamChoice]][[1]])
        }
        parameters[[.multiSelectHistory]] <- as.list(parameters[[.multiSelectHistory]][[1]])

        # Running through all checking if we have any panel names, and converting them.
        for (i in names(parameters)) {
            if (length(parameters[[i]])==1L) {
                potential <- .convert_old_name_to_new(parameters[[i]])
                if (!is.null(potential)) {
                    parameters[[i]] <- potential
                }
            }
        }

        # Checking if we have other names that need to be converted.
        for (i in names(parameters)) {
            if (!is.integer(parameters[[i]])) {
                next
            }
            if (grepl("FeatureName$", i)) {
                parameters[[i]] <- rownames(se)[parameters[[i]]]
            } else if (grepl("SampleName$", i)) {
                parameters[[i]] <- colnames(se)[parameters[[i]]]
            } else if (grepl("Assay$", i)) {
                parameters[[i]] <- assayNames(se)[parameters[[i]]]
            }
        }

        if (.redDimType %in% nm) {
            parameters[[.redDimType]] <- reducedDimNames(se)[parameters[[.redDimType]]]
        }

        if (.TableSelected %in% nm) {
            parameters[[.TableSelected]] <- (if (is_row) rownames(se) else colnames(se))[parameters[[.TableSelected]]]
        }

        collected[[x]] <- do.call(constructor, parameters)
    }

    collected
}

.convert_old_name_to_new <- function(old_name) {
    ref <- sub(" [0-9]+$", "", old_name)
    converter <- c(
        ReducedDimensionPlot="Reduced dimension plot",
        FeatureAssayPlot="Feature assay plot",
        ColumnDataTable="Column statistics table",
        ColumnDataPlot="Column data plot",
        RowDataPlot="Row data plot",
        RowDataTable="Row statistics table",
        SampleAssayPlot="Sample assay plot",
        ComplexHeatmapPlot="Heat map")

    if (ref %in% converter) {
        idx <- as.integer(sub(".* ", "", old_name))
        if (!is.na(idx)) {
            return(paste0(names(converter)[ref==converter], idx))
        }
    }

    NULL
}

