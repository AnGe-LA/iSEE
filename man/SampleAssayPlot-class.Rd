% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/panel_SampleAssayPlot.R
\docType{methods}
\name{SampleAssayPlot-class}
\alias{SampleAssayPlot-class}
\alias{SampleAssayPlot}
\alias{initialize,SampleAssayPlot-method}
\alias{.refineParameters,SampleAssayPlot-method}
\alias{.defineDataInterface,SampleAssayPlot-method}
\alias{.createObservers,SampleAssayPlot-method}
\alias{.singleSelectionSlots,SampleAssayPlot-method}
\alias{.fullName,SampleAssayPlot-method}
\alias{.panelColor,SampleAssayPlot-method}
\alias{.generateDotPlotData,SampleAssayPlot-method}
\title{The SampleAssayPlot panel}
\description{
The SampleAssayPlot is a panel class for creating a \linkS4class{ColumnDotPlot} where the y-axis represents the expression of a sample of interest, using the \code{\link{assay}} values of the \linkS4class{SummarizedExperiment}.
It provides slots and methods for specifying which sample to use and what to plot on the x-axis.
}
\section{Slot overview}{

The following slots control the dimensionality reduction result that is used:
\itemize{
\item \code{YAxisSampleName}, a string specifying the name of the sample to plot on the y-axis.
If \code{NA}, defaults to the first column name of the SummarizedExperiment object.
\item \code{Assay}, string specifying the name of the assay to use for obtaining expression values.
Defaults to the first valid assay name (see \code{?"\link{.refineParameters,DotPlot-method}"} for details).
\item \code{YAxisSampleSource}, string specifying the encoded name of the transmitting panel to obtain a single selection that replaces \code{YAxisSampleName}.
Defaults to \code{"---"}, i.e., no transmission is performed.
\item \code{XAxis}, string specifying what should be plotting on the x-axis.
This can be any one of \code{"None"}, \code{"Sample name"} or \code{"Column data"}.
Defaults to \code{"None"}.
\item \code{XAxisColumnData}, string specifying which column of the \code{\link{colData}} should be shown on the x-axis,
if \code{XAxis="Column data"}.
Defaults to the first valid \code{\link{colData}} field (see \code{?"\link{.refineParameters,ColumnDotPlot-method}"} for details).
\item \code{XAaxisSampleName}, string specifying the name of the sample to plot on the x-axis,
if \code{XAxis="Sample name"}.
Defaults to the first column name.
\item \code{XAxisSampleSource}, string specifying the encoded name of the transmitting panel to obtain a single selection that replaces \code{XAxisSampleName}.
Defaults to \code{"---"}, i.e., no transmission is performed.
}

In addition, this class inherits all slots from its parent \linkS4class{ColumnDotPlot}, \linkS4class{DotPlot} and \linkS4class{Panel} classes.
}

\section{Constructor}{

\code{SampleAssayPlot(...)} creates an instance of a SampleAssayPlot class, where any slot and its value can be passed to \code{...} as a named argument.
}

\section{Supported methods}{

In the following code snippets, \code{x} is an instance of a \linkS4class{SampleAssayPlot} class.
Refer to the documentation for each method for more details on the remaining arguments.

For setting up data values:
\itemize{
\item \code{\link{.refineParameters}(x, se)} replaces any \code{NA} values in \code{XAxisSampleName} and \code{YAxisSampleName} with the first column name; any \code{NA} value in \code{Assay} with the first valid assay name; and any \code{NA} value in \code{XAxisColumnData} with the first valid column metadata field.
This will also call the equivalent \linkS4class{ColumnDotPlot} method for further refinements to \code{x}.
If no columns or assays are present, \code{NULL} is returned instead.
}

For defining the interface:
\itemize{
\item \code{\link{.defineDataInterface}(x, se, select_info)} returns a list of interface elements for manipulating all slots described above.
\item \code{\link{.panelColor}(x)} will return the specified default color for this panel class.
}

For monitoring reactive expressions:
\itemize{
\item \code{\link{.createObservers}(x, se, input, session, pObjects, rObjects)} sets up observers for all slots described above and in the parent classes.
This will also call the equivalent \linkS4class{ColumnDotPlot} method.
}

For defining the panel name:
\itemize{
\item \code{\link{.fullName}(x)} will return \code{"Sample assay plot"}.
}

For creating the plot:
\itemize{
\item \code{\link{.generateDotPlotData}(x, envir)} will create a data.frame of sample assay values in \code{envir}.
It will return the commands required to do so as well as a list of labels.
}

For managing selections:
\itemize{
\item \code{\link{.singleSelectionSlots}(x)} will return a list specifying the slots that can be updated by single selections in transmitter panels, mostly related to the choice of sample on the x- and y-axes.
This includes the output of \code{callNextMethod}.
}
}

\examples{
#################
# For end-users #
#################

x <- SampleAssayPlot()
x[["XAxis"]]
x[["Assay"]] <- "logcounts"
x[["XAxisRowData"]] <- "stuff"

##################
# For developers #
##################

library(scater)
sce <- mockSCE()
sce <- logNormCounts(sce)

old_assay_names <- assayNames(sce)
assayNames(sce) <- character(length(old_assay_names))

# Spits out a NULL and a warning if no assays are named.
sce0 <- .cacheCommonInfo(x, sce)
.refineParameters(x, sce0)

# Replaces the default with something sensible.
assayNames(sce) <- old_assay_names
sce0 <- .cacheCommonInfo(x, sce)
.refineParameters(x, sce0)

}
\seealso{
\linkS4class{ColumnDotPlot}, for the immediate parent class.
}
\author{
Aaron Lun
}
