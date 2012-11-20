
library(ggplot2)

# Load coverage data (Note that I have removed all text from the original output files from gatk)
lib1 = read.delim("<file1>", header=F)
lib2 = read.delim("<file2>", header=F)

# Remove extra line
lib1<-lib1[,2:length(lib1)]
lib2<-lib2[,2:length(lib2)]

# Combining the data sets
data<-data.frame(t(lib1),rep("manual"))
colnames(data)<-c("coverage","loci","prep_type")
lib2<-cbind(t(lib2),rep("robot"))
colnames(lib2)<-c("coverage","loci","prep_type")
data<-rbind(data, lib2)

# Remove the "gte_" part from the coverage function
data$coverage<-sapply(data$coverage, function(x) sub("gte_", "",x))

# Convert to reasonable data types...
data$coverage<-as.numeric(data$coverage)
data$loci<-as.numeric(as.character(data$loci))

sumManualLociCovered <- sum(as.numeric(as.character(data[data$prep_type == "manual",]$loci)))
sumRobotLociCovered <- sum(as.numeric(as.character(data[data$prep_type == "robot",]$loci)))


totalNumberOfLociCovered <- data$loci[1]

data$loci <- data$loci / totalNumberOfLociCovered

# Normalized over the total number of reads in each file.
data[data$prep_type == "manual",]$coverage <-data[data$prep_type == "manual",]$coverage/764574276
data[data$prep_type == "robot",]$coverage <-data[data$prep_type == "robot",]$coverage/208914034

ggplot(data=data, aes(x=log(coverage), y=loci, color=prep_type)) +
  geom_point() +
  ylab("% of bases covered") +
  xlab("log(1/base)") +
  opts(title = "Cumulative coverage compassion")

