% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/directoryInput.R
\name{updateDirectoryInput}
\alias{updateDirectoryInput}
\title{Change the value of a directoryInput on the client}
\usage{
updateDirectoryInput(session, inputId, value)
}
\arguments{
\item{session}{The \code{session} object passed to function given to \code{shinyServer}.}

\item{inputId}{The id of the input object.}

\item{value}{A directory path to set}
}
\description{
Change the value of a directoryInput on the client
}
\details{
Sends a message to the client, telling it to change the value of the input
object.  For \code{directoryInput} objects, this changes the value displayed
in the text-field and triggers a client-side change event.  A directory
selection dialog is not displayed.
}
