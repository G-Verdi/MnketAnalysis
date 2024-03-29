#-----------------------------
#Description
# Formats ASC scores form excel sheet, plots subscales and run t-tests
#-----------------------------
install.packages("knitr")
install.packages("kableExtra")
install.packages("tidyverse")
install.packages("gtsummary")
library(tidyverse)
library(gtsummary)
library(ggplot2)
library(gridExtra)
library(readxl)
library(knitr)
library(kableExtra)
#set paths

# project working directory and label data file name
working_dir = getwd()

#Import excel data
Q_data_copy <- read_excel() # insert path to excel data
View(Q_data_copy)

#------------------------------------
#Load data
#-----------------------------------

# Separate study groups
MNKET_pla<-Q_data_copy[1:19,1:16]
MNPSI_pla<-Q_data_copy[20:35,1:16]
MNKET_drug<-Q_data_copy[36:54,1:16]
MNPSI_drug<-Q_data_copy[55:70,1:16]

#re-order items
MNKET_pla_reorder<-c("Global ASC", "AV Synesthesia","Changed Meaning of Percept","Complex Imagery",
             "Elementary Imagery","Blissful State","Disembodiment",
             "Experience of Unity","Insightfulness","Spiritual Experience","Anxiety","Impaired Control and Cognition")
MNKET_pla<-MNKET_pla[,MNKET_pla_reorder]

MNPSI_pla_reorder<-c("Global ASC", "AV Synesthesia","Changed Meaning of Percept","Complex Imagery",
                     "Elementary Imagery","Blissful State","Disembodiment",
                     "Experience of Unity","Insightfulness","Spiritual Experience","Anxiety","Impaired Control and Cognition")
MNPSI_pla<-MNPSI_pla[,MNPSI_pla_reorder]

MNKET_drug_reorder<-c("Global ASC", "AV Synesthesia","Changed Meaning of Percept","Complex Imagery",
                      "Elementary Imagery","Blissful State","Disembodiment",
                      "Experience of Unity","Insightfulness","Spiritual Experience","Anxiety","Impaired Control and Cognition")
MNKET_drug<-MNKET_drug[,MNKET_drug_reorder]


MNPSI_drug_reorder<-c("Global ASC", "AV Synesthesia","Changed Meaning of Percept","Complex Imagery",
                      "Elementary Imagery","Blissful State","Disembodiment",
                      "Experience of Unity","Insightfulness","Spiritual Experience","Anxiety","Impaired Control and Cognition")
MNPSI_drug<-MNPSI_drug[,MNPSI_drug_reorder]


#remove Study ID, positive derealization and positive depersonalization 
#MNKET_pla<-MNKET_pla[,-c(2,14,15)]
#MNPSI_pla<-MNPSI_pla[,-c(2,14,15)]
#MNKET_drug<-MNKET_drug[,-c(2,14,15)]
#MNPSI_drug<-MNPSI_drug[,-c(2,14,15)]

#Calculate Item means

MNKET_pla_means<-unname(colMeans(MNKET_pla))  
MNPSI_pla_means<-unname(colMeans(MNPSI_pla))
MNKET_drug_means<-unname(colMeans(MNKET_drug))
MNPSI_drug_means<-unname(colMeans(MNPSI_drug))



#Combine the placebo groups into one data frame and calculate means

library(dplyr)
pla_comb<-bind_rows(MNKET_pla,MNPSI_pla)
placebo_means<-unname(colMeans(pla_comb))


#Calculate the SE
se_MNKET_values <- apply(MNKET_drug, 2, function(x) sd(x) / sqrt(length(x)))
se_MNPSI_values<-apply(MNPSI_drug, 2, function(x) sd(x) / sqrt(length(x)))
se_Placebo_values<-apply(pla_comb, 2, function(x) sd(x) / sqrt(length(x)))


#convert means from numeric to dataframe and plot 

MNKET_drug_df<-data.frame(Item=c("Global ASC", "AV Synesthesia","Changed Meaning of Percept","Complex Imagery",
                                 "Elementary Imagery","Blissful State","Disembodiment",
                                 "Experience of Unity","Insightfulness","Spiritual Experience","Anxiety","Impaired Control and Cognition"),
                          Dimension=c("Global", "VR","VR","VR","VR","OB","OB","OB","OB","OB","DED","DED"),
                          SE=se_MNKET_values,
                          Score = c(MNKET_drug_means))

MNPSI_drug_df<-data.frame(Item=c("Global ASC", "AV Synesthesia","Changed Meaning of Percept","Complex Imagery",
                                 "Elementary Imagery","Blissful State","Disembodiment",
                                 "Experience of Unity","Insightfulness","Spiritual Experience","Anxiety","Impaired Control and Cognition"),
                          Dimension=c("Global", "VR","VR","VR","VR","OB","OB","OB","OB","OB","DED","DED"),
                          SE=se_MNPSI_values,
                          Score = c(MNPSI_drug_means))


Placebo_df<-data.frame(Item=c("Global ASC", "AV Synesthesia","Changed Meaning of Percept","Complex Imagery",
                              "Elementary Imagery","Blissful State","Disembodiment",
                              "Experience of Unity","Insightfulness","Spiritual Experience","Anxiety","Impaired Control and Cognition"),
                       Dimension=c("Global", "VR","VR","VR","VR","OB","OB","OB","OB","OB","DED","DED"),
                       SE= se_Placebo_values,
                       Score = c(placebo_means))


