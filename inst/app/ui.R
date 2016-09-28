## ui for data menu in radiant
do.call(navbarPage,
  c("Radiant Doser",
    getOption("radiant.nav_ui"),
    getOption("Edit_Panel"),
    getOption("radiant.shared_ui"),
    help_menu("help_data_ui"))
)

