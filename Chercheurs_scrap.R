library(rvest) 
library(tidyverse) 
library(DT)

# Création dataframe
Nom <- c("Raoult", "Raoult","Louisia","Louisia","Louisio","Rochut","Blasco","Rochut")
Prenom <- c("Didier", "Bernard","Jean","Stephane","Karim","Julie","Sylvie","Sylvie")

df <- data.frame(Nom, Prenom)
vitesse<-1


Nb_noms<-length(df$Nom)

for (i in 1:Nb_noms) {
  Nom<-df[i,"Nom"]
  Prenom<-df[i,"Prenom"] 
  structure_requete_gauche<-"https://scholar.google.com/scholar?hl=fr&as_sdt=1%2C5&as_vis=1&q=" 
  structure_requete_droite<-"&btnG="
  df[i,"recherche_google"] <- paste(paste(structure_requete_gauche,paste(Prenom,Nom,sep="+"),sep=""),structure_requete_droite,sep ="")
}


# verification presence dans scholar google
for (i in 1:Nb_noms) {
  existe <- paste(str_sub(df[i,"Prenom"],1,1),df[i,"Nom"]) 
  google <- read_html(df[i,"recherche_google"])
  auteurs <- google%>%html_nodes(".gs_a")%>%html_text() 
  df[i,"existence"]<-str_detect(auteurs[1],existe)
  print(i)
  print(auteurs)
  Sys.sleep(vitesse)
  datatable(df)
}

#ajout des publications
for (i in 1:Nb_noms) {
  google <- read_html(df[i,"recherche_google"])
  publications <- google%>%html_nodes(".gs_rt")%>%html_text()
  publications2 <- paste(publications[1],publications[2],publications[3],sep=" ; ")
  if (df[i,"existence"]==FALSE){
    df[i,"publications"]<-"Aucune"
    }
  else {df[i,"publications"]<-publications2}
  print(i)
  print(publications2)
  Sys.sleep(vitesse)
} 
datatable(df)