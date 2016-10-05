## sourcing from radiant.data
options(radiant.path.data = system.file(package = "radiant.data"))
source(file.path(getOption("radiant.path.data"), "app/global.R"),
       encoding = getOption("radiant.encoding", default = "UTF-8"), local = TRUE)

## set path for package
ifelse (grepl("radiant.dose", getwd()) && file.exists("../../inst") , "..",
        system.file(package = "radiant.dose")) %>%
  options(radiant.path.dose = .)


## loading urls and ui
source("init.R", encoding = getOption("radiant.encoding"), local = TRUE)

# word to login for this session
#Edit_pass <- "foo"
Logged <- FALSE
PASSWORD <- data.frame(Brukernavn = c("withr","admin"),
                       Passord = c("25d55ad283aa400af464c76d713c07ad",
                                   "caf973c16410b87b3a996405f421ec14"))



## session authentified
sessionList <- c("Mezhoud", "Sassi")

## IP authentification
ipList <- c("192.168.1.66", "192.168.13.111","192.168.1.73",
            "192.168.1.2")
