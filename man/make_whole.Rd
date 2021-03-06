% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/make_whole.R
\name{make_whole}
\alias{make_whole}
\title{Constructs a continuous, uninterrupted time series of temperatures.}
\usage{
make_whole(data, x = t, y = temp)
}
\arguments{
\item{data}{A data frame with columns for date and temperature data.
Ordered daily data are expected, and although missing values (NA) can be
accommodated, the function is only recommended when NAs occur infrequently,
preferably at no more than 3 consecutive days.}

\item{x}{A column with the daily time vector (see details). For backwards
compatibility, the column is named \code{t} by default.}

\item{y}{A column with the response vector. RmarineHeatWaves version <= 0.15.9
assumed that this would be daily seawater temperatures, but as of version 0.16.0
it may be any arbitrary measurement taken at a daily frequency. The default
remains temperature, and the default column name is therefore \code{temp}, again
hopefully ensuring backwards compatibility.}
}
\value{
The function will return a data frame with three columns. The column
headed \code{doy} (day-of-year) is the Julian day running from 1 to 366, but
modified so that the day-of-year series for non-leap-years runs 1...59 and
then 61...366. For leap years the 60th day is February 29. See the example,
below. The other two columns take the names of \code{x} and \code{y}, if supplied,
or it will be \code{t} and \code{temp} in case the default values were used.
The \code{x} (or \code{t}) column is a series of dates of class \code{Date},
while \code{y} (or \code{temp}) is the measured variable. This time series will
be uninterrupted and continuous daily values between the first and last dates
of the input data.
}
\description{
Takes a series of dates and temperatures, and if irregular (but ordered), inserts
missing dates and fills correpsonding temperatures with NAs.
}
\details{
\enumerate{
\item Upon import, the package uses `zoo` and `lubridate` to process the input
date and temperature data. It reads in daily data with the time vector
specified as either \code{POSIXct} or \code{Date} (e.g. "1982-01-01 02:00:00" or
"1982-01-01"). The data may be an irregular time series, but date must be
ordered. The function constructs a complete time series from the start date
to the end date, and fills in the regions in the time series where temperature
data are missing with NAs in the temperature vector. There must only be one
temperature value per day otherwise the function take the mean of multiple
values. It is up to the user to calculate daily data from sub-daily
measurements. Leap years are automatically accommodated by this function.

\item This function can handle some of missing days, but this is not a
licence to actually use these data for the detection of anomalous thermal
events. Hobday et al. (2016) recommend gaps of no more than 3 days, which
may be adjusted by setting the \code{maxPadLength} argument of the
\code{\link{ts2clm}} function. The longer and more frequent the gaps become
the lower the fidelity of the annual climatology and threshold that can be
calculated, which will not only have repercussions for the accuracy at which
the event metrics can be determined, but also for the number of events that
can be detected.

\item It is recommended that a climatology period of at least 30 years is
specified in order to capture any decadal thermal periodicities.

\item Previous versions of \code{make_whole} tested to see if some rows are
duplicated, or if replicate temperature readings are present per day, but this
has now been disabled. Should the user be concerned about such repeated
measurements, we suggest that the necessary checks and fixes are implemented
prior to feeding the time series to \code{make_whole} (this is usually done
via \code{\link{ts2clm}}).

\item A faster version of this function called \code{make_whole_fast}
is enabled by default in \code{ts2clm}, and we assume (hopefully correctly)
that the user is certain that her data do not have missing rows (dates) or
duplicated values. This slower but more robust function (i.e. \code{make_whole})
may be selected as an argument to \code{ts2clm} in case the data may have some
issues.
}
}
\author{
Smit, A. J.
}