#Update factor
Placebo_df$Item<-factor(Placebo_df$Item, levels = c("Global ASC", "AV Synesthesia","Changed Meaning of Percept","Complex Imagery",
                                                    "Elementary Imagery","Blissful State","Disembodiment",
                                                    "Experience of Unity","Insightfulness","Spiritual Experience","Anxiety","Impaired Control and Cognition"))
Placebo_df$Dimension<-factor(Placebo_df$Dimension, levels= c("Global","VR","OB", "DED"))
MNKET_drug_df$Item<-factor(MNKET_drug_df$Item, levels = c("Global ASC", "AV Synesthesia","Changed Meaning of Percept","Complex Imagery",
                                                          "Elementary Imagery","Blissful State","Disembodiment",
                                                          "Experience of Unity","Insightfulness","Spiritual Experience","Anxiety","Impaired Control and Cognition"))
MNKET_drug_df$Dimension<-factor(MNKET_drug_df$Dimension, levels= c("Global","VR","OB", "DED"))

MNPSI_drug_df$Item<-factor(MNPSI_drug_df$Item, levels = c("Global ASC", "AV Synesthesia","Changed Meaning of Percept","Complex Imagery",
                                                          "Elementary Imagery","Blissful State","Disembodiment",
                                                          "Experience of Unity","Insightfulness","Spiritual Experience","Anxiety","Impaired Control and Cognition"))
MNPSI_drug_df$Dimension<-factor(MNPSI_drug_df$Dimension, levels= c("Global","VR","OB", "DED"))





#SE_MNKET_lower<-(c(MNKET_drug_means)-c(se_MNKET_values))
#SE_MNKET_upper<-(c(MNKET_drug_means)+c(se_MNKET_values))
#SE_MNPSI_lower<-((MNPSI_drug_means)-(se_MNPSI_values))
#SE_MNPSI_upper<-((MNPSI_drug_means)+(se_MNPSI_values))
#SE_Placebo_lower<-((placebo_means)-(se_Placebo_values))
#SE_Placebo_upper<-((placebo_means)+(se_Placebo_values))

#plot 
MNKET_drug_df$Group<- "Ketamine"
MNPSI_drug_df$Group<-"Psilocybin"
Placebo_df$Group<-"Placebo"



# MNKET_drug_df$SE_upper<- se_MNKET_values
# MNKET_drug_df$SE_lower<- se_MNKET_values
# MNPSI_drug_df$SE_upper<-se_MNPSI_values
# MNPSI_drug_df$SE_lower<-se_MNPSI_values
# Placebo_df$SE_upper<-se_Placebo_values
# Placebo_df$SE_lower<-se_Placebo_values

linetype_vector = c(rep("solid",12),rep("solid",12),rep("dashed",12))

combined_df<-bind_rows(MNKET_drug_df,MNPSI_drug_df,Placebo_df)
subset_df <- combined_df[combined_df$Dimension == 'OB', ]
subset_df_2 <- combined_df[combined_df$Dimension == 'DED', ]


plot<-ggplot(combined_df, aes(x = Item, y = Score, color = Group, group=Group, linetype=Group, shape=Group)) +
  geom_line() +
  geom_point(size = 1.5)+
  coord_cartesian(ylim = c(0, 60)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))+
  labs(title = "",
       x = "",
       y = "% score of scale maximum") +
  theme(legend.position = c(0.92, 0.8), legend.background = element_blank(), legend.title = element_blank(),legend.key = element_rect(fill='white'))+
  scale_linetype_manual(values = c("solid","solid","dashed"))+
  scale_shape_manual(values = c("circle", "circle", "circle")) +
  scale_color_manual(values = c("black", "darkgrey", "black"))+
  geom_text(data = subset_df, aes(x = 2.2, y = 41, label = "**"), size = 5, color = "black") +
  geom_text(data = subset_df_2, aes(x = 2.2, y = 31, label = "*"), size = 5, color = "black")+
  geom_errorbar(aes(ymin = Score - SE, ymax = Score + SE), linetype= "solid", width = 0.2) +
  facet_grid( ~ Dimension, scales='free_x', space= 'free_x')+
  guides(linetype = guide_legend(override.aes = list(linetype = c("solid", "solid", "dashed"), 
                                                   size = c(0.8, 0.8, 0.8))))
print(plot)
full_path <- "/Users/gabriellea/Desktop/your_plot_filename.png"

ggsave(full_path, plot, dpi = 600)
#-------------------------------------------------------------------------------
# Calculate t tests 
#-------------------------------------------------------------------------------
data_frames <- list(MNKET_pla, MNPSI_pla)
t_test_results <- list()

# Loop through the data frames and perform t-tests
for (i in 1:(length(data_frames) - 1)) {
  for (j in (i + 1):length(data_frames)) {
    MNKET_pla <- data_frames[[i]]
    MNPSI_pla <- data_frames[[j]]
    
    for (col1 in colnames(MNKET_pla)) {
      for (col2 in colnames(MNPSI_pla)) {
        t_test_result <- t.test(MNKET_pla[[col1]], MNPSI_pla[[col2]])
        result_name <- paste0("T-Test_", col1, "_vs_", col2, "_between_", names(data_frames)[i], "_and_", names(data_frames)[j])
        t_test_results[[result_name]] <- t_test_result
      }
    }
  }
}

# Print the t-test results
for (result_name in names(t_test_results)) {
  print(paste(result_name, "p-value:", t_test_results[[result_name]]$p.value,"T-stat:",t_test_results[[result_name]]$statistic,"Df",t_test_results[[result_name]]$parameter ))
}


#-----------------------------------------
#Create table
#-----------------------------------------


