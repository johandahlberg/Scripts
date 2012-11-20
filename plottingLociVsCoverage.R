
library(ggplot2)

#Function to put the data in the correct format for plotting
preprocessCoverageFile <- function(file, timeSeries) {
  # Load coverage data
  data = read.delim(file, header=T)
  # Remove everything before ":"
  data$Locus<-gsub(".*:","",data$Locus)
  data$Locus<-as.numeric(data$Locus)
  data<-subset(data, select=c(Locus, Total_Depth))
  data$Time<-c(as.character(timeSeries))
  data
}

#Function to plot the coverage
plotCoverage <- function(coverage, title) {
  ggplot(data=coverage, aes(x=Locus, y=Total_Depth, colour=Time)) +
    geom_line() +
    ylab("Depth of coverage") +
    xlab("Loci") +
    labs(title=title)
}


# Example of using the above functions.

outputPDFFile = "<some file>"
# Load coverage data
coverageControl = preprocessCoverageFile("<file1>", "Control")
coverageSample1 = preprocessCoverageFile("<file2>", "Sample 1")

# Create dataset with all data together.
allCoverage<-rbind(coverageControl,coverageSample1)

# Plot the data to a pdf
pdf(outputPDFFile, paper="a4r", width=10)

plotCoverage(coverageControl, "Coverage plot for control")
plotCoverage(coverageSample1, "Coverage plot for sample 1")
plotCoverage(allCoverage, "Coverage plot for all samples")

dev.off()
