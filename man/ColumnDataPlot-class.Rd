% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/panel_ColumnDataPlot.R
\docType{methods}
\name{ColumnDataPlot-class}
\alias{ColumnDataPlot-class}
\alias{ColumnDataPlot}
\alias{initialize,ColumnDataPlot-method}
\alias{.refineParameters,ColumnDataPlot-method}
\alias{.defineDataInterface,ColumnDataPlot-method}
\alias{.createObservers,ColumnDataPlot-method}
\alias{.fullName,ColumnDataPlot-method}
\alias{.panelColor,ColumnDataPlot-method}
\alias{.generateDotPlotData,ColumnDataPlot-method}
\alias{.allowableXAxisChoices,ColumnDataPlot-method}
\alias{.allowableYAxisChoices,ColumnDataPlot-method}
\title{The ColumnDataPlot panel}
\description{
The ColumnDataPlot is a panel class for creating a \linkS4class{ColumnDotPlot} where the y-axis represents a variable from the \code{\link{colData}} of a \linkS4class{SummarizedExperiment} object.
It provides slots and methods for specifying which column metadata variable to use on the y-axis and what to plot on the x-axis.
}
\section{Slot overview}{

The following slots control the column data information that is used:
\itemize{
\item \code{YAxis}, a string specifying the column of the \code{\link{colData}} to show on the y-axis.
If \code{NA}, defaults to the first valid field (see \code{?"\link{.refineParameters,ColumnDotPlot-method}"}).
\item \code{XAxis}, string specifying what should be plotting on the x-axis.
This can be any one of \code{"None"} or \code{"Column data"}.
Defaults to \code{"None"}.
\item \code{XAxisColumnData}, string specifying the column of the \code{\link{colData}} to show on the x-axis.
If \code{NA}, defaults to the first valid field.
}

In addition, this class inherits all slots from its parent \linkS4class{ColumnDotPlot}, \linkS4class{DotPlot} and \linkS4class{Panel} classes.
}

\section{Constructor}{

\code{ColumnDataPlot(...)} creates an instance of a ColumnDataPlot class, where any slot and its value can be passed to \code{...} as a named argument.
}

\section{Supported methods}{

In the following code snippets, \code{x} is an instance of a \linkS4class{ColumnDataPlot} class.
Refer to the documentation for each method for more details on the remaining arguments.

For setting up data values:
\itemize{
\item \code{\link{.refineParameters}(x, se)} returns \code{x} after replacing any \code{NA} value in \code{YAxis} or \code{XAxisColumnData} with the name of the first valid \code{\link{colData}} variable.
This will also call the equivalent \linkS4class{ColumnDotPlot} method for further refinements to \code{x}.
If no valid column metadata variables are available, \code{NULL} is returned instead.
}

For defining the interface:
\itemize{
\item \code{\link{.defineDataInterface}(x, se, select_info)} returns a list of interface elements for manipulating all slots described above.
\item \code{\link{.panelColor}(x)} will return the specified default color for this panel class.
\item \code{\link{.allowableXAxisChoices}(x, se)} returns a character vector specifying the acceptable variables in \code{\link{colData}(se)} that can be used as choices for the x-axis. 
\item \code{\link{.allowableYAxisChoices}(x, se)} returns a character vector specifying the acceptable variables in \code{\link{colData}(se)} that can be used as choices for the y-axis. 
}

For monitoring reactive expressions:
\itemize{
\item \code{\link{.createObservers}(x, se, input, session, pObjects, rObjects)} sets up observers for all slots described above and in the parent classes.
This will also call the equivalent \linkS4class{ColumnDotPlot} method.
}

For defining the panel name:
\itemize{
\item \code{\link{.fullName}(x)} will return \code{"Column data plot"}.
}

For creating the plot:
\itemize{
\item \code{\link{.generateDotPlotData}(x, envir)} will create a data.frame of column metadata variables in \code{envir}.
It will return the commands required to do so as well as a list of labels.
}
}

\section{Subclass expectations}{

Subclasses do not have to provide any methods, as this is a concrete class.
}

\examples{
#################
# For end-users #
#################

x <- ColumnDataPlot()
x[["XAxis"]]
x[["XAxis"]] <- "Column data"

##################
# For developers #
##################

library(scater)
sce <- mockSCE()
sce <- logNormCounts(sce)

old_cd <- colData(sce)
colData(sce) <- NULL

# Spits out a NULL and a warning if there is nothing to plot.
sce0 <- .cacheCommonInfo(x, sce)
.refineParameters(x, sce0)

# Replaces the default with something sensible.
colData(sce) <- old_cd
sce0 <- .cacheCommonInfo(x, sce)
.refineParameters(x, sce0)

}
\seealso{
\linkS4class{ColumnDotPlot}, for the immediate parent class.
}
\author{
Aaron Lun
}
