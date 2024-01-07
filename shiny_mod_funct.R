#load all modules from R folder
# load_modules <- function(){
#   invisible(sapply(list.files("R", full.names = TRUE, pattern = "\\.[rR]$"), source))
# }

#create new module
add_module <- function(module_name){
  
  file_name = sprintf("%s.R", module_name)
  
  abs_path <- fs::path_abs(getwd())
  
  if(dir.exists(paste0(abs_path, "/R"))==FALSE){
    dir.create(paste0(abs_path, "/R"))
  } else {
    invisible(NULL)
  }
  
  setwd(paste0(abs_path, "/R"))
  
  file.create(file_name)
  
  # write("#' test_module\n#'", file = file_name, append = TRUE)
  # write("#' @description A shiny Module\n#'", file = file_name, append = TRUE)
  # write("#' @param id,input,output,session Internal parameters for {shiny}.\n#'", file = file_name, append = TRUE)
  # write("#' @return complete module.\n#'", file = file_name, append = TRUE)
  # write("#' @export", file = file_name, append = TRUE)
  # write("#' @import shiny", file = file_name, append = TRUE)
  # write("#' @noRd", file = file_name, append = TRUE)
  
  write(sprintf("%s_ui <- function(id) {", module_name), file = file_name, append = TRUE)
  write("\tns <- NS(id)", file = file_name, append = TRUE)
  write("\ttagList(", file = file_name, append = TRUE)
  write("\t\t#shiny objects go here", file = file_name, append = TRUE)
  write("\t)", file = file_name, append = TRUE)
  write("}\n", file = file_name, append = TRUE)
  
  write(sprintf("%s_server <- function(id) {", module_name), file = file_name, append = TRUE)
  write("\tmoduleServer(id, function(input, output, session) {", file = file_name, append = TRUE)
  write("\t\t#shiny objects go here", file = file_name, append = TRUE)
  write("\t})", file = file_name, append = TRUE)
  write("}", file = file_name, append = TRUE)
  
  on.exit(setwd(abs_path))
}

#create sub-directories
make_r_folders <- function(){
  
  if(dir.exists("R")==FALSE){
    dir.create("R")
  }
  
  if(dir.exists("www")==FALSE){
    dir.create("www")
  }
  
  if(dir.exists("data")==FALSE){
    dir.create("data")
  }
  
  # if(dir.exists("dev")==FALSE){
  #   dir.create("dev")
  # }
  
  print("Directory setup complete.")
  
}

make_r_files <- function(){
  
  if(file.exists("app.R")==FALSE){
    file.create("app.R")
  }
  
  write("ui <- page_fluid(", file = "app.R", append = TRUE)
  write("#module UI goes here", file = "app.R", append = TRUE)
  write("\t)\n\n", file = "app.R", append = TRUE)
  
  write("server <- function(input, output, session) {", file = "app.R", append = TRUE)
  write("#module server goes here", file = "app.R", append = TRUE)
  write("\t}\n\n", file = "app.R", append = TRUE)
  
  write("shinyApp(ui, server)", file = "app.R", append = TRUE)
  
  if(dir.exists("R")==FALSE){
    make_r_folders()
  }
  
  if(file.exists("R/global.R")==FALSE){
    file.create("R/global.R")
  }
  
  write("library(shiny)", file = "R/global.R", append = TRUE)
  write("library(dplyr)", file = "R/global.R", append = TRUE)
  write("library(readr)", file = "R/global.R", append = TRUE)
  write("library(tidyr)", file = "R/global.R", append = TRUE)
  write("library(bslib)", file = "R/global.R", append = TRUE)
  write("library(plotly)", file = "R/global.R", append = TRUE)
  
  # file.copy(from = "G:\\Surveillance\\R Scripts\\Building Shiny Apps\\shiny_mod_funct.R", to = "dev")
  
  print("R files setup complete.")
}
